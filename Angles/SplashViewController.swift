//
//  SplashViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func getStartedAction(_ sender: UIButton) {
        let setupVc = self.storyboard?.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
        self.navigationController?.pushViewController(setupVc, animated: true)
    }

    @IBAction func aboutAction(_ sender: UIButton) {
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
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

}
