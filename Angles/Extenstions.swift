//
//  Extenstions.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import Foundation
import UIKit

//Is Simulator
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

//Valid Data Types
func valid(string:String) -> Bool{
    return !string.isEmpty
}

func valid(string:String?) -> Bool{
    if string != nil && !string!.isEmpty{
        return true
    }else{
        return false
    }
}

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func saveContext() {
    //Save data to core data
    print("Saving Context")
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

enum CameraType {
    case Front, Back
}

func calcAge(birthday:String) -> Int {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "MM/dd/yyyy"
    let birthdayDate = dateFormater.date(from: birthday)
    let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
    let now: NSDate! = NSDate()
    let calcAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
    let age = calcAge.year
    return age!
}

func metersToFeet(meters:Double) ->Double {
    //print("Meters: \(meters)")
    let feet = meters * 3.28084
    return feet as Double
}

func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let output = filter.outputImage?.applying(transform) {
            return UIImage(ciImage: output)
        }
    }
    
    return nil
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(view: self)
        navigationBarImageView!.isHidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(view: self)
        navigationBarImageView!.isHidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(view: subview) {
                return imageView
            }
        }
        return nil
    }
}

extension UIToolbar {
    
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(view: self)
        navigationBarImageView!.isHidden = true
    }
    
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(view: self)
        navigationBarImageView!.isHidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInToolbar(view: subview) {
                return imageView
            }
        }
        return nil
    }
}

extension String {
    
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    subscript(range: CountableRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)]
    }
    func trunc(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}

public extension UITextField{
    func isEmpty() -> Bool {
        if let text = self.text {
            return text.isEmpty
        }
        return true
    }
}


public extension UIView{
    
    func pauseAnimation(delay: Double) {
        let time = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, time, 0, 0, 0, { timer in
            let layer = self.layer
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0.0
            layer.timeOffset = pausedTime
        })
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    }
    
    func resumeAnimation() {
        let pausedTime  = layer.timeOffset
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    }
    
    func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // 1
        if !self.isUserInteractionEnabled || self.isHidden || self.alpha == 0 {
            return nil
        }
        //2
        var hitView: UIView? = self
        if !self.point(inside: point, with: event) {
            if self.clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        //3
        for subview in self.subviews.reversed() {
            let insideSubview = self.convert(point, to: subview)
            if let sview = subview.overlapHitTest(point: insideSubview, withEvent: event) {
                return sview
            }
        }
        return hitView
    }
    
}
public extension UIViewController{
    
    func navigateToPermission() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func navigateToLogin() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        let navVc = UINavigationController(rootViewController: vc)
        self.present(navVc, animated: true, completion: nil)
    }
    
    func navigateToMain() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootHomeViewController") as! RootHomeViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func setNavigationTitle(title:String) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 18)!,  NSForegroundColorAttributeName: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.showBottomHairline()
    }
    
    func setBackButton(image:UIImage, text:String?, tintColor:UIColor) {
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.tintColor = tintColor
    }
    
    func showMessage(title:String, message:String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func buildAlert(title:String, message:String, actions:[UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions{
            alertController.addAction(action)
        }
        return alertController
    }
    
    func showListOptionsAlert(title:String?, message:String?, actions:[UIAlertAction]) {
        let optionMenu = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions{
            optionMenu.addAction(action)
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String, actions:[UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions{
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
public extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

public extension UIImageView{
    func maskImage(image:UIImage, mask:(UIImage)){
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: maskReference!.width,
                                height: maskReference!.height,
                                bitsPerComponent: maskReference!.bitsPerComponent,
                                bitsPerPixel: maskReference!.bitsPerPixel,
                                bytesPerRow: maskReference!.bytesPerRow,
                                provider: maskReference!.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference!.masking(imageMask!)
        let maskedImage = UIImage(cgImage:maskedReference!)
        self.image = maskedImage
    }
}

public extension UIView{
    func makeCircle(color:UIColor, borderWidth:CGFloat) {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func edgeRadius(color:UIColor, radius:CGFloat) {
        layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}


public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
