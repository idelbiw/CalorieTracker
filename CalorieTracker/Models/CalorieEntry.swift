//
//  CalorieEntry.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 12/1/20.
//

import Foundation

class CalorieEntry: Codable {
    
    //MARK: - Properties -
    let calories: Int
    let date: Date
    
    //MARK: - Initializer -
    init(calories: Int) {
        self.calories = calories
        self.date = Date()
    }
    
}
