# SpeakToMe For Unity

アップル社によって公開されている音声認識を扱ったサンプルコード [SpeakToMe: Using Speech Recognition with AVAudioEngine](https://developer.apple.com/library/content/samplecode/SpeakToMe/Introduction/Intro.html) の Unity 版です。


## 機能概要

ユーザーの発言を記録してテキストに変換・表示します。

- iOS 10 から実装された Speech Framework による音声認識を Native Plugin 化して利用しています。
- 認識した音声はテキストへ変換後、コールバックによって Unity 側の UI で表示します。
- 実用に際しては、マイクや通信回線の状態チェックが必要になるものと考えられます。


## 開発・検証環境

本サンプルは次の環境で開発・検証を行いました。

- Unity 5.5.3f1
- Xcode 8.2.1
- iOS 10.2.1


## 操作方法

1. Start recording ボタンをタップして開始
2. iOS デバイスに向かって発言（音声認識結果はリアルタイムでテキスト変換・表示）
3. Stop recording ボタンをタップして終了


## スクリーンショット

![SpeakToMeForUnityのスクリーンショット](https://raw.githubusercontent.com/shinjism/Screenshot/master/SpeakToMeForUnity.png)


## 著作権・免責事項等

- 本サンプルコードを使用したことによる使用者の損害または損失について、開発者および提供者はいかなる責任も負いません。
- 本サンプルコードの使い方や不具合についての質問には、開発者および提供者は回答の義務を負いません。
- オリジナルの [SpeakToMe: Using Speech Recognition with AVAudioEngine](https://developer.apple.com/library/content/samplecode/SpeakToMe/Introduction/Intro.html) について、著作権その他の知的財産権はアップル社に帰属します。
