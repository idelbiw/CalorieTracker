//
//  EntriesController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 12/7/20.
//

import Foundation

class EntriesController {
    
    //MARK: - Properties -
    var calorieEntries: [CalorieEntry] = []
    
    //MARK: - Initializer -
    init() {
        loadEntries()
    }
    
    //MARK: - Methods -
    func addNewCalorieEntry(_ newEntry: CalorieEntry) {
        
    }
    
    func addNewCalorieEntry(date: Date, calories: Int) {
        
    }
    
    func saveEntries() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "entries", relativeTo: directoryURL).appendingPathExtension("json")
        
        do {
            let data = try JSONEncoder().encode(calorieEntries)
            try data.write(to: fileURL)
        } catch {
            print("Saving entries failed! - Reason: \(error)")
        }
    }
    
    func loadEntries() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "entries", relativeTo: directoryURL).appendingPathExtension("json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            calorieEntries = try JSONDecoder().decode([CalorieEntry].self, from: data)
            print("Entries were loaded successfully!")
        } catch {
            print("Loading entries failed! - Reason: \(error)")
        }
    }
    
} //End of class
