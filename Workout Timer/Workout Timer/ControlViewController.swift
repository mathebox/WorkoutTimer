//
//  ViewController.swift
//  Workout Timer
//
//  Created by Max Bothe on 13/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let durationKey = "durationKey"

    @IBOutlet var timePicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var duration = 10*60
        let defaults = NSUserDefaults.standardUserDefaults()
        if let lastDuration = defaults.integerForKey(self.durationKey) as Int?
        {
            if lastDuration > 0 {
                duration = lastDuration
            }
        }

        self.timePicker.selectRow(duration/60, inComponent: 0, animated: false)
        self.timePicker.selectRow(duration%60, inComponent: 2, animated: false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let timerVC = segue.destinationViewController as? TimerViewController {
            let duration = self.timePicker.selectedRowInComponent(0)*60 + self.timePicker.selectedRowInComponent(2)
            timerVC.duration = duration
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 100
        case 2:
            return 60
        default:
            return 1
        }
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label : UILabel
        if let lab = view as? UILabel {
            label = lab
        } else {
            label = UILabel()
            label.font = UIFont.systemFontOfSize(60, weight: UIFontWeightThin)
        }

        switch component {
        case 0:
            label.text = String(format: "%d", row)
            label.textAlignment = NSTextAlignment.Right
        case 2:
            label.text = String(format: "%02d", row)
            label.textAlignment = NSTextAlignment.Left
        default:
            label.text = ""
            label.textAlignment = NSTextAlignment.Center
        }

        return label
    }

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }

    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 1{
            return 20
        }
        return 100
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let duration = self.timePicker.selectedRowInComponent(0)*60 + self.timePicker.selectedRowInComponent(2)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(duration, forKey: self.durationKey)
    }

}

