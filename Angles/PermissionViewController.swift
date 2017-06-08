//
//  PermissionViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit
import PermissionScope

class PermissionViewController: UIViewController {

    //View
    @IBOutlet weak var enableLocationButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    //Vars
    let pscope = PermissionScope()
    var fromSetup:Bool = false
    
    var locationEnabled = false{
        didSet{
            if locationEnabled {
                self.finishButton.isHidden = false
            }else{
                self.finishButton.isHidden = true
            }
            
            if locationEnabled{
                self.enableLocationButton.setTitleColor(colorPopPurple, for: .normal)
                self.enableLocationButton.setImage(#imageLiteral(resourceName: "location_icon_color"), for: .normal)
                self.enableLocationButton.setBackgroundImage(#imageLiteral(resourceName: "rounded_button_filled_white"), for: .normal)
            }else{
                self.enableLocationButton.setTitleColor(.white, for: .normal)
                self.enableLocationButton.setImage(#imageLiteral(resourceName: "location_icon_small_white"), for: .normal)
                self.enableLocationButton.setBackgroundImage(#imageLiteral(resourceName: "rounded_button_outline_white"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.finishButton.isHidden = true
        
        pscope.viewControllerForAlerts = self
        
        pscope.onAuthChange = { (finished, results) in
            print("Request was finished with results \(results)")
            
            if self.pscope.statusLocationAlways() == .authorized {
                self.locationEnabled = true
            }else{
                self.locationEnabled = false
            }
        }
        pscope.onCancel = { results in
            print("Request was cancelled with results \(results)")
        }
        pscope.onDisabledOrDenied = { results in
            print("Request was denied or disabled with results \(results)")
        }
        
        //Determine Button State
        
        if pscope.statusLocationAlways() == .authorized {
            self.locationEnabled = true
        }else{
            self.locationEnabled = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func enableLocationAction(_ sender: UIButton) {
        if pscope.statusLocationInUse() != .authorized{
            pscope.requestLocationAlways()
        }
    }
    
    
    @IBAction func finishButtonAction(_ sender: UIButton) {
        if self.fromSetup{
            let congratsVc = self.storyboard?.instantiateViewController(withIdentifier: "CongratsViewController") as! CongratsViewController
            self.navigationController?.pushViewController(congratsVc, animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
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
