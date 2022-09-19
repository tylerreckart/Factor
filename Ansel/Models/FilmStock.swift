//
//  FilmStock.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/30/22.
//

import Foundation
import CoreData

struct FilmStock: Identifiable, Equatable {
    static func == (lhs: FilmStock, rhs: FilmStock) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String {
        self.name
    }
    
    var manufacturer: String
    var name: String
    var iso: Int32
    var pFactor: Double?
    var threshold: Int32?
    var notes: String?
}

let filmOptions = [
    FilmStock(manufacturer: "Ilford", name: "SFX", iso: 200, pFactor: 1.43, threshold: 1),
    FilmStock(manufacturer: "Ilford", name: "Pan F+", iso: 50, pFactor: 1.33, threshold: 1),
    FilmStock(manufacturer: "Ilford", name: "Delta 100", iso: 100, pFactor: 1.26, threshold: 1),
    FilmStock(manufacturer: "Ilford", name: "Delta 400", iso: 400, pFactor: 1.41, threshold: 1),
    FilmStock(manufacturer: "Ilford", name: "Delta 3200", iso: 3200, pFactor: 1.33, threshold: 1),
    FilmStock(manufacturer: "Ilford", name: "FP4+", iso: 125, pFactor: 1.26, threshold: 1),
    FilmStock(manufacturer: "Ilford", name: "HP5+", iso: 400, pFactor: 1.31, threshold: 1),
    FilmStock(manufacturer: "Ilford", name: "XP2", iso: 400, pFactor: 1.31, threshold: 1),
    FilmStock(manufacturer: "Kodak", name: "Gold 200", iso: 200, pFactor: 1.33, threshold: 1),
    FilmStock(manufacturer: "Kodak", name: "Portra 160", iso: 160, pFactor: 1.33, threshold: 1),
    FilmStock(manufacturer: "Kodak", name: "Portra 400", iso: 400, pFactor: 1.33, threshold: 1),
    FilmStock(manufacturer: "Kodak", name: "Portra 800", iso: 800, pFactor: 1.33, threshold: 1),
    FilmStock(manufacturer: "Kodak", name: "Ektachrome E100", iso: 100, pFactor: 1.33, threshold: 10),
    FilmStock(manufacturer: "Rollei", name: "IR 400", iso: 400, pFactor: 1.31, threshold: 1),
    FilmStock(manufacturer: "Fujifilm", name: "Velvia 50", iso: 50, pFactor: 1.33, threshold: 4),
    FilmStock(manufacturer: "Fujifilm", name: "Provia 100F", iso: 100, pFactor: 1.33, threshold: 1),
]

let isos: [Int32] = [
    50, 64, 80, 100, 125, 160, 200, 250, 320, 400, 500, 640, 800, 1000, 1250, 1600, 2000, 2500, 3200
]

func seedEmulsions(context: NSManagedObjectContext) {
    for opt in filmOptions {
        let newEmulsion = Emulsion(context: context)
        
        newEmulsion.manufacturer = opt.manufacturer
        newEmulsion.name = opt.name
        newEmulsion.iso = opt.iso
        newEmulsion.pFactor = opt.pFactor!
        newEmulsion.threshold = opt.threshold!
        
        do {
            try context.save()

            UserDefaults.standard.set(false, forKey: "firstRun")
            UserDefaults.standard.set(true, forKey: "seeded")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
