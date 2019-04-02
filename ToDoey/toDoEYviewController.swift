//
//  ViewController.swift
//  ToDoey
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogormon"]
let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoList") as? [String]{
            itemArray = items
        }
    }

    //TODO: MARK--tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray [indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }

    }
    //TODO: MARK-Add new items
   
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField ()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (alert) in
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            
            self.defaults.set(self.itemArray, forKey: "TodoList")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            //print(alertTextField.text!)
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

