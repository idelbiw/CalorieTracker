//
//  CalorieEntry.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 12/1/20.
//

import Foundation

class CalorieEntry: Codable, Equatable {

    //MARK: - Properties -
    let calories: Int
    let date: Date
    
    //MARK: - Initializer -
    init(calories: Int) {
        self.calories = calories
        self.date = Date()
    }
    
    //MARK: - Equatable conformance -
    static func == (lhs: CalorieEntry, rhs: CalorieEntry) -> Bool {
        var equatableTest = false
        
        if lhs.calories == rhs.calories && lhs.date == rhs.date {
            equatableTest = true
        }
        
        return equatableTest
    }
    
} //End of class
