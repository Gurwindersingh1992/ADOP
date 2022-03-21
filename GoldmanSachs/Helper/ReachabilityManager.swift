//
//  ReachabilityManager.swift
//  GoldmanSachs
//
//  Created by Gurwinder singh on 19/03/22.
//

import UIKit

class ReachabilityManager: NSObject {
    
    var internetConnectionReach : Reachability?
    
    static let sharedReachability = ReachabilityManager()
    
    func hasInternetConnection() ->Bool {
        
        return isInternetActive
    }
    
    func checkInternetConnection() {
        
        internetConnectionReach = Reachability.reachabilityForInternetConnection()
        
        var netStatus: Reachability.NetworkStatus!
        
        netStatus = internetConnectionReach?.currentReachabilityStatus
        
        if(netStatus == Reachability.NetworkStatus.notReachable) {
            isInternetActive = false
        }
        else {
            isInternetActive = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object: nil)
        
        _ = internetConnectionReach?.startNotifier()
    }
    
    @objc func reachabilityChanged(_ notifincation: Notification) {
        
        if(internetConnectionReach?.isReachable())!
        {
            isInternetActive = true
        }
        else
        {
            isInternetActive = false
        }
    }
}

