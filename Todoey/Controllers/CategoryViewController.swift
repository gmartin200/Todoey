//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Greg Martin on 3/28/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var deleteState = false
    @IBOutlet weak var delAddButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(dataFilePath)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print("\(deleteState)")
        deleteState = false
        delAddButton.title = "Add Categories"
        addButton.isHidden = false
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deleteState == false {
            performSegue(withIdentifier: "goToItems", sender: self)
        } else {
            context.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            saveCategories()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
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
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categories.append(newCategory)
//                do {
//                    try self.categories.sort(by: <#T##(Category, Category) throws -> Bool#>)
//                } catch {
//                    print("Error sorting: \(error)")
//                }
//                categories.sort(using: Category)
                self.saveCategories()
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
            delAddButton.title = "Del Categories"
            addButton.isHidden = true
        } else {
            delAddButton.title = "Add Categories"
            addButton.isHidden = false
        }
    }
}
