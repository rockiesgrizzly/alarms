import AVFoundation
import os.log
import SwiftUI

/// Presents a UIAlert to the user with audio. Dismissing the alert silences the audio.
struct AlarmAlertPresenter {
    private static var audioPlayer: AVAudioPlayer?
    private static let logger = Logger(subsystem: "Alarm", category: "UseCaseTriggerAlarmAlert")
    
    static func trigger(with alarm: AlarmModel) {
        let alert = UIAlertController(title: "Alarm", message: alarm.dateString, preferredStyle: .alert)
        let alertAction = UIAlertAction(title:"Dismiss", style: .cancel) {_ in 
            silenceAlarmAudio()
        }
        alert.addAction(alertAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(alert, animated: true)
        }
        
        playAudio(alarm.sound)
    }
    
    private static func playAudio(_ sound: AlarmSound) {
        guard let soundUrl = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else { return }
        
        do {
            AlarmAlertPresenter.audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            AlarmAlertPresenter.audioPlayer?.numberOfLoops = .max
            AlarmAlertPresenter.audioPlayer?.play()
        } catch {
            AlarmAlertPresenter.logger.debug("alert audio failed: \(error.localizedDescription)")
        }
    } 
    
    private static func silenceAlarmAudio() {
        AlarmAlertPresenter.audioPlayer?.stop()
        AlarmAlertPresenter.audioPlayer = nil
    }
}

