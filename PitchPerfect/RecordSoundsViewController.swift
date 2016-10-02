//
//  RecordSoundsViewController
//  PitchPerfect
//
//  Created by Dinarte Jesus on 5/29/16.
//  Copyright © 2016 Dinarte Jesus. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingProgressMessage = "Recording in progress!"
        static let RecordingReadyMessage = "Tap to Record"
        static let AudioRecordedFailedTitle = "Audio Recorded Failed on Saving"
        static let AudioRecordedFailedMessage = "Something went wrong with when saving recorded file."
    }
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        recordingLabel.text = Alerts.RecordingProgressMessage
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        stopRecordingButton.isHidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        recordButton.isEnabled = true
        stopRecordingButton.isHidden = false
        stopRecordingButton.isEnabled = false
        recordingLabel.text = Alerts.RecordingReadyMessage
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isHidden = true
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showAlert(Alerts.AudioRecordedFailedTitle, message: Alerts.AudioRecordedFailedMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

