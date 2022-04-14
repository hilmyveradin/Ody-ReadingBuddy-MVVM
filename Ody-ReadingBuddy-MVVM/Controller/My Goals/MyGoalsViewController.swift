//
//  MyGoalsViewController.swift
//  Ody-ReadingBuddy
//
//  Created by Hilmy Veradin on 07/04/22.
//

import Foundation
import NotificationCenter
import UIKit

class MyGoalsViewController: UIViewController {
  
  //MARK: - Properties
  @IBOutlet weak var UIView1: UIView!
  @IBOutlet weak var UIView2: UIView!
  @IBOutlet weak var subOneUIView2: UIView!
  @IBOutlet weak var subTwoUIView2: UIView!
  @IBOutlet weak var UIView3: UIView!
  @IBOutlet weak var UIView4: UIView!
  @IBOutlet weak var blurredView: UIView!
  
  @IBOutlet weak var goalsText: UITextField!
  @IBOutlet weak var startDate: UIDatePicker!
  @IBOutlet weak var endDate: UIDatePicker!
  @IBOutlet weak var customSwitch: UISwitch!
  @IBOutlet weak var durationGoal: UIDatePicker!
  @IBOutlet weak var saveButton: UIButton!
  
  // Core Data Properties
  var myGoals : MyGoals?
  var isGoalsSelected : IsGoalsSelected?
  var home : Home?
  var weekday: Weekdays?
  
  var isGoalsExists = false
  var ifSwitchPressed = false
  var initialWeekday = [Int]()
  var initialHours = [5, 12]
  
  
  
  //MARK: - Life Cycles
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchInLoad()
    setupView()
    requestNotificationAuth()
  }
  
  //MARK: - Button Actions
  @IBAction func switchPressed(_ sender: Any) {
    if ifSwitchPressed == false {
      ifSwitchPressed = true
      performSegue(withIdentifier: "MyGoalsToCustom", sender: self)
    } else {
      ifSwitchPressed = false
    }
  }
  
  @IBAction func saveButtonPressed(_ sender: UIButton!) {
    if isGoalsExists == false {
      let alert = UIAlertController(title: "Goals Saved", message: "You have sucessfully saved your goals" , preferredStyle: .alert)
      alert.view.tintColor = UIColor.init(named: "BoldOrange-Color")
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] _ in
        self.isGoalsExists = true
        self.saveGoals()
        self.setupView()
      }))
      self.present(alert, animated: true, completion: nil)
    } else {
      let alert = UIAlertController(title: "Do You Want To End Goal?", message: "My goals can be edited after the current goal is ended" , preferredStyle: .alert)
      alert.view.tintColor = UIColor.init(named: "BoldOrange-Color")
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
        self.isGoalsExists = false
        self.resetGoals()
        self.setupView()
      }))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
}

// MARK: - Core Data Helpers

extension MyGoalsViewController {
  private func saveGoals() {
    self.isGoalsExists = true
    /*
     1. masukin semua hal ke MyGoals Entitiy
     2. masukin semua hal ke Home
     3. masukin "true" ke isGoalsSelected
     4. get currentDay (for starting)
     5. get weekdays
     6. get notifications
     */
    //1
    CoreDataManager.manager.insertGoal(goalsName: self.goalsText.text!, startDate: self.startDate.date, endDate: self.endDate.date, duration: self.durationGoal.date)
    //2
    let totalDays = self.getNumberOfDays()
    let totalSeconds = getNumberOfDuration()
    print("My Goals: days: \(totalDays), seconds: \(totalSeconds)")
    CoreDataManager.manager.insertHomeTarget(daysTarget: totalDays, timeTarget: totalSeconds)
    //3
    CoreDataManager.manager.insertIsGoalsSelected(isGoalsExists: true)
    //4
    getCurrentDay(startDate: startDate.date)
    //5
    initialWeekday = getWeekday()
    //6
    NotificationManager.manager.getWeekday(weekdays: initialWeekday)
    NotificationManager.manager.monthDateFormatter(startDate: startDate.date, endDate: endDate.date)
    NotificationManager.manager.dayDateFormatter(startDate: startDate.date, endDate: endDate.date)
    NotificationManager.manager.getNotification()
    
  }
  
