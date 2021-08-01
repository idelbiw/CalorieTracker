//
//  EntriesController.swift
//  CalorieTracker
//
//  Created by Waseem Idelbi on 12/7/20.
//

import Foundation

class EntriesController {
    
    //MARK: - Singleton -
    static var shared = EntriesController()
    
    //MARK: - Properties -
    var calorieEntries: [CalorieEntry] = []
    var totalCalories = 0
    
    //MARK: - Initializer -
    init() {
        loadEntries()
    }
    
    //MARK: - Methods -
    func calculateTotalCalories() {
        var calorieCounter = 0
        for entry in calorieEntries {
            calorieCounter += entry.calories
        }
        totalCalories = calorieCounter
    }
    
    func addNewCalorieEntry(_ newEntry: CalorieEntry) {
        calorieEntries.append(newEntry)
        calculateTotalCalories()
        saveEntries()
    }
    
    func deleteEntry(entryToDelete: CalorieEntry) {
        var counter = -1
        for entry in calorieEntries {
            counter += 1
            if entryToDelete == entry {
                calorieEntries.remove(at: counter)
                break
            }
        }
        calculateTotalCalories()
        saveEntries()
    }
    
    func deleteEntry(indexOfEntry: Int) {
        calorieEntries.remove(at: indexOfEntry)
        calculateTotalCalories()
        saveEntries()
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
        
        calculateTotalCalories()
    }
    
    func clearAllEntries() {
        calorieEntries = []
        calculateTotalCalories()
        saveEntries()
    }
    
} //End of class
