//
//  SetupViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enterButton.isEnabled = false

        //Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Delegates
        firstNameTextField.delegate = self
        firstNameTextField.tag = 0
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Keyboard Hidden
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }
    
    //UI Text Field Delegate
    //MARK: - Keyboard Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            self.lastNameTextField.becomeFirstResponder()
            return false
        default:
            self.view.endEditing(true)
            return true
        }
    }
    
    func checkButtonEnabled() {
        if let firstName = self.firstNameTextField.text, let lastName = self.lastNameTextField.text{
            if valid(string: firstName) && valid(string: lastName){
                self.enterButton.isEnabled = true
            }else{
                self.enterButton.isEnabled = false
            }
        }else{
            self.enterButton.isEnabled = false
        }
    }
    
    func signup() {
        if let firstName = self.firstNameTextField.text, let lastName = self.lastNameTextField.text{
            if valid(string: firstName) && valid(string: lastName){
                
                //Signup User
                Utils.signupUser(firstName: firstName, lastName: lastName)
                
                //Navigate Away
                if Utils.permissionsEnabled(){
                    self.navigateToMain()
                }else{
                    let permissionVc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
                    permissionVc.fromSetup = true
                    self.navigationController?.pushViewController(permissionVc, animated: true)
                    return
                }
                
            }
        }
        self.showMessage(title: "Oops", message: "Something unexpected occurred during signup.")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.checkButtonEnabled()
        return true
    }
    
    @IBAction func enterAction(_ sender: UIButton) {
        self.signup()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
