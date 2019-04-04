//
//  ViewController.swift
//  ToDoey
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import UIKit
import CoreData
class ToDoViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogormon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        loadItem()
        
        
    }
    
    //TODO: MARK--tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ?.checkmark:.none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row].done)
        
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        
    }
    //TODO: MARK-Add new items
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField ()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(alert) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.saveItem()
            
            //self.defaults.set(self.itemArray, forKey: "TodoList")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            //print(alertTextField.text!)
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItem () {
        
        do {
            try context.save()
        }catch{
            print("\(error)error saving centext")
            
        }
        tableView.reloadData()
        
    }
    
    func loadItem (with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
            
        }catch{
            print("\(error)")
        }
        tableView.reloadData()
        
    }
}

extension ToDoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest <Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request)
        //        do{
        //            itemArray = try context.fetch(request)
        //
        //        }catch{
        //            print("\(error)")
        //        }

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItem()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }
}
