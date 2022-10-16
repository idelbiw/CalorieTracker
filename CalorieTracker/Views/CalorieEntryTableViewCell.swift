//
//  CalorieEntryTableViewCell.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 12/1/20.
//

import UIKit

class CalorieEntryTableViewCell: UITableViewCell {

    //MARK: - Main properties -
    var calorieEntry: CalorieEntry? {
        didSet {
            updateViews()
        }
    }
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    //MARK: - Methods -
    func updateViews() {
        guard let entry = calorieEntry else { return }
        
        textLabel?.text = "\(entry.calories) Cal"
        detailTextLabel?.text = dateFormatter.string(from: entry.date)
        
        if let name = entry.name, entry.name != "" {
            textLabel?.text = "\(entry.calories) Cal - \(name)"
        }
        
    }

} //End of class
