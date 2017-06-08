//
//  FullScreenPageViewController.swift
//  Angles
//
//  Created by Antonio Allen on 6/8/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class FullScreenPageViewController: UIPageViewController, UIPageViewControllerDelegate,UIPageViewControllerDataSource, UIScrollViewDelegate {
    var allChildControllers : [UIViewController]
    var scrollView: UIScrollView? = nil
    var pageControl: UIPageControl?
    var pagerProtocol: FullPagerProtocol?
    var scrollViewDelegate:UIScrollViewDelegate?
    var currentPageIndex:Int = 0
    var frame:CGRect?
    var bounceEnable = false
    var restrictive = false
    
    init(childControllers : [UIViewController], pageController: UIPageControl?, frame:CGRect?, navigationOrientation:UIPageViewControllerNavigationOrientation, currentIndex:Int?) {
        allChildControllers = childControllers;
        self.pageControl = pageController
        self.frame = frame
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: navigationOrientation, options: Optional.none);
        if let currentIndex = currentIndex{
            self.currentPageIndex = currentIndex
        }
        self.setViewControllers([childControllers[currentIndex ?? 0]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: Optional.none)
        self.dataSource = self
        self.delegate = self
        pageControl?.numberOfPages = allChildControllers.count
        print("Added Page Control")
    }
    
    func enableSwipe(enable:Bool) {
        if enable {
            self.dataSource = self
        }else{
            self.dataSource = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * Expand the scroll view to take up all the space.
     * Also bring the pager control to the front.
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let subViews: NSArray = view.subviews as NSArray
        
        
        for view in subViews {
            if view is UIScrollView {
                self.scrollView = view as? UIScrollView
                scrollView?.delegate = self
                if let frame = self.frame{
                    self.scrollView?.frame = frame
                    print("Setting Scroll View Width: \(frame.width)")
                }
                
            }
        }
        
        
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(viewController: nextViewController)
        }
    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyOfNewIndex()
        })
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = allChildControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = allChildControllers[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    private func notifyOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = allChildControllers.index(of: firstViewController) {
            currentPageIndex = index
            pagerProtocol?.pageDidSwipe(index: index)
            pageControl?.currentPage = index
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        for (index, ctrl) in allChildControllers.enumerated() {
            if ctrl == viewController {
                if index < allChildControllers.count - 1 {
                    return allChildControllers[index + 1]
                }
                
                break
            }
        }
        
        return Optional.none
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        for (index, ctrl) in allChildControllers.enumerated() {
            if ctrl == viewController {
                if index > 0 {
                    return allChildControllers[index - 1]
                }
                
                break
            }
        }
        
        return Optional.none
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.notifyOfNewIndex()
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return allChildControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return Int(currentPageIndex)
    }
    
    
    
    //Scroll View Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if restrictive {
            self.view.isUserInteractionEnabled = false
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.view.isUserInteractionEnabled = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        //Disable Bounce
        if !bounceEnable{
            if currentPageIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
            } else if currentPageIndex == allChildControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
            }
        }
        
        self.determineScrollPercentage(scrollView: scrollView)
        
    }
    
    func determineScrollPercentage(scrollView: UIScrollView) {
        var scrollDirection:ScrollDirection
        
        if self.navigationOrientation == .horizontal {
            var translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
            //print("Dragging X: \(translation.x)")
            if translation.x > 0 {
                // react to dragging right
                //print("Dragging Right")
                scrollDirection = .right
            }else {
                // react to dragging left
                //print("Dragging Left")
                scrollDirection = .left
            }
            
            let movedRatio: CGFloat = (scrollView.contentOffset.x / scrollView.frame.width) - 1
            print("Moved Ratio \(movedRatio)")
            
            if movedRatio == 0.0 {
                //print("End")
                //print("Active Index: \(currentPageIndex)")
                return
            }
            
            let totalPercentage = calculateTotalPercentage(ratio: movedRatio, currentIndex: currentPageIndex, totalPages: self.allChildControllers.count)
            let partialPercentage = determinePartialPercentage(fullPercentage: totalPercentage)
            
            self.pagerProtocol?.onScrollPercentage(scrollPercentage: totalPercentage, partialPercentage: partialPercentage , scrollDirection: scrollDirection)
            
        }else{
            var translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
            //print("Dragging X: \(translation.x)")
            if translation.y > 0 {
                // react to dragging right
                //print("Dragging Right")
                scrollDirection = .top
            }else {
                // react to dragging left
                //print("Dragging Left")
                scrollDirection = .bottom
            }
            
            let movedRatio: CGFloat = (scrollView.contentOffset.y / scrollView.frame.height) - 1
            print("Moved Ratio \(movedRatio)")
            
            if movedRatio == 0.0 {
                //print("End")
                //print("Active Index: \(currentPageIndex)")
                return
            }
            
            let totalPercentage = calculateTotalPercentage(ratio: movedRatio, currentIndex: currentPageIndex, totalPages: self.allChildControllers.count)
            let partialPercentage = determinePartialPercentage(fullPercentage: totalPercentage)
            
            self.pagerProtocol?.onScrollPercentage(scrollPercentage: totalPercentage, partialPercentage: partialPercentage , scrollDirection: scrollDirection)
        }
        
        
    }
    
    func determinePartialPercentage(fullPercentage:CGFloat) -> CGFloat {
        let fullPercentage = 0.5 - fullPercentage
        if fullPercentage < 0.5 {
            let percentage = abs(fullPercentage / 0.5)
            
            if percentage > 1.0 {
                return 1.0
            }else if percentage < 0.0{
                return 0.0
            }else{
                return percentage
            }
            
        }else{
            return CGFloat(1.0)
        }
    }
    
    func calculateTotalPercentage(ratio:CGFloat, currentIndex:Int, totalPages:Int) -> CGFloat {
        let betweenIndex = CGFloat(currentIndex)+ratio
        let totalPecentage = betweenIndex/CGFloat(totalPages-1)
        //print("Total Percentage: \(totalPecentage)")
        return totalPecentage
    }
    
}

public enum ScrollDirection{
    case left, right, top, bottom
}

protocol FullPagerProtocol: UIPageViewControllerDelegate {
    func pageDidSwipe(index:Int)
    func onScrollPercentage(scrollPercentage: CGFloat, partialPercentage: CGFloat, scrollDirection: ScrollDirection)
}
