//
//  RecordSoundsVC.swift
//  RecordAudioProject
//
//  Created by Shouqiang Wei de Mac on 2017/3/4.
//  Copyright © 2017年 alston. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var lblTips: UILabel!
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnStop.isEnabled = false
        btnRecord.isEnabled = true
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        btnStop.isEnabled = true
        btnRecord.isEnabled = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = URL.init(string: pathArray.joined(separator: "/"))
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord,with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder.init(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func recordStop(_ sender: Any) {
        
        btnStop.isEnabled = false
        btnRecord.isEnabled = true
        lblTips.text = "tap to record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playVC = segue.destination as! PlaySoundsVC
            let audioURL = sender as! URL
            playVC.recordedAudioURL = audioURL
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording")
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
}

