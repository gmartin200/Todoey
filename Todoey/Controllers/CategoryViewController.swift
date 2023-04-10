//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Greg Martin on 3/28/23.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    var deleteState = false
    @IBOutlet weak var delAddButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteState = false
        delAddButton.title = "Add"
        addButton.isEnabled = true
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Cetegories Added Yet"
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deleteState == false {
            performSegue(withIdentifier: "goToItems", sender: self)
        } else {
            if let category = categories?[indexPath.row] {
                do {
                    try realm.write() {
                        realm.delete(category)
                    }
                } catch {
                    print("Error deleting category \(error)")
                }
            }
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: Seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()

    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // this is called when the "+" button is pressed
        if deleteState == false {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { action in
                //This is what happens once the user clicks the Add Category button on our UIAlert
                let newCategory = Category()
                newCategory.name = textField.text!
                self.save(category : newCategory)
            }
            
            alert.addTextField { field in
                textField.placeholder = "Add a new category"
                textField = field
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Toggle between Adding and Deleting Categories
    @IBAction func deleteAddToggleButtonPressed(_ sender: UIBarButtonItem) {
        deleteState = !deleteState
        if deleteState {
            delAddButton.title = "Del"
            addButton.isEnabled = false
        } else {
            delAddButton.title = "Add"
            addButton.isEnabled = true
        }
    }
}
