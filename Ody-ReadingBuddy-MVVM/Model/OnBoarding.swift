//
//  OnBoarding.swift
//  Ody-ReadingBuddy
//
//  Created by Hilmy Veradin on 11/04/22.
//

import Foundation
import UIKit

struct OnBoarding{
  var image: UIImage?
  var imageTitle: String = ""
  var imageDesc: String = ""
  
  var startBtnHidden: Bool = true
  var backBtnHidden: Bool = true
  var nextBtnHidden: Bool = true
  var skipBtnHidden: Bool = true
  
  func generateOnBoarding() -> [OnBoarding]{
    return [
      OnBoarding(image: UIImage(named: "onboardingMascot"), imageTitle: "Hi, Welcome!", imageDesc: "Ready to start your reading journey?", startBtnHidden: true, backBtnHidden: true, nextBtnHidden: false, skipBtnHidden: false),
      OnBoarding(image: UIImage(named: "onboardingGoals"), imageTitle: "My Goals", imageDesc: "Create your reading goals to know what to achieve", startBtnHidden: true, backBtnHidden: false, nextBtnHidden: false, skipBtnHidden: false),
      OnBoarding(image: UIImage(named: "onboardingReminder"), imageTitle: "Daily Reminder", imageDesc: "Don't worry to forget cause we will remind you to read", startBtnHidden: false, backBtnHidden: true, nextBtnHidden: true, skipBtnHidden: true)
    ]
  }
}
