//
//  EditTaskViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let contentHint = "Add Description"
    var editTask:EditTask = .new
    var task:Task?
    var beaconType:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.saveButton.isEnabled = false

        self.titleField.delegate = self
        self.titleField.tag = 0
        
        self.textView.delegate = self
        self.textView.tag = 1
        textView.text = contentHint
        textView.textColor = UIColor.lightGray
        
        if editTask == .edit, let task = self.task{
            if valid(string: task.taskDescription){
                self.textView.text = task.taskDescription
                textView.textColor = UIColor.white
            }
            
            if valid(string: task.taskTitle){
                self.titleField.text = task.taskTitle
            }
            
        }
        
        //Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Keyboard Hidden
    func keyboardWillShow(notification: NSNotification) {
        print("Keybaord Will Show")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("Keybaord Will Hide")
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomConstraint.constant != 0{
                self.bottomConstraint.constant = 0
            }
        }
    }
    
    //MARK: TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            view.endEditing(true)
            return false
        }else{
            return true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentHint
            textView.textColor = UIColor.lightGray
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
    
    func checkButtonEnabled() {
        if let title = self.titleField.text{
            if valid(string: title){
                self.saveButton.isEnabled = true
            }else{
                self.saveButton.isEnabled = false
            }
        }else{
            self.saveButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textView.becomeFirstResponder()
            return false
        default:
            self.view.endEditing(true)
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.checkButtonEnabled()
        return true
    }
    
    
    @IBAction func closeWhite(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if editTask == .edit, let task = self.task, let beaconType = self.beaconType, let title = self.titleField.text{
            task.taskTitle = title
            task.taskType = beaconType
            task.taskDescription = self.textView.text
            saveContext()
            print("Task Updated for beacon: \(beaconType)")
        }else if editTask == .new, let beaconType = self.beaconType, let title = self.titleField.text{
            let task = Task(context: context)
            task.taskTitle = title
            task.taskType = beaconType
            task.taskDescription = self.textView.text
            saveContext()
            print("New Task Created for beacon: \(beaconType)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

public enum EditTask{
    case edit, new
}
