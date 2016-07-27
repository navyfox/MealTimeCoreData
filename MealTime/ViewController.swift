//
//  ViewController.swift
//  MealTime
//
//  Created by Ivan Akulov on 30/11/15.
//  Copyright © 2015 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var array: Array<NSDate> = []
    var managedObjectContext: NSManagedObjectContext!
    var currentPerson: Person!
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let myEntity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        let personName = "Max"

        let fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "name == %@", personName)

        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Person]
            if !result.isEmpty {
                currentPerson = result.first
            } else {
                currentPerson = NSManagedObject(entity:  myEntity!, insertIntoManagedObjectContext: managedObjectContext) as! Person
                currentPerson.name = personName
                try managedObjectContext.save()
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPerson.meals!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let meal = currentPerson.meals![indexPath.row] as! Meal
        
        cell!.textLabel!.text = dateFormatter.stringFromDate(meal.date!)
        return cell!
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let itemToDelete = currentPerson.meals![indexPath.row] as! Meal
            managedObjectContext.deleteObject(itemToDelete)

            do {
                try managedObjectContext.save()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
}
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let mealEntity = NSEntityDescription.entityForName("Meal", inManagedObjectContext: managedObjectContext)
        let meal = NSManagedObject(entity: mealEntity!, insertIntoManagedObjectContext: managedObjectContext) as! Meal

        meal.date = NSDate()

        let meals = currentPerson.meals?.mutableCopy() as! NSMutableOrderedSet
        meals.addObject(meal)
        currentPerson.meals = meals.copy() as? NSOrderedSet

        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Error occured: \(error.localizedDescription)")
        }

        tableView.reloadData()
    }

}

