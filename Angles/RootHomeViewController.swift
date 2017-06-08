//
//  ViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class RootHomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootLocationTaskViewController") as! RootLocationTaskViewController
        vc.beacons = AppDelegate.instance?.beacons ?? []
        vc.parentVc = self
        vc.view.frame = self.view.frame
        vc.view.backgroundColor = UIColor.clear
        self.view.addSubview(vc.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        //Check If User is Valid
        if !Utils.userValid(){
            self.navigateToLogin()
        }else if !Utils.permissionsEnabled(){
            self.navigateToPermission()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}

