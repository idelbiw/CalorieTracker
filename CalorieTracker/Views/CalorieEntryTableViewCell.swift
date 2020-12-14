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
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    //MARK: - Methods -
    func updateViews() {
        guard let entry = calorieEntry else { return }
        textLabel?.text = String(entry.calories)
        detailTextLabel?.text = dateFormatter.string(from: entry.date)
        
    }
    
    //MARK: - IBOutlets -
    

} //End of class
