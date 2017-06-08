//
//  Utils.swift
//  Angles
//
//  Created by Antonio Allen on 6/7/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import Foundation
import PermissionScope
import CoreLocation

class Utils {
    
    //Permission
    public static func permissionsEnabled() -> Bool{
        //Check Location Enabled
        let pscope = PermissionScope()
        if pscope.statusLocationAlways() == .authorized{
            return true
        }else{
            return false
        }
    }
    
    //Signup
    public static func signupUser(firstName:String, lastName:String){
        UserDefaults.standard.set(firstName, forKey: PREF_USER_FIRST_NAME)
        UserDefaults.standard.set(lastName, forKey: PREF_USER_LAST_NAME)
        UserDefaults.standard.synchronize()
        print("Preferences Set")
    }
    
    public static func getUserFullName() -> String{
        if let userFirstName = UserDefaults.standard.string(forKey: PREF_USER_FIRST_NAME), let userLastName = UserDefaults.standard.string(forKey: PREF_USER_LAST_NAME){
            return "\(userFirstName) \(userLastName)"
        }
        return ""
    }
    
    
    //Preferences
    public static func clearPrefernces(){
        UserDefaults.standard.set(nil, forKey: PREF_USER_FIRST_NAME)
        UserDefaults.standard.set(nil, forKey: PREF_USER_LAST_NAME)
        UserDefaults.standard.synchronize()
    }
    
    public static func userValid() ->Bool{
        if let userFirstName = UserDefaults.standard.string(forKey: PREF_USER_FIRST_NAME){
            if valid(string: userFirstName){
                return true
            }
        }
        return false
    }
    
    public static func todayTimestamp() -> Double{
        let startOfDay = Date()
        let currentDayTimestamp = Double(startOfDay.timeIntervalSince1970)
        return currentDayTimestamp
    }
    
    public static func milli1970(date: Date) -> CLong {
        let timeStamp = CLong(NSDate().timeIntervalSince1970)
        print("Returning Timestamp: \(timeStamp)")
        return timeStamp
    }
    
    public static func timeStamp() -> Double {
        let timeStamp = CLong(NSDate().timeIntervalSince1970)
        print("Returning Timestamp: \(timeStamp)")
        return Double(timeStamp)
    }
    
    //Time Ago Function
    static func timeAgoSinceDate(date:NSDate, numericDates:Bool, short:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            if short{
                return "\(components.year!) yr"
            }else{
                return "\(components.year!) years ago"
            }
        } else if (components.year! >= 1){
            if (numericDates){
                if short{
                    return "1 yr"
                }else{
                    return "1 year ago"
                }
            } else {
                if short{
                    return "Last yr"
                }else{
                    return "Last year"
                }
            }
        } else if (components.month! >= 2) {
            if short{
                return "\(components.month!) months"
            }else{
                return "\(components.month!) months ago"
            }
        } else if (components.month! >= 1){
            if (numericDates){
                if short{
                    return "1 month"
                }else{
                    return "1 month ago"
                }
            } else {
                if short{
                    return "Last month"
                }else{
                    return "Last month"
                }
            }
        } else if (components.weekOfYear! >= 2) {
            if short{
                return "\(components.weekOfYear!)wks"
            }else{
                return "\(components.weekOfYear!) weeks ago"
            }
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                if short{
                    return "1wk"
                }else{
                    return "1 week ago"
                }
            } else {
                if short{
                    return "Last wk"
                }else{
                    return "Last week"
                }
            }
        } else if (components.day! >= 2) {
            if short{
                return "\(components.day!)d"
            }else{
                return "\(components.day!) days ago"
            }
        } else if (components.day! >= 1){
            if (numericDates){
                if short{
                    return "1d"
                }else{
                    return "1 day ago"
                }
            } else {
                if short{
                    return "Yesterday"
                }else{
                    return "Yesterday"
                }
            }
        } else if (components.hour! >= 2) {
            if short{
                return "\(components.hour!)hr"
            }else{
                return "\(components.hour!) hours ago"
            }
        } else if (components.hour! >= 1){
            if (numericDates){
                if short{
                    return "1hr"
                }else{
                    return "1 hour ago"
                }
            } else {
                if short{
                    return "An hour ago"
                }else{
                    return "An hour ago"
                }
            }
        } else if (components.minute! >= 2) {
            if short{
                return "\(components.minute!)min"
            }else{
                return "\(components.minute!) minutes ago"
            }
        } else if (components.minute! >= 1){
            if (numericDates){
                if short{
                    return "1min"
                }else{
                    return "1 minute ago"
                }
            } else {
                if short{
                    return "A minute ago"
                }else{
                    return "A minute ago"
                }
            }
        } else if (components.second! >= 3) {
            if short{
                return "\(components.second!)sec"
            }else{
                return "\(components.second!) seconds ago"
            }
        } else {
            if short{
                return "Now"
            }else{
                return "Just now"
            }
        }
        
    }
}
