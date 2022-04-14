//
//  NewDayManager.swift
//  Ody-ReadingBuddy
//
//  Created by Hilmy Veradin on 13/04/22.
//

import Foundation

class NewDayManager {
  static let manager = NewDayManager()
  
  func compareDay() {
    
    // count month and day
    let currentMonth = Calendar.current.dateComponents([.month], from: Date())
    let currentDay = Calendar.current.dateComponents([.day], from: Date())
    let countDayandMonth = (currentMonth.month!) * 30 + (currentDay.day!)
    
    // fetch from Day Count
    let dayCount = CoreDataManager.manager.fetchDayCount()
    
    if let dayCount = dayCount {
      let startDate = Int(dayCount.currentDay)
      if startDate < countDayandMonth {
        /*
         1. delete current day
         2. insert current day yang baru
         3. increase days spent
         4. reset time spent
         */
        
        //1
        CoreDataManager.manager.deleteCurrentDay()
        //2
        CoreDataManager.manager.insertCurrentDay(currentDay: Int64(countDayandMonth))
        //3
        CoreDataManager.manager.increaseDaysSpent()
        //4
        CoreDataManager.manager.resetTimeSpent()
      } else {
        print("New Day Manager: Start date is still greater than current date")
      }
    }
  }
  
}
