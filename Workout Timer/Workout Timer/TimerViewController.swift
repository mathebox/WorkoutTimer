//
//  TimerViewController.swift
//  Workout Timer
//
//  Created by Max Bothe on 13/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController : UIViewController {
    let synth = AVSpeechSynthesizer()
    let numberFormatter = NSNumberFormatter()
    var duration = 0
    var countdownDuration = 10
    var timer : NSTimer?

    @IBOutlet var timerLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.SpellOutStyle
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.timerLabel.text = "\(self.countdownDuration)"
        self.startTimer()
    }

    func startTimer() {
        if let t = self.timer {
            t.invalidate()
        }

        self.countdownDuration++
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDown", userInfo: nil, repeats: true)
    }

    func countDown() {
        self.countdownDuration--
        if self.countdownDuration == 0 {
            self.timerLabel.text = self.formattedTime()
            self.timer?.invalidate()
            self.say("go")
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        } else {
            self.timerLabel.text = "\(self.countdownDuration)"
        }

        if self.countdownDuration > 0 {
            saySomethingForDuration(self.countdownDuration)
        }
    }

    func timerAction() {
        self.duration--
        if self.duration == 0 {
            self.timerLabel.text =  "Done"
            self.timer?.invalidate()
        } else {
            self.timerLabel.text = self.formattedTime()
        }

        if self.duration == 0 {
            self.say("done")
        } else {
            self.saySomethingForDuration(self.duration)
        }
    }

    func saySomethingForDuration(duration: Int) {
        if duration <= 10 {
            if let text = self.numberFormatter.stringFromNumber(duration) {
                self.say(text)
            }
        }
    }

    func formattedTime() -> String {
        return String(format: "%d:%02d", self.duration/60, self.duration%60)
    }

    func say(text: String) {
        let myUtterance = AVSpeechUtterance(string: text)
        self.synth.speakUtterance(myUtterance)
    }

    @IBAction func cancelTimer(sender: AnyObject) {
        if let t = self.timer {
            t.invalidate()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
