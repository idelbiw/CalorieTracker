//
//  CalorieEntry.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 12/1/20.
//

import Foundation

class CalorieEntry: Codable, Equatable {

    //MARK: - Properties -
    let name: String?
    let calories: Int
    let date: Date
    
    //MARK: - Initializers -
    init(calories: Int) {
        self.calories = calories
        self.date = Date()
        self.name = nil
    }
    
    init(calories: Int, name: String) {
        self.calories = calories
        self.date = Date()
        self.name = name
    }
    
    //MARK: - Equatable conformance -
    static func == (lhs: CalorieEntry, rhs: CalorieEntry) -> Bool {
        var equatableTest = false
        
        if lhs.calories == rhs.calories && lhs.date == rhs.date {
            equatableTest = true
        }
         
        if let lName = lhs.name, let rName = rhs.name {
            if  lName != rName {
                equatableTest = false
            }
        }
        
        return equatableTest
    }
    
} //End of class
