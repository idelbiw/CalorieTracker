//
//  CalorieEntryDetailViewController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 3/20/21.
//

import UIKit

class CalorieEntryDetailViewController: UIViewController {

//MARK: - Properties
    var calorieEntry: CalorieEntry?
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }
    
//MARK: - Presentable Alerts
    var entryNotFoundAlert: UIAlertController {
        let alertTitle = "Calorie entry not found!"
        let alertMessage = "We're sorry, but it looks like we weren't able to find your calorie entry"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        return alert
    }
    
//MARK: - IBOutlets
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var modalNubView: UIView!
    
//MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    func updateViews() {
        modalNubView.circular()
        guard let entry = calorieEntry else {
            present(entryNotFoundAlert, animated: true)
            return
        }
        caloriesLabel.text = String(entry.calories)
        dateLabel.text = dateFormatter.string(from: entry.date)
        if let name = entry.name {
            nameLabel.isHidden = false
            nameLabel.text = name
        }
    }

} //End of class
