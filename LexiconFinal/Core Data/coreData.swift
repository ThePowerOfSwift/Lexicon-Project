//
//  coreData.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 09.06.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit
import CoreData

var savedArray = [TheWord]()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


final class coreData{
    
    class func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    class func loadData(tableView: UITableView) {
        let request : NSFetchRequest<TheWord> = TheWord.fetchRequest()
        do {
            let sortDescriptor = NSSortDescriptor(key: "word", ascending: true) // Displaying Alphabetically
            request.sortDescriptors = [sortDescriptor]
            savedArray = try context.fetch(request)
        } catch {
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }
    
    class func checkAlreadySavedRows(text: String, bookMarked: inout [Bool], i: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TheWord")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if text == (data.value(forKey: "definition") as! String){
                    bookMarked[i] = true
                }
            }
        } catch {
            print("Failed")
        }
    }
}
