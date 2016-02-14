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
    var duration = 0
    var countdownDuration = 10
    var timer : NSTimer?
    var delegate : TimerDelegate? {
        didSet {
            self.delegate?.updateText("\(self.countdownDuration)")
        }
    }
    var formattedDuration: String {
        return String(format: "%d:%02d", self.duration/60, self.duration%60)
    }

    override init() {
        super.init()
        self.numberFormatter.numberStyle = NSNumberFormatterStyle.SpellOutStyle
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
        self.duration--
        if self.duration == 0 {
            self.delegate?.updateText("Done")
            self.timer?.invalidate()
        } else {
            self.delegate?.updateText(self.formattedDuration)
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

    func say(text: String) {
        let myUtterance = AVSpeechUtterance(string: text)
        self.synth.speakUtterance(myUtterance)
    }
}
