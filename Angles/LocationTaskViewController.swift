//
//  LocationTaskViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit
import CoreData

class LocationTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var parentVc:TaskViewController?
    var beacon:Beacon?
    var tasks:[Task] = []
    let reuseIdentifierToDoCell = "ToDoCell"
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        //Add Search Predicate
        if let beacon = self.beacon{
            print("Becaon Type: \(beacon.beaconType)")
            fetchRequest.predicate = NSPredicate(format: "(taskType == %@)", beacon.beaconType)
        }
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userNameButton.setTitle(Utils.getUserFullName(), for: .normal)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if let beacon = self.beacon{
            taskNameLabel.text = beacon.title
            taskCountLabel.text = " Items Due"
        }
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func getTasks() {
        if let beacon = self.beacon{
            let fetchRequest:NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "(taskType == %@)", beacon.beaconType)
            do{
                let tasksFetched = try context.fetch(fetchRequest)
                print("Found \(tasksFetched.count) for \(beacon.beaconType)")
                self.tasks = tasksFetched
                self.tableView.reloadData()
            
            }catch{
                print("Error Getting Tasks")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUpAction(_ sender: UIButton) {
        self.parentVc?.pageViewController.scrollToViewController(index: 0)
    }

    //Core Data
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath as IndexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! TaskItemTableViewCell
                self.configureCell(cell: cell, atIndexPath: indexPath as IndexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .fade)
            }
            break;
        }
    }
    
    //MARK: -Table View Delegate
    func configureCell(cell: TaskItemTableViewCell, atIndexPath indexPath: IndexPath) {
        // Fetch Record
        let record = fetchedResultsController.object(at: indexPath)
        
        // Update Cell
        cell.taskCounterLabel.text = "\(indexPath.item+1)"
        
        if let taskTitle = record.value(forKey: "taskTitle") as? String {
            cell.taskTitleLabel.text = taskTitle
        }
        
        if let taskType = record.value(forKey: "taskType") as? String {

        }
        
        if let taskDescription = record.value(forKey: "taskDescription") as? String {
            cell.taskDescriptionLabel.text = taskDescription
        }
        if let dueDate = record.value(forKey: "dueDate") as? Date {
            cell.taskDueLabel.text = ""
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.tasks[indexPath.item];
        let editTaskVc = self.storyboard?.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        editTaskVc.editTask = .new
        editTaskVc.beaconType = self.beacon?.beaconType
        editTaskVc.task = task
        self.present(editTaskVc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemTableViewCell") as! TaskItemTableViewCell
        self.configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            print("Remove Int: \(indexPath.item)")
            let item = self.tasks[indexPath.item]
            //Delete Item From Data
            context.delete(item)
            saveContext()
            self.tasks.remove(at: indexPath.item)
            self.tableView.reloadData()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addTaskButton(_ sender: UIButton) {
        let editTaskVc = self.storyboard?.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        editTaskVc.editTask = .new
        editTaskVc.beaconType = self.beacon?.beaconType
        self.present(editTaskVc, animated: true, completion: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
