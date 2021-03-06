//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 11/24/20.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Properties -
    
    let entriesController = EntriesController()
    let defaults = UserDefaults.standard
    
    // This key is used to store the user's daily goal
    let dailyGoalKey = "DailyGoalKey"
    
    //MARK: - Presentable Alerts -
    
    var inputInvalidAlert: UIAlertController {
        let alert = UIAlertController(title: "Input Invalid", message: "What you entered for the amount of calories was invalid, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.present(self.addEntryAlert, animated: true)
        }
        alert.addAction(okAction)
        return alert
    }
    
    var clearAllEntriesWarningAlert: UIAlertController {
        let alert = UIAlertController(title: "Are you sure you want to clear all of your calorie entries?", message: "This will clear everything you've entered so far and reset the tracker", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive) { (_) in
            self.entriesController.clearAllEntries()
            self.updateViews()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(clearAllAction)
        return alert
    }
    
    var addEntryAlert: UIAlertController {
        let alert = UIAlertController(title: "New Calorie Entry", message: "Enter the number of calories for this entry", preferredStyle: .alert)
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okButtonAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let textField = alert.textFields![0]
            let textInput = textField.text
            guard let calories = Int(textInput!) else {
                self.present(self.inputInvalidAlert, animated: true)
                return
            }
            let newCalorieEntry = CalorieEntry(calories: calories)
            self.entriesController.addNewCalorieEntry(newCalorieEntry)
            self.updateViews()
        }
        
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
        alert.addAction(okButtonAction)
        alert.addAction(cancelButtonAction)
        
        return alert
    }
    
    var setDailyGoalAlert: UIAlertController {
        let alert = UIAlertController(title: "Daily Calorie Goal 💪", message: "Enter the number of calories you want to limit yourself to daily, but if you'd like you can enter whatever you want 🙂", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let textField = alert.textFields![0]
            let textInput = textField.text
            self.defaults.setValue(textInput, forKey: self.dailyGoalKey)
            self.updateDailyGoal()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    //MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
        updateDailyGoal()
    }
    
    func updateViews() {
        currentTotalLabel.text = String(entriesController.totalCalories)
        tableView.reloadData()
    }
    
    func updateDailyGoal() {
        calorieGoalLabel.text = defaults.value(forKey: dailyGoalKey) as? String
    }
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var currentTotalLabel: UILabel!
    @IBOutlet weak var calorieGoalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    
    //MARK: - IBActions -
    
    @IBAction func clearAllButtonTapped(_ sender: UIBarButtonItem) {
        present(clearAllEntriesWarningAlert, animated: true)
    }
    
    @IBAction func addEntryButtonTapped(_ sender: UIBarButtonItem) {
        present(addEntryAlert, animated: true)
    }
    
    @IBAction func setGoalButtonTapped(_ sender: UIBarButtonItem) {
        present(setDailyGoalAlert, animated: true)
    }
    
} //End of class

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entriesController.calorieEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .calorieEntryCell) as! CalorieEntryTableViewCell
        let entry = entriesController.calorieEntries[indexPath.row]
        cell.calorieEntry = entry
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entriesController.deleteEntry(indexOfEntry: indexPath.row)
            updateViews()
        }
    }
    
} //End of extension
