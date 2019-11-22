//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Philip on 10/2/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var secondTap: Bool = false

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        if secondTap == false {
            recordLabel.text = "Recording..."
        
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName: String = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            secondTap = true
        } else {
            recordLabel.text = "Tap to record"
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
            secondTap = false
        }

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("something went wrong")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