  private func resetGoals() {
    /*
     1. delete home entitiy
     2. delete myGoals entitiy
     3. delete isGoalsSelected
     4. delete timer
     5. delete preferences
     7. delete current Day
     6. reset notifications
     
     */
    //1
    CoreDataManager.manager.deleteHome()
    //2
    CoreDataManager.manager.deleteGoals()
    //3
    CoreDataManager.manager.deleteIsGoalsSelected()
    //4
    CoreDataManager.manager.deleteTimer()
    //5
    CoreDataManager.manager.deletePreferences()
    //6
    CoreDataManager.manager.deleteCurrentDay()
    //7
    CoreDataManager.manager.deleteWeekday()
    //6
    NotificationManager.manager.resetNotification()
  }
  
  func fetchInLoad() {
    /*
     1. fetch myGoals (for a placeholder)
     2. fetch isGoalsSelected (for making "blocker" appears/not)
     */
    // 1
    let tempGoals = CoreDataManager.manager.fetchGoals()
    if let tempGoals = tempGoals {
      self.goalsText.text = tempGoals.goalsName!
      self.startDate.date = tempGoals.startDate!
      self.endDate.date = tempGoals.endDate!
      self.durationGoal.date = tempGoals.duration!
      print("MyGoals: Temp goals fetch suceed!")
    }
    //2
    let tempIsGoalsSelected = CoreDataManager.manager.fetchIsGoalsSelected()
    if let tempIsGoalsSelected = tempIsGoalsSelected {
      self.isGoalsExists = tempIsGoalsSelected.isGoalsSelected
      print("MyGoals: isSelected fetch succeed! is goals: \(isGoalsExists)")
    }
    
  }
  
  private func getWeekday() -> [Int] {
    let weekdays = CoreDataManager.manager.fetchWeekdays()
    guard let weekdays = weekdays else {
      return [1, 2, 3, 4, 5, 6, 7]
    }
    
    return weekdays.weekdays!
  }
  
  private func getCurrentDay(startDate: Date) {
    let currentMonth = Calendar.current.dateComponents([.month], from: startDate)
    let currentDay = Calendar.current.dateComponents([.day], from: startDate)
    let countDayandMonth = (currentMonth.month! * 30) + (currentDay.day!)
    
    CoreDataManager.manager.insertCurrentDay(currentDay: Int64(countDayandMonth))
  }
  
  func getNumberOfDays() -> Int16 {
    let numberofDays = Calendar.current.dateComponents([.day], from: startDate.date, to: endDate.date)
    return Int16(numberofDays.day!+1)
  }
  
  func getNumberOfDuration() -> Int64 {
    let numberOfHour = Calendar.current.dateComponents([.hour], from: durationGoal.date)
    let numberOfMinutes = Calendar.current.dateComponents([.minute], from: durationGoal.date)
    let hoursInSeconds = (numberOfHour.hour ?? 0) * 3600
    let minutesInSeconds = (numberOfMinutes.minute ?? 0) * 60
    let finalSeconds = hoursInSeconds + minutesInSeconds
    return Int64(finalSeconds)
  }
}

// MARK: - View Helpers

extension MyGoalsViewController {
  
  private func setupView() {
    roundUIView()
    if isGoalsExists == false {
      blurredView.isHidden = true
      saveButton.backgroundColor = UIColor(named: "BoldOrange-Color", in: nil, compatibleWith: nil)
      saveButton.setTitle("Save Goal", for: .normal)
      saveButton.setTitleColor(.white, for: .normal)
    } else {
      blurredView.isHidden = false
      saveButton.backgroundColor = .white
      saveButton.setTitle("End Goal", for: .normal)
      saveButton.setTitleColor(UIColor(named: "BoldOrange-Color", in: nil, compatibleWith: nil), for: .normal)
      saveButton.layer.borderColor =  UIColor(named: "BoldOrange-Color", in: nil, compatibleWith: nil)?.cgColor
      saveButton.layer.borderWidth = CGFloat(0.5)
    }
  }
  
  private func roundUIView() {
    UIView1.layer.cornerRadius = 8
    UIView2.layer.cornerRadius = 8
    subOneUIView2.layer.cornerRadius = 5
    subTwoUIView2.layer.cornerRadius = 5
    UIView3.layer.cornerRadius = 8
    UIView4.layer.cornerRadius = 8
    saveButton.layer.cornerRadius = 8
  }
  
}

// MARK: - Notification Helpers

extension MyGoalsViewController {
  func requestNotificationAuth() {
    let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
    NotificationManager.manager.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
      if let error = error {
        print("Error: ", error)
      }
    }
  }
}
