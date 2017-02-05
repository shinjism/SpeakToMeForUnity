//
//  SpeakToMeForUnity.mm
//  Unity-iPhone
//
//  Created by Shinji Hayai on 2017/02/05.
//
//

#import <Speech/Speech.h>
#import "SpeakToMeForUnity-Swift.h"

extern "C"
{
    void _prepareRecording()
    {
        SpeakToMeForUnity *instance = [SpeakToMeForUnity sharedInstance];
        [instance prepareRecording];
    }

    void _recordButtonTapped()
    {
        SpeakToMeForUnity *instance = [SpeakToMeForUnity sharedInstance];
        [instance recordButtonTapped];
    }
}
