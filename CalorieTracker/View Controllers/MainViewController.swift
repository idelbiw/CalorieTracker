//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 11/24/20.
//

import UIKit
import FittedSheets

class MainViewController: UIViewController {
    
    //MARK: - Presentable Alerts
    var inputInvalidAlert: UIAlertController {
        let alert = UIAlertController(title: "Input Invalid", message: "What you entered for the amount of calories was invalid, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        return alert
    }
    var clearAllEntriesWarningAlert: UIAlertController {
        let alert = UIAlertController(title: "Are you sure you want to clear all of your calorie entries?", message: "This will clear everything you've entered so far and reset the tracker", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive) { (_) in
            self.controller.clearAllEntries()
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
            let caloriesTextField = alert.textFields![0]
            let nameTextField = alert.textFields![1]
            
            let caloriesInput = caloriesTextField.text
            let nameInput = nameTextField.text
            
            guard let calories = Int(caloriesInput!) else {
                self.present(self.inputInvalidAlert, animated: true)
                return
            }
            
            if let nameInput = nameInput {
                let newCalorieEntry = CalorieEntry(calories: calories, name: nameInput)
                self.controller.addNewCalorieEntry(newCalorieEntry)
                self.updateViews()
                self.updateProgressView()
            } else {
                let newCalorieEntry = CalorieEntry(calories: calories)
                self.controller.addNewCalorieEntry(newCalorieEntry)
                self.updateViews()
                self.updateProgressView()
            }
        }
        
        alert.addTextField { $0.keyboardType = .numberPad }
        alert.addTextField(configurationHandler: { $0.placeholder = "Optional: name of meal or snack?"})
        alert.addAction(okButtonAction)
        alert.addAction(cancelButtonAction)
        
        return alert
    }
    var setDailyGoalAlert: UIAlertController {
        let alert = UIAlertController(title: "Daily Calorie Goal 💪", message: "Enter the number of calories you want to consume daily to achieve your calorie deficit", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let textField = alert.textFields![0]
            guard let textInput = textField.text else { return }
            guard let _ = Int(textInput) else {
                self.present(self.inputInvalidAlert, animated: true)
                return
            }
            self.defaults.setValue(textInput, forKey: .dailyGoalKey)
            self.updateDailyGoal()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    //MARK: - Properties
    let controller = EntriesController.shared
    let defaults = UserDefaults.standard
    
    //MARK: - IBOutlets
    @IBOutlet weak var progressView: CircularProgressBar!
    @IBOutlet weak var calorieGoalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEntryButton: UIButton!
    
    //MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
        updateDailyGoal()
        configureProgressView()
        updateProgressView()
    }
    func updateViews() {
        addEntryButton.circular()
        tableView.reloadData()
        updateProgressView()
    }
    func updateDailyGoal() {
        calorieGoalLabel.text = (defaults.value(forKey: .dailyGoalKey) as? String) ?? "0"
    }
    func configureProgressView() {
        progressView.lineWidth = 10
        progressView.labelSize = 50
        progressView.lineColor = .systemBlue
        progressView.lineFinishColor = .green
        progressView.lineBackgroundColor = .lightGray
        progressView.safePercent = Int(defaults.value(forKey: .dailyGoalKey)as! String)!
    }
    func updateProgressView() {
        let totalcalories = Double(controller.totalCalories)
        let goal = Double(defaults.value(forKey: .dailyGoalKey)as! String)!
        let result = totalcalories / goal
        progressView.setProgress(to: result, withAnimation: true)
    }
    
    //MARK: - Navigtion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .entryDetailSegue {
            let index = tableView.indexPathForSelectedRow
            let detailVC = segue.destination as! CalorieEntryDetailViewController
            let entry = controller.calorieEntries[index!.row]
            detailVC.calorieEntry = entry
        }
    }
    
    //MARK: - IBActions
    @IBAction func addEntryButtonTapped(_ sender: UIButton) {
        present(addEntryAlert, animated: true)
    }
    
}   //End of class


//MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        controller.calorieEntries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .calorieEntryCell) as! CalorieEntryTableViewCell
        let entry = controller.calorieEntries[indexPath.row]
        cell.calorieEntry = entry
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            controller.deleteEntry(indexOfEntry: indexPath.row)
            updateViews()
        }
    }
}
