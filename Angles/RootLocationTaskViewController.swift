//
//  RootLocationTaskViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/8/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit
import Pager

class RootLocationTaskViewController: PagerController, PagerDataSource, PagerDelegate {
    
    static var instance:RootLocationTaskViewController?

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hintDescriptionStackView: UIStackView!
    var beacons:[Beacon] = []
    var parentVc:RootHomeViewController?
    var viewControllers:[UIViewController] = []
    var names: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        RootLocationTaskViewController.instance = self
        
        // Do any additional setup after loading the view.
        if parentVc == nil {
            return
        }
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = .clear
        self.contentViewBackgroundColor = .clear
        self.setupPaging()
        self.setupPager(tabNames: names,
                        tabControllers: viewControllers)
        customizeTab()
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SETUP PAGING
    func setupPaging() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        vc.parentVc = self
        self.viewControllers.append(vc)
        self.names.append("")
        
        for beacon in self.beacons{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
            vc.beacon = beacon
            vc.parentVc = self
            self.viewControllers.append(vc)
            self.names.append("")
        }

    }
    
    func didChangeTabToIndex(_ pager: PagerController, index: Int, previousIndex: Int) {
        
        if let vc = self.viewControllers[index] as? TaskViewController{
            if vc.pageViewController != nil{
                if vc.pageViewController.currentPageIndex == 1{
                    self.hideControls(hide: true)
                    return
                }
            }
            
        }
        
        if index == 0{
            self.backButton.isHidden = true
            self.hintDescriptionStackView.isHidden = true
        }else if index == (tabCount-1){
            self.nextButton.isHidden = true
            self.backButton.isHidden = false
            self.hintDescriptionStackView.isHidden = false
        }else{
            self.backButton.isHidden = false
            self.nextButton.isHidden = false
            self.hintDescriptionStackView.isHidden = false
        }
    }
    
    func selectNextTab() {
        if activeTabIndex < tabCount {
            self.selectTabAtIndex(activeTabIndex + 1)
        }
    }
    
    func selectTab(tabIndex:Int) {
        if tabIndex < tabCount && activeTabIndex >= 0{
            self.selectTabAtIndex(tabIndex)
        }
    }
    
    func selectPreviousTab() {
        if activeTabIndex >= 0 {
            self.selectTabAtIndex(activeTabIndex - 1)
        }
    }
    
    func hideControls(hide:Bool) {
        if hide{
            self.hintDescriptionStackView.isHidden = hide
            self.backButton.isHidden = hide
            self.nextButton.isHidden = hide
        }else{
            let index = self.activeTabIndex
            if index == 0{
                self.backButton.isHidden = true
                self.hintDescriptionStackView.isHidden = true
            }else if index == (tabCount-1){
                self.nextButton.isHidden = true
                self.backButton.isHidden = false
                self.hintDescriptionStackView.isHidden = false
            }else{
                self.backButton.isHidden = false
                self.nextButton.isHidden = false
                self.hintDescriptionStackView.isHidden = false
            }
        }
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.selectNextTab()
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.selectPreviousTab()
    }
    
    // Customising the Tab's View
    func customizeTab() {
        tabHeight = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
