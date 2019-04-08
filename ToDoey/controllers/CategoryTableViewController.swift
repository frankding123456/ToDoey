//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by User on 2019/4/5.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    var categories : Results<Category>!
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK - TABLEVIEW DELEGATE Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - TABLEVIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
//        cell.delegate = self
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Item Added"
        return cell
    }
    //MARK - DATA MANIPULATE METHOD
    func save(category : Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("\(error)")
        }
        tableView.reloadData()
    }
    //MARK - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("\(error)")
            }
        }
    }
    func loadCategories() {
        categories = realm.objects(Category.self)
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //        do {
        //            categories = try context.fetch(request)
        //        }catch{
        //            print("\(error)")
        //        }
        tableView.reloadData()
    }
    
    //MARK - ADD NEW CATEGORY
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController (title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textFiled.text!
            
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField(configurationHandler: { (field) in
            textFiled = field
            textFiled.placeholder = "Add a New Category"
        })
        present(alert, animated: true, completion: nil)
    }
}

// MARK - SWIPE CELL DELEGATE METHODS
