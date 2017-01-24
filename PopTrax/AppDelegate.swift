//
//  AppDelegate.swift
//  PopTrax
//
//  Created by Tung Ly on 5/20/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit

var reachability: Reachability?
var reachabilityStatus = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var internetCheck: Reachability?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
        //How to add an observer & where to execute when there changes
        // [ : ] because we passed in a parameter [notification] to reachabilityChanged
        
        internetCheck = Reachability.reachabilityForInternetConnection()
        internetCheck?.startNotifier() //look around for any changes to internet
        
        //check what the status is when we first login to the app
        //green problem where wifi off but screen is green
        //so we need this to update reachability status
        statusChangedWithReachability(internetCheck!)
        
        return true
    }
    
    func reachabilityChanged(notification: NSNotification) {
        reachability = notification.object as? Reachability
        statusChangedWithReachability(reachability!)
    }
    
    func statusChangedWithReachability(currentReachabilityStatus: Reachability) {
        let networkStatus: NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
        
        switch networkStatus.rawValue {
        case NotReachable.rawValue : reachabilityStatus = NOACCESS
        case ReachableViaWiFi.rawValue : reachabilityStatus = WIFI
        case ReachableViaWWAN.rawValue : reachabilityStatus = WWAN
        default:return
        }
        NSNotificationCenter.defaultCenter().postNotificationName("ReachStatusChanged", object: nil)    //ReachStatusChanged triggers action
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
    }


}

