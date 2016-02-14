//
//  TimerViewController.swift
//  Workout Timer
//
//  Created by Max Bothe on 13/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import UIKit

class TimerViewController : UIViewController, TimerDelegate {
    let timer = Timer()
    var duration = 0 {
        didSet {
            self.timer.duration = self.duration
        }
    }
    @IBOutlet var timerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.timer.start()
    }

    @IBAction func cancelTimer(sender: AnyObject) {
        self.timer.stop()
        self.navigationController?.popViewControllerAnimated(true)
    }

    func updateText(text: String) {
        self.timerLabel.text = text
    }
}
