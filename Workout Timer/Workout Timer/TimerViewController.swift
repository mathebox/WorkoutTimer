//
//  TimerViewController.swift
//  Workout Timer
//
//  Created by Max Bothe on 13/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import UIKit

class TimerViewController : UIViewController {
    var duration = 0
    var timer : NSTimer?

    @IBOutlet var timerLabel: UILabel!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.timerLabel.text = self.formattedTime()
        self.startTimer()
    }

    func startTimer() {
        if let t = self.timer {
            t.invalidate()
        }

        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDown", userInfo: nil, repeats: true)
    }

    func countDown() {
        self.duration--
        if self.duration == 0 {
            self.timerLabel.text =  "Done"
            self.timer?.invalidate()
        } else {
            self.timerLabel.text = self.formattedTime()
        }
    }

    func formattedTime() -> String {
        return String(format: "%d:%02d", self.duration/60, self.duration%60)
    }

    @IBAction func cancelTimer(sender: AnyObject) {
        if let t = self.timer {
            t.invalidate()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
