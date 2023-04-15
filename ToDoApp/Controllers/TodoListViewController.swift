//
//  ViewController.swift
//  ToDoApp
//
//  Created by Andrey on 10.04.2023.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        context.delete(todoItems[indexPath.row])
        //        todoItems.remove(at: indexPath.row)
        
        
        //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        //
        //        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem, item: Item) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo item!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                   print("Error saving item, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    //MARK: - Model Methods

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title")
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//
//
//}
