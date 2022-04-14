//
//  TimerViewController.swift
//  ReadingApp-Dummy
//
//  Created by Hilmy Veradin on 06/04/22.
//
import Foundation
import UIKit

class TimerViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak  var resetButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  
  // Core Data properties
  var home: Home?
  
  var timeSpent: Int!
  var timeTarget: Int!
  var seconds: Int!
  var timer = Timer()
  var isTimerRunning = true
  var resumeTapped = false
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchWhenLoaded()
    
    let mascotGif = UIImage.gifImageWithName("maskotBaca")
    imageView.image = mascotGif
    
    runTimer()
    updateTimer()
    
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let seconds = seconds {
      if seconds == 0 {
        CoreDataManager.manager.increaseTimeSpent(addedTimeSpent: Int64(timeTarget))
      } else {
        CoreDataManager.manager.increaseTimeSpent(addedTimeSpent: Int64(seconds))
      }
    }
    tabBarController?.tabBar.isHidden = false
  }
  
  // MARK: - Button Actions
  @IBAction func pauseButtonTapped(_ sender: UIButton){
    if self.resumeTapped == false {
      timer.invalidate()
      pauseButton.setImage(UIImage(systemName:"play.fill"), for: .normal)
      pauseButton.tintColor = UIColor(named: "AccentColor")
      pauseButton.configuration?.background.strokeWidth = 2
      pauseButton.configuration?.background.backgroundColor = UIColor.white
      self.resumeTapped = true
    } else {
      runTimer()
      pauseButton.setImage(UIImage(systemName:"pause"), for: .normal)
      pauseButton.tintColor = UIColor.white
      pauseButton.configuration?.background.backgroundColor = UIColor(named:"AccentColor")
      self.resumeTapped = false
    }
  }
  
  @IBAction func resetButtonTapped(_ sender: UIButton){
    timer.invalidate()
    let alert = UIAlertController(title: "Reset Timer", message: "Are you sure to reset the Timer", preferredStyle: .alert)
    alert.view.tintColor = UIColor.init(named: "BoldOrange-Color")
    alert.addAction(UIAlertAction(title: "No", style: .default))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (_) in
      self.refetchResetButton()  //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
      
      self.timerLabel.text = self.timeString(time: TimeInterval(self.seconds))

      self.pauseButton.setImage(UIImage(systemName:"play.fill", compatibleWith: .none), for: .normal)
      self.pauseButton.setTitleColor(.white, for: .normal)
      self.resetButton.setTitleColor(UIColor(named: "BoldOrange-Color", in: nil, compatibleWith: nil), for: .normal)
      
      self.resumeTapped = true
      self.isTimerRunning = false
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func stopButtonTapped(_ sender: UIButton){
    timer.invalidate()

    let alert = UIAlertController(title: "Stop Timer", message: "Are you sure to stop the timer?", preferredStyle: .alert)
    alert.view.tintColor = UIColor.init(named: "BoldOrange-Color")
    alert.addAction(UIAlertAction(title: "No", style: .default))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (_) in
      performSegue(withIdentifier: "toBack", sender: self)
      tabBarController?.tabBar.isHidden = false
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Action Helpers
  
  @objc func updateTimer() {
    if seconds < 1 && seconds != nil{
      timer.invalidate()
      let alert = UIAlertController(title: "Congratzzz", message: "You've achieved your goals. Let's go back to home :))", preferredStyle: .alert)
      alert.view.tintColor = UIColor.init(named: "BoldOrange-Color")
      alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [self] (_) in
        performSegue(withIdentifier: "toBack", sender: self)
        tabBarController?.tabBar.isHidden = false
      }))
      self.present(alert, animated: true, completion: nil)
    } else {
      seconds -= 1
      timerLabel.text = timeString(time: TimeInterval(seconds))
    }
  }
  
  func runTimer() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector:(#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
    isTimerRunning = true
    pauseButton.isEnabled = true
  }
  
  func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
  }

}

// MARK: - Core Data Helpers

extension TimerViewController {
  private func refetchResetButton() {
    /*
     1. fetch Home, get time spent
     */
    let home = CoreDataManager.manager.fetchHome()
    guard let home = home else {
      return print("Timer: home doesn't exists")
    }
    seconds = Int(home.timeTarget)
  }
  
  private func fetchWhenLoaded() {

    // fetch home, get timeTarget and Time Spent
    let home = CoreDataManager.manager.fetchHome()
    guard let home = home else {
      return print("Timer: home doesn't exists")
    }
    
    timeSpent = Int(home.timeSpent)
    timeTarget = Int(home.timeTarget)
    
    if timeSpent == 0 {
      seconds = Int(home.timeTarget)
    } else {
      seconds = Int(home.timeSpent)
    }
  }
}
