//
//  VoiceViewController.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/20/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceViewController: UIViewController {
    
    //MARK: - Types
    struct UIConstants {
        static let promptLabelPromptText = "say ahoyy"
        static let promptLabelListeningText = "what yer say?"
        static let promptLabelMisheardText = "Just kidding, this feature isn't implemented yet"
    }
    
    //MARK: - Properties
    var recorder: AVAudioRecorder?
    var levelTimer: NSTimer?
    var fakeListenTimer: NSTimer?
    
    @IBOutlet weak var voiceButtonToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var voiceButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var pulsingRing: RingView!
    @IBOutlet weak var pulsingVoiceView: PulsingVoiceView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        prepareAndBeginRecording()
    }
        
    func setupViews() {
        promptLabel.text = UIConstants.promptLabelPromptText
    }

    func prepareAndBeginRecording() {
        let url = NSURL(fileURLWithPath: "/dev/null")
        let settings: [String : AnyObject] = [AVSampleRateKey : 44100.0, AVFormatIDKey : kAudioFormatAppleLossless, AVNumberOfChannelsKey : 1, AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue, AVEncoderBitRateKey : 320000]
        var error: NSError?
        recorder = AVAudioRecorder(URL: url, settings: settings, error: &error)
        
        if let recorder = recorder {
            recorder.prepareToRecord()
            recorder.meteringEnabled = true
            recorder.record()
            levelTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "measureAudio:", userInfo: nil, repeats: true)
            fakeListenTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "listenToWords:", userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pulsingRing.startPeriodicPulsing(1.2)
        delay(0.2) { [unowned self] in
            self.pulsingRing.shootPulse(1.2)
            }
        pulsingVoiceView.beginFluctuations(0.1)
    }
    
    override func viewDidDisappear(animated: Bool) {
        levelTimer?.invalidate()
        fakeListenTimer?.invalidate()
        pulsingVoiceView.endFluctuations()
    }

    //MARK: - IBActions
    @IBAction func voiceButtonPressed(sender: UIButton) {
    }

    @IBAction func closeButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func measureAudio(timer: NSTimer) {
        if let recorder = recorder {
            recorder.updateMeters()
            let dec = recorder.peakPowerForChannel(0)
            let level = max(powf(10, dec/10), 0.2)
            pulsingVoiceView.pulsate(level)
        }
    }
    
    func listenToWords(timer: NSTimer) {
        if promptLabel.text == UIConstants.promptLabelPromptText {
            promptLabel.text = UIConstants.promptLabelListeningText
        } else if promptLabel.text == UIConstants.promptLabelListeningText {
            promptLabel.text = UIConstants.promptLabelMisheardText
        }
    }
    

}
