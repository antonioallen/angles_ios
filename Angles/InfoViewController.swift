//
//  InfoViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var parentVc:RootLocationTaskViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameLabel.text = Utils.getUserFullName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetAngles(_ sender: UIButton) {
        let okAction = UIAlertAction(title: "Reset", style: .default) { (action) in
            Utils.clearPrefernces()
            self.parentVc?.parentVc?.navigateToLogin()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("User canceled action")
        }
        self.showAlert(title: "Are you sure?", message: "Are you sure you want to reset your account? You will loose all your tasks.", actions: [okAction, cancelAction])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
