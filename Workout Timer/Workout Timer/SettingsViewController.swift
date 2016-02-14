//
//  SettingsViewController.swift
//  Workout Timer
//
//  Created by Max Bothe on 14/02/16.
//  Copyright © 2016 Max Bothe. All rights reserved.
//

import UIKit

enum TimerSpeechOption : String {
    case None = "None"
    case ToGo = "To Go"
    case Past = "Past"
    static let allValues = [None, ToGo, Past]
}

class SettingsViewController : UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let counddownDurationKey = "countdown-duration"
    let timerSpeechKey = "timer-speech"
    var countdownPickerIndexPath : NSIndexPath?

    @IBAction func dismissSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.countdownPickerIndexPath != nil {
                return 2
            }
            return 1
        }
        return TimerSpeechOption.allValues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId : String
        if indexPath.section == 0{
            if self.countdownPickerIndexPath == indexPath {
                cellId = "countdown-picker"
            } else {
                cellId = "countdown-time"
            }
        } else {
            cellId = "timer-speech"
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)

        let defaults = NSUserDefaults.standardUserDefaults()
        if cellId == "countdown-time" {
            if let duration = defaults.integerForKey(self.counddownDurationKey) as Int? {
                var durationText = "\(duration) sec"
                if duration == 0 {
                    durationText = "disabled"
                }
                cell?.detailTextLabel?.text = durationText
            }
        } else if cellId == "timer-speech" {
            let text = TimerSpeechOption.allValues[indexPath.row].rawValue
            cell?.textLabel?.text = text
            if defaults.stringForKey(self.timerSpeechKey) == text {
                cell?.accessoryType = .Checkmark
            }
        }

        return cell!
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Countdown"
        }
        return "Timer Speech Options"
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
        } else if indexPath.section == 1 {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let oldOption = defaults.stringForKey(self.timerSpeechKey) {
                if let value = TimerSpeechOption(rawValue: oldOption) {
                    if let row = TimerSpeechOption.allValues.indexOf(value) {
                        let indexPath = NSIndexPath(forRow: row, inSection: 1)
                        self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
                    }
                }
            }
            let newOption = TimerSpeechOption.allValues[indexPath.row].rawValue
            defaults.setObject(newOption, forKey: self.timerSpeechKey)
            defaults.synchronize()
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
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
