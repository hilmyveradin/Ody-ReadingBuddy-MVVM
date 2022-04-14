//
//  File.swift
//  Ody-ReadingBuddy
//
//  Created by Hilmy Veradin on 13/04/22.
//

import Foundation

class LandscapeManager {
  static let shared = LandscapeManager()
  var isFirstLaunch: Bool {
    get {
      !UserDefaults.standard.bool(forKey: #function)
    } set {
      UserDefaults.standard.setValue(newValue, forKey: #function)
    }
  }
  
}
