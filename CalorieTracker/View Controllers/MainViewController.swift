//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 11/24/20.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Presentable Alerts
    var inputInvalidAlert: UIAlertController {
        let alert = UIAlertController(title: "Input Invalid", message: "What you entered for the amount of calories was invalid, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.updateViews()
        }
        alert.addAction(okAction)
        return alert
    }
    
    var addEntryAlert: UIAlertController {
        let alert = UIAlertController(title: "New Calorie Entry", message: "Enter the number of calories for this entry", preferredStyle: .alert)
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let okButtonAction = UIAlertAction(title: "OK", style: .default) { _ in
            let caloriesTextField = alert.textFields![0]
            let nameTextField = alert.textFields![1]
            
            let caloriesInput = caloriesTextField.text
            let nameInput = nameTextField.text
            
            guard let calories = Int(caloriesInput!) else {
                self.present(self.inputInvalidAlert, animated: true)
                return
            }
            
            let newCalorieEntry = CalorieEntry(calories: calories)
            
            if let nameInput = nameInput {
                newCalorieEntry.name = nameInput
            }
            
            self.controller.addNewCalorieEntry(newCalorieEntry)
            self.updateViews()
            
        }
        
        alert.addTextField { $0.placeholder = "Number of Calories" ; $0.keyboardType = .numberPad }
        alert.addTextField(configurationHandler: { $0.placeholder = "Optional: name of meal or snack?"})
        alert.addAction(okButtonAction)
        alert.addAction(cancelButtonAction)
        
        return alert
    }
    
    var setDailyGoalAlert: UIAlertController {
        let alert = UIAlertController(title: "Daily Calorie Goal 💪", message: "Enter the number of calories you want to consume daily to achieve your calorie deficit", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
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
            self.updateViews()
        }
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Number of Calories"
        }
        alert.addAction(okAction)
        return alert
    }
    
    func dailyGoalTooHighAlert(dailyGoalInput: String) {
        var goalTooHighAlert: UIAlertController {
            let alert = UIAlertController(title: "That's pretty high!", message: "\(dailyGoalInput) calories is unusually high for the average person to have as their daily intake, are you sure this what you want? 🤔", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "That's right 😎", style: .destructive) { _ in
                self.defaults.setValue(dailyGoalInput, forKey: .dailyGoalKey)
                self.updateViews()
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
                self.updateViews()
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
        progressView.setProgress(to: 0.0, withAnimation: true)
        updateViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }
    func updateViews() {
        addEntryButton.circular()
        tableView.reloadData()
        updateDailyGoal()
        configureProgressView()
        updateProgressView()
    }
    func updateDailyGoal() {
        guard let calorieGoal = defaults.value(forKey: .dailyGoalKey) as? String else {
            self.present(setDailyGoalAlert, animated: true)
            return
        }
        calorieGoalLabel.text = calorieGoal
    }
    func configureProgressView() {
        progressView.lineWidth = 10
        progressView.labelSize = 50
        progressView.lineColor = .systemBlue
        progressView.lineFinishColor = .green
        progressView.lineBackgroundColor = .lightGray
        progressView.safePercent = Int(defaults.value(forKey: .dailyGoalKey)as? String ?? "0")!
    }
    func updateProgressView() {
        let totalcalories = Double(controller.totalCalories)
        let goal = Double(defaults.value(forKey: .dailyGoalKey) as? String ?? "0")!
        let result = totalcalories / goal
        
        if controller.totalCalories <= Int(goal) {
            progressView.lineFinishColor = .green
        } else {
            progressView.lineFinishColor = .systemRed
        }
        
        progressView.setProgress(to: result, withAnimation: false)
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
