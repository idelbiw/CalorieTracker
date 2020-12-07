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
    
    //MARK: - Presentable Alerts -
    var addEntryAlert: UIAlertController {
        let alert = UIAlertController(title: "New Calorie Entry", message: "Enter the number of calories for this entry", preferredStyle: .alert)
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okButtonAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let textField = alert.textFields![0]
            let textInput = textField.text
            guard let calories = Int(textInput!) else { return }
            let newCalorieEntry = CalorieEntry(calories: calories)
            self.entriesController.addNewCalorieEntry(newCalorieEntry)
        }
        
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
        alert.addAction(okButtonAction)
        alert.addAction(cancelButtonAction)
        
        return alert
    }
    var inputInvalidAlert: UIAlertController {
        let alert = UIAlertController(title: "Input Invalid", message: "What you entered for the amount of calories was invalid, please try again.", preferredStyle: .alert)
        return alert
    }
    var clearAllEntriesWarningAlert: UIAlertController {
        let alert = UIAlertController(title: "Are you sure you want to clear all of your calorie entries?", message: "This will clear everything you've entered so far and reset the tracker", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive) { (_) in
            self.entriesController.clearAllEntries()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(clearAllAction)
        return alert
    }
    
    //MARK: - Methods -
    func updateViews() {
        if entriesController.calorieEntries.count == 0 {
            
        }
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak var currentTotalLabel: UILabel!
    @IBOutlet weak var calorieGoalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    
    //MARK: - IBActions -
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addEntryButton(_ sender: UIBarButtonItem) {
        
    }
    
} //End of class

