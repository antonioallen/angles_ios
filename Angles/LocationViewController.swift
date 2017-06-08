//
//  LocationViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    var parentVc:TaskViewController?
    var beacon:Beacon?
    
    @IBOutlet weak var beaconTitle: UILabel!
    @IBOutlet weak var beaconDescriptionLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskDueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.'
        
        if let beacon = self.beacon{
            beaconTitle.text = beacon.title
            beaconDescriptionLabel.text = beacon.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cardUpAction(_ sender: UIButton) {
        //self.parentVc?.pageViewController.scrollToViewController(index: 1)
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
