//
//  LocationTaskViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit
import CoreData

class LocationTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var parentVc:TaskViewController?
    var beacon:Beacon?
    var tasks:[Task] = []
    
    
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
        self.getTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUpAction(_ sender: UIButton) {
        self.parentVc?.pageViewController.scrollToViewController(index: 0)
    }

    
    //MARK: -Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.tasks[indexPath.item];
        let editTaskVc = self.storyboard?.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        editTaskVc.editTask = .new
        editTaskVc.beaconType = self.beacon?.beaconType
        editTaskVc.task = task
        self.present(editTaskVc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.tasks[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemTableViewCell") as! TaskItemTableViewCell
        cell.taskTitleLabel.text = item.taskTitle
        cell.taskDescriptionLabel.text = item.taskDescription
        cell.taskDueLabel.text = ""
        cell.taskCounterLabel.text = "\(indexPath.item+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
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
