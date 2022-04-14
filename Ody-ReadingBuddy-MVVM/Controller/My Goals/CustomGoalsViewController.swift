//
//  CustomGoalsViewController.swift
//  Ody-ReadingBuddy
//
//  Created by Hilmy Veradin on 08/04/22.
//

import Foundation
import UIKit

class CustomGoalsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.isScrollEnabled = false
    }
  }
  @IBOutlet weak var saveSettingButton: UIButton!
  
  var weekdays: Weekdays?
  
  var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  var daysDict = [
    "Sunday" : false,
    "Monday": false,
    "Tuesday": false,
    "Wednesday" : false,
    "Thursday" : false,
    "Friday" : false,
    "Saturday" : false
  ]
  var daysIndex = [
    "Sunday" : 1,
    "Monday": 2,
    "Tuesday": 3,
    "Wednesday" : 4,
    "Thursday" : 5,
    "Friday" : 6,
    "Saturday" : 7
  ]
  var selectedDaysString = [String]()
  var selectedDaysIndex = [Int]()
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    saveSettingButton.layer.cornerRadius = 10
  }
  
  //MARK: - Button Actions
  
  @IBAction func saveSettingsPressed(_ sender: UIButton!) {
    let alert = UIAlertController(title: "Custom Days Saved", message: "You have sucessfully saved your days preferences" , preferredStyle: .alert)
    alert.view.tintColor = UIColor.init(named: "BoldOrange-Color")
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
      CoreDataManager.manager.insertWeekday(weekArray: self.selectedDaysIndex)
      NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
    getSelectedDays()
    print(selectedDaysIndex)
  }
  
  //MARK: - Function Helpers
  
  private func getSelectedDays() {
    selectedDaysString = daysDict.allKeys(forValue: true)
    for string in selectedDaysString {
      if daysIndex[string] != nil {
        selectedDaysIndex.append(daysIndex[string]!)
      }
    }
  }
}


// MARK: - Talble Data Source
extension CustomGoalsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "CUSTOM DAYS"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    days.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = days[indexPath.row]
    return cell
  }
}

// MARK: - Table Delegate
extension CustomGoalsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if daysDict[days[indexPath.row]] == true {
      daysDict[days[indexPath.row]] = false
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
      
    } else {
      daysDict[days[indexPath.row]] = true
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
  }
}


