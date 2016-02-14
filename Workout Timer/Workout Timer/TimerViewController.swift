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
        if self.timer.isRunning {
            let alertController = UIAlertController(title: "Stop Timer", message: "Do you really want to stop the timer?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)

            let destroyAction = UIAlertAction(title: "Stop", style: .Destructive) { (action) in
                self.timer.stop()
                self.navigationController?.popViewControllerAnimated(true)

            }
            alertController.addAction(destroyAction)

            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    func updateText(text: String) {
        self.timerLabel.text = text
    }
}
