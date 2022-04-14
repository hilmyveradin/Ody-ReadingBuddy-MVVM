//
//  DateManager.swift
//  Ody-ReadingBuddy
//
//  Created by Hilmy Veradin on 10/04/22.
//

import Foundation

class DateManager {

  // MARK: - Properties
  let dateFormatter = DateFormatter()
  let chosenPreferences : [Int : [Int]] = [0 : [5, 11],
                                           1 : [12, 16],
                                           2 : [16, 20],
                                           3 : [20, 24]]
  
//  let date = Date()


  // MARK: - Functions
  func getPreferences(index: Int) -> [Int] {
    return chosenPreferences[index]!
  }

  func monthDateFormatter(date: Date) -> DateComponents {
    let calendarDate = Calendar.current.dateComponents([.month], from: date)
    return calendarDate
  }

  func endDateFormatter(endDate: Date) -> Date {
    return Date()
  }

}
