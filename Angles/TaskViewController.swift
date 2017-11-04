//
//  TaskViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/8/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, FullPagerProtocol {

    var beacon:Beacon?
    var pageViewController:FullScreenPageViewController! = nil
    var parentVc:RootLocationTaskViewController?
    
    //VCs
    var locationViewController:LocationViewController! = nil
    var locationTaskViewController:LocationTaskViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let beacon = self.beacon{
            self.setupPaging(beacon: beacon)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupPaging(beacon:Beacon) {
        //Create the child view controllers
        self.locationViewController = storyboard!.instantiateViewController(
            withIdentifier: "LocationViewController") as! LocationViewController
        self.locationViewController.parentVc = self
        self.locationViewController.beacon = beacon
        
        self.locationTaskViewController = storyboard!.instantiateViewController(
            withIdentifier: "LocationTaskViewController") as! LocationTaskViewController
        self.locationTaskViewController.parentVc = self
        self.locationTaskViewController.beacon = beacon
        
        pageViewController = FullScreenPageViewController(childControllers: [self.locationViewController, self.locationTaskViewController], pageController: nil, frame: self.view.frame, navigationOrientation: .vertical, currentIndex: 0)
        
        if pageViewController != nil {
            //Create the page view controller
            pageViewController.pagerProtocol = self
            pageViewController.bounceEnable = true
            pageViewController.restrictive = false
            pageViewController.view.frame = self.view.frame
            pageViewController.view.backgroundColor = UIColor.clear
            //Show the page view controller
            self.view.addSubview(self.pageViewController.view)
        }
        
        
    }
    
    //Parent View Delegate
    func onControllerFocused() {
        
    }
    
    func onControllerNotFocused() {
        
    }
    
    //Pager Delegate
    func onScrollPercentage(scrollPercentage: CGFloat, partialPercentage: CGFloat, scrollDirection: ScrollDirection) {
        print("Partial Percentage: \(partialPercentage)")
      
        if scrollDirection == .top && self.pageViewController.currentPageIndex == 0 {
            self.parentVc?.hideControls(hide: false)
        }else{
            self.parentVc?.hideControls(hide: true)
        }
        
    }
    
    func pageDidSwipe(index: Int) {
        print("Page Index Changed")
        switch index {
        case 0:
            self.parentVc?.hideControls(hide: false)
            break
        case 1:
            self.parentVc?.hideControls(hide: true)
            break
        default:
            break
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

}
