//
//  ViewController.swift
//  ToDoey
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ToDoViewController: SwipeTableViewController {
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    

    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogormon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        
        updateNavBar(withHexCode: colourHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        updateNavBar(withHexCode: "00FFE8")
    }
    
    func updateNavBar (withHexCode colourHexCode : String) {
        guard let navBar = navigationController?.navigationBar else {fatalError()}
        guard let navBarColor = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.barTintColor = navBarColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBarOutlet.barTintColor = navBarColor
       
    }
    
    //TODO: MARK--tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ?.checkmark:.none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        if  let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            
        }
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Erroe deleting Item, \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
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
                        newItem.dateCreated = Date()
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

extension ToDoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
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
