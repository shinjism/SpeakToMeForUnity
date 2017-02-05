//
//  SpeakToMeForUnity.swift
//  Unity-iPhone
//
//  Created by Shinji Hayai on 2017/02/05.
//
//

class SpeakToMeForUnity : NSObject, SFSpeechRecognizerDelegate {
    
    fileprivate var speechRecognizer : SFSpeechRecognizer?
    fileprivate var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask : SFSpeechRecognitionTask?
    fileprivate var audioEngine : AVAudioEngine?
    
    static let sharedInstance = SpeakToMeForUnity()
    
    override fileprivate init() {
        super.init()
        
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
        self.audioEngine = AVAudioEngine()
        
        self.speechRecognizer?.delegate = self
    }
    
    func prepareRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.updateButton(true, title: "Start recording")
                    
                case .denied:
                    self.updateButton(false, title: "User denied access to speech recognition")
                    
                case .restricted:
                    self.updateButton(false, title: "Speech recognition restricted on this device")
                    
                case .notDetermined:
                    self.updateButton(false, title: "Speech recognition not yet authorized")
                }
            }
        }
    }
    
    fileprivate func startRecording() throws {
        // Cancel the previous task if it's running.
        if let recognitionTask = self.recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = self.audioEngine?.inputNode else {
            fatalError("Audio engine has no input node")
        }
        guard let recognitionRequest = self.recognitionRequest else {
            fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
        }
        
        // Configure request so that results are returned before audio recording is finished
        self.recognitionRequest?.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.updateField(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine?.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.updateButton(true, title: "Start recording")
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine?.prepare()
        
        try self.audioEngine?.start()
        
        self.updateField("")
    }
    
    // MARK: SFSpeechRecognizerDelegate
    internal func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.updateButton(true, title: "Start recording")
        } else {
            self.updateButton(false, title: "Recognition not available")
        }
    }
    
    // MARK: Interface Builder actions
    func recordButtonTapped() {
        if (self.audioEngine?.isRunning)! {
            self.audioEngine?.stop()
            self.recognitionRequest?.endAudio()
            self.updateButton(false, title: "Stopping...")
        } else {
            try! self.startRecording()
            self.updateButton(true, title: "Stop recording")
        }
    }
    
    fileprivate func updateButton(_ isEnabled: Bool, title: String) {
        UnitySendMessage("RecordButton", "OnCallback", "\(isEnabled):\(title)")
    }
    
    fileprivate func updateField(_ text: String) {
        UnitySendMessage("SpeechField", "OnCallback", text)
    }
}
