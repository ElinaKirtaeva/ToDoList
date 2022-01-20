//
//  TableViewController.swift
//  ToDoList
//
//  Created by Элина Рупова on 20.01.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let req: NSFetchRequest<Task> = Task.fetchRequest()
//        if let result = try? context.fetch(req) {
//            for objects in result {
//                context.delete(objects)
//            }
//        }
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print(error.description)
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let allertController = UIAlertController(title: "New task", message: "Please add new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { Action in
            let tf = allertController.textFields?.first
            if let newTask = tf?.text {
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        
        allertController.addTextField { _ in}
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {  _ in}
        allertController.addAction(saveAction)
        allertController.addAction(cancelAction)
        
        present(allertController, animated: true, completion: nil)
        
    }
    
    private func saveTask(withTitle title: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
        
        let taskOblect = Task(entity: entity, insertInto: context)
        taskOblect.title = title
        
        do {
            try context.save()
            tasks.append(taskOblect)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let req: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDesc = NSSortDescriptor(key: "title", ascending: false)
        req.sortDescriptors = [sortDesc]
        do {
            tasks = try context.fetch(req)
        } catch let error as NSError {
            print(error.description)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title

        return cell
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
