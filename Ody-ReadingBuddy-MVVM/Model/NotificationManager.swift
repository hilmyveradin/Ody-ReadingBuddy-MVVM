//
//  NotificationManager.swift
//  Ody-ReadingBuddy
//
//  Created by Hilmy Veradin on 10/04/22.
//

import Foundation
import NotificationCenter
import CoreData

class NotificationManager {
  static let manager = NotificationManager()
  
  let userNotificationCenter = UNUserNotificationCenter.current()
  
  var months = [Int]()
  var days = [Int]()
  var hours = [5, 12]
  var weekdays = [1, 2, 3, 4, 5, 6, 7]
  
  let totalDaysInMonths = [
    1 : 31,
    2 : 28,
    3 : 31,
    4 : 30,
    5 : 31,
    6 : 30,
    7 : 31,
    8 : 31,
    9 : 30,
    10 : 31,
    11 : 30,
    12 : 31
  ]
  
  var totalDays: Int!
  var newDictionary: NSMutableDictionary!
  
  public func getHours(hours: [Int]) {
    self.hours = hours
  }
  
  public func getWeekday(weekdays: [Int]) {
    self.weekdays = weekdays
  }
  
  func resetNotification() {
    userNotificationCenter.removeAllDeliveredNotifications()
    userNotificationCenter.removeAllPendingNotificationRequests()
    months = []
    days = []
    hours = [5, 12]
    weekdays = [1, 2, 3, 4, 5, 6, 7]
  }
  
  func getNotification() {
    print("month: \(months)")
    print("days: \(days)")
    print("hours: \(hours)")
    
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "It's time to read!"
    notificationContent.body = "Let's start reading. Your progress is waiting to be completed"
    notificationContent.badge = NSNumber(value: 1)
    
    for month in self.months {
      for weekday in weekdays {
        for day in self.days {
          for hour in self.weekdays {
            
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.weekday = weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(month),\(day),\(hour), \(weekday)",
                                                content: notificationContent,
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
              if let error = error {
                print("Notification Error: ", error)
              }
            }
          }
          print("Notification added!")
        }
      }
    }
  }
  
  func monthDateFormatter(startDate: Date, endDate: Date) {
    let startcalendarDate = Calendar.current.dateComponents([.month], from: startDate)
    let endCalendarDate = Calendar.current.dateComponents([.month], from: endDate)
    arrayOfMonths(startMonth: startcalendarDate.month, endMonth: endCalendarDate.month)
  }
  
  func dayDateFormatter(startDate: Date, endDate: Date) {
    let startcalendarDate = Calendar.current.dateComponents([.day], from: startDate)
    let endCalendarDate = Calendar.current.dateComponents([.day], from: endDate)
    arrayOfDays(startDay: startcalendarDate.day, endDay: endCalendarDate.day)
  }
  
  private func arrayOfMonths(startMonth: Int?, endMonth: Int?) {
    if let startMonth = startMonth,
       let endMonth = endMonth {
      for month in startMonth ... endMonth {
        self.months.append(month)
      }
    }
  }
  
  private func arrayOfDays(startDay: Int?, endDay: Int?) {
    if let startDay = startDay,
       let endDay = endDay {
      for day in startDay ... endDay {
        self.days.append(day)
      }
    }
  }
  
  func testNotification() {
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "It's time to read!"
    notificationContent.body = "Let's start reading. Your progress is waiting to be completed"
    notificationContent.badge = NSNumber(value: 1)
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let request = UNNotificationRequest(identifier: "testInterval",
                                        content: notificationContent,
                                        trigger: trigger)
    userNotificationCenter.add(request) { (error) in
      if let error = error {
        print("Notification Error: ", error)
      }
    }
  }
  
}
