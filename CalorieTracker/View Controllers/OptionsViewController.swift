//
//  OptionsViewController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 3/5/21.
//

import UIKit

class OptionsViewController: UIViewController {
    
//MARK: - Presentable Alerts
    var inputInvalidAlert: UIAlertController {
        let alert = UIAlertController(title: "Input Invalid", message: "What you entered for the amount of calories was invalid, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.present(self.setDailyGoalAlert, animated: true)
        }
        alert.addAction(okAction)
        return alert
    }
    
    var clearAllEntriesWarningAlert: UIAlertController {
        let alert = UIAlertController(title: "Are you sure you want to clear all of your calorie entries?", message: "This will clear everything you've entered so far and reset the tracker", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive) { (_) in
            self.controller.clearAllEntries()
            self.tableView.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(clearAllAction)
        return alert
    }
    
    var setDailyGoalAlert: UIAlertController {
        let alert = UIAlertController(title: "Daily Calorie Goal 💪", message: "Enter the number of calories you want to consume daily to achieve your calorie deficit", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let textField = alert.textFields![0]
            guard let textInput = textField.text else { return }
            guard let newGoal = Int(textInput) else {
                self.present(self.inputInvalidAlert, animated: true)
                return
            }
            
            if newGoal >= 3000 {
                self.dailyGoalTooHighAlert(dailyGoalInput: textInput)
                return
            }
            if newGoal <= 1000 {
                self.dailyGoalTooLowAlert(dailyGoalInput: textInput)
                return
            }
            
            self.defaults.setValue(textInput, forKey: .dailyGoalKey)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Number of Calories"
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    func dailyGoalTooHighAlert(dailyGoalInput: String) {
        var goalTooHighAlert: UIAlertController {
            let alert = UIAlertController(title: "That's pretty high!", message: "\(dailyGoalInput) calories is unusually high for the average person to have as their daily intake, are you sure this what you want? 🤔", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "That's right 😎", style: .destructive) { _ in
                self.defaults.setValue(dailyGoalInput, forKey: .dailyGoalKey)
                self.tableView.reloadData()
            }

            let noAction = UIAlertAction (title: "Change amount", style: .default) { _ in
                self.present(self.setDailyGoalAlert, animated: true)
            }

            alert.addAction(yesAction)
            alert.addAction(noAction)
            return alert
        }
        self.present(goalTooHighAlert, animated: true)
    }

    func dailyGoalTooLowAlert(dailyGoalInput: String) {
        var goalTooLowAlert: UIAlertController {
            let alert = UIAlertController(title: "That's... a bit low", message: "\(dailyGoalInput) calories is unusually low for the average person to have as their daily intake, are you sure this what you want? 🤔", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "That's right 😎", style: .destructive) { _ in
                self.defaults.setValue(dailyGoalInput, forKey: .dailyGoalKey)
                self.tableView.reloadData()
            }
            let noAction = UIAlertAction (title: "Change amount", style: .default) { _ in
                self.present(self.setDailyGoalAlert, animated: true)
            }

            alert.addAction(yesAction)
            alert.addAction(noAction)
            return alert
        }
        self.present(goalTooLowAlert, animated: true)
    }
    
    func presentCreditsAlert() {
        var creditsAlertController: UIAlertController {
            let alert = UIAlertController(title: "Credits 📝", message:
                                            """
Circular progress bar was made by the amazing Yogesh Manghnani
App icon made by Smashicons from www.flaticon.com
""", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            return alert
        }
        present(creditsAlertController, animated: true)
    }
    
//MARK: - Properties
    let controller = EntriesController.shared
    let defaults = UserDefaults.standard
    
//MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
//MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
//MARK: - IBActions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
} //End of class

//MARK: - Extensions
extension OptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .optionCellIdentifier)! as UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Change calorie goal"
            cell.detailTextLabel?.text = (defaults.value(forKey: .dailyGoalKey) as? String ?? "0") + " Cal" 
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Clear all entries"
            cell.detailTextLabel?.text = "Currently Present: " + String(controller.calorieEntries.count)
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Credits"
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == 0 {
            present(setDailyGoalAlert, animated: true)
        } else if row == 1 {
            present(clearAllEntriesWarningAlert, animated: true)
        } else if row == 2 {
            presentCreditsAlert()
        }
    }
    
} //End of extension

