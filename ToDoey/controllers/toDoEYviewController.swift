//
//  ViewController.swift
//  ToDoey
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoViewController: UITableViewController {
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    
    var todoItems : Results<Item>?
    
    
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogormon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
    }
    
    //TODO: MARK--tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ?.checkmark:.none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        
        
    }
    //TODO: MARK-Add new items
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField ()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(alert) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("\(error)")
                }
            }
            self.tableView.reloadData()
            
            
            
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
    
    
    func loadItem () {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        request.predicate = predicate
        //
        //        if let additionalPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        //        }else{
        //            request.predicate = categoryPredicate
        //        }
        //
        //        do{
        //            itemArray = try context.fetch(request)
        //
        //        }catch{
        //            print("\(error)")
        //        }
        tableView.reloadData()
        
    }
}

//extension ToDoViewController : UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest <Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItem(with: request, predicate: predicate)
//        //        do{
//        //            itemArray = try context.fetch(request)
//        //
//        //        }catch{
//        //            print("\(error)")
//        //        }
//
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItem()
//            DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
