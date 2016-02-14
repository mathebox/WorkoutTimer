//
//  Timer.swift
//  Workout Timer
//
//  Created by Max Bothe on 14/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import Foundation
import AVFoundation


protocol TimerDelegate {
    func updateText(text: String)
}


class Timer : NSObject {
    let synth = AVSpeechSynthesizer()
    let numberFormatter = NSNumberFormatter()
    var remainingDuration = 0
    var duration = 0 {
        didSet {
            self.remainingDuration = self.duration
        }
    }
    var countdownDuration = 10
    var timer : NSTimer?
    var speechOption = TimerSpeechOption.None
    var delegate : TimerDelegate? {
        didSet {
            if self.countdownDuration > 0 {
                self.delegate?.updateText("\(self.countdownDuration)")
            } else {
                self.delegate?.updateText("")
            }
        }
    }
    var formattedDuration: String {
        return String(format: "%d:%02d", self.remainingDuration/60, self.remainingDuration%60)
    }

    override init() {
        super.init()
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.SpellOutStyle
        let defaults = NSUserDefaults.standardUserDefaults()
        if let countdownDuration = defaults.integerForKey("countdown-duration") as Int? {
            self.countdownDuration = countdownDuration
        }
        if let speechOptionString = defaults.stringForKey("timer-speech") as String? {
            if let speechOption = TimerSpeechOption(rawValue: speechOptionString) {
                self.speechOption = speechOption
            }
        }
    }

    func start() {
        if let t = self.timer {
            t.invalidate()
        }

        self.countdownDuration++
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDown", userInfo: nil, repeats: true)
    }

    func stop() {
        if let t = self.timer {
            t.invalidate()
        }
    }

    func countDown() {
        self.countdownDuration--
        if self.countdownDuration == 0 {
            self.delegate?.updateText(self.formattedDuration)
            self.timer?.invalidate()
            self.say("go")
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        } else {
            self.delegate?.updateText("\(self.countdownDuration)")
        }

        if self.countdownDuration > 0 {
            saySomethingForDuration(self.countdownDuration)
        }
    }

    func timerAction() {
        self.remainingDuration--
        if self.remainingDuration == 0 {
            self.delegate?.updateText("Done")
            self.timer?.invalidate()
        } else {
            self.delegate?.updateText(self.formattedDuration)
        }

        if self.remainingDuration == 0 {
            self.say("done")
        } else {
            self.saySomethingForDuration(self.remainingDuration)
        }
    }

    func saySomethingForDuration(duration: Int) {
        if duration <= 10 {
            if let text = self.numberFormatter.stringFromNumber(duration) {
                self.say(text)
            }
        } else if self.speechOption == .ToGo {
            if duration % 60 == 0 {
                let minutes = duration / 60
                if minutes == 1 {
                    self.say("1 minute to go")
                } else {
                    if let text = self.numberFormatter.stringFromNumber(minutes) {
                        self.say("\(text) minutes to go")
                    }
                }
            }
        } else if self.speechOption == .Past {
            let timePast = self.duration - self.remainingDuration
            if timePast % 60 == 0 {
                let minutes = timePast / 60
                if minutes == 1 {
                    self.say("1 minute")
                } else {
                    if let text = self.numberFormatter.stringFromNumber(minutes) {
                        self.say("\(text) minutes")
                    }
                }
            }
        }
    }

    func say(text: String) {
        let myUtterance = AVSpeechUtterance(string: text)
        self.synth.speakUtterance(myUtterance)
    }
}
