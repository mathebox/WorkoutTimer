//
//  SettingsViewController.swift
//  Workout Timer
//
//  Created by Max Bothe on 14/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import UIKit

class SettingsViewController : UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let counddownDurationKey = "countdown-duration"
    var countdownPickerIndexPath : NSIndexPath?

    @IBAction func dismissSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.countdownPickerIndexPath != nil {
            return 2
        }
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "countdown-time"
        if self.countdownPickerIndexPath == indexPath {
            cellId = "countdown-picker"
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)

        if cellId == "countdown-time" {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let duration = defaults.integerForKey(self.counddownDurationKey) as Int?
            {
                var durationText = "\(duration) sec"
                if duration == 0 {
                    durationText = "disabled"
                }
                cell?.detailTextLabel?.text = durationText
            }

        }

        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.countdownPickerIndexPath == indexPath {
            return 216
        }
        return self.tableView.rowHeight
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            self.displayInlineDatePickerForRowAtIndexPath(indexPath)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func displayInlineDatePickerForRowAtIndexPath(indexPath: NSIndexPath) {
        self.tableView.beginUpdates()

        var sameCellClicked = false
        if let pickerIndexPath = self.countdownPickerIndexPath {
            sameCellClicked = (pickerIndexPath.row - 1 == indexPath.row)
            // remove any countdown picker cell if it exists
            self.tableView.deleteRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Automatic)
            self.countdownPickerIndexPath = nil
        }

        if !sameCellClicked {
            self.toggleCountdownPickerForSelectedIndexPath(indexPath)
            self.countdownPickerIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
        }

        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.tableView.endUpdates()
        self.updateCountdownPicker()
    }

    func toggleCountdownPickerForSelectedIndexPath(indexPath: NSIndexPath) {
        self.tableView.beginUpdates()

        let pickerIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
        if self.hasPickerForIndexPath(pickerIndexPath) {
            self.tableView.deleteRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Automatic)
        } else {
            self.tableView.insertRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Automatic)
        }

        self.tableView.endUpdates()
    }

    func hasPickerForIndexPath(indexPath: NSIndexPath) -> Bool {
        let targetedIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
        let pickerCell = self.tableView.cellForRowAtIndexPath(targetedIndexPath)
        return ((pickerCell?.viewWithTag(99) as? UIPickerView) != nil)
    }

    func updateCountdownPicker() {
        if let pickerIndexPath = self.countdownPickerIndexPath {
            let pickerCell = self.tableView.cellForRowAtIndexPath(pickerIndexPath)
            if let picker = pickerCell?.viewWithTag(99) as? UIPickerView {
                let defaults = NSUserDefaults.standardUserDefaults()
                if let duration = defaults.integerForKey(self.counddownDurationKey) as Int?
                {
                    picker.selectRow(duration, inComponent: 0, animated: false)
                }
            }
        }
    }

    // MARK: UIPickerView

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 31
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "disabled"
        }
        return "\(row)"
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(row, forKey: self.counddownDurationKey)
        defaults.synchronize()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}
