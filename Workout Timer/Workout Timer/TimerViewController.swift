//
//  TimerViewController.swift
//  Workout Timer
//
//  Created by Max Bothe on 13/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import UIKit

class TimerViewController : UIViewController {

    @IBAction func cancelTimer(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
