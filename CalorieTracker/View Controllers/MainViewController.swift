//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 11/24/20.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Presentable Alerts -
    var addEntryAlert: UIAlertController {
        var alert = UIAlertController(title: "New Calorie Entry", message: "Enter the number of calories for this entry", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
        
        return alert
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak var currentTotalLabel: UILabel!
    @IBOutlet weak var calorieGoalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - IBActions -
    @IBAction func clearButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addEntryButton(_ sender: UIBarButtonItem) {
        
    }
    
} //End of class

