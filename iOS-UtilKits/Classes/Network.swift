//
//  Network.swift
//  swag
//
//  Created by Ken on 2018/12/24.
//  Copyright © 2018年 Machipopo Corp. All rights reserved.
//

import Foundation
import SystemConfiguration
import CoreTelephony

@objcMembers
public  class Network: NSObject {
    public static let shared = Network()
    
    static let statusDidChange = Notification.Name(rawValue: "Network.statusDidChange")
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "swag.live")
    
    private var flags: SCNetworkReachabilityFlags? {
        didSet {
            if let f = flags {
                isReachable = isNetworkReachable(with: f)
                debugPrint("[Network] \(radioAccess.rawValue) isReachable:\(isReachable) isWifiOr4gConnected:\(isWifiOr4gConnected)")
            }
        }
    }
    
    public private(set) var isReachable: Bool = false {
        didSet {
            if oldValue != isReachable {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Network.statusDidChange, object: nil)
                }
            }
        }
    }
    
    private var isListening = false
    
    public func start() {
        guard !isListening, let reachability = reachability
            else { return }

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<Network>.passUnretained(self).toOpaque())
        let callback: SCNetworkReachabilityCallBack? = { (reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            guard let info = info
                else { return }
            let handler = Unmanaged<Network>.fromOpaque(info).takeUnretainedValue()
            handler.flags = flags
        }
        if !SCNetworkReachabilitySetCallback(reachability, callback, &context) {
            debugPrint("Failed to set network reachability callback")
            return
        }
        SCNetworkReachabilitySetDispatchQueue(reachability, .global(qos: .background))
        
        // Runs the first time to set the current flags
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        self.flags = flags
        
        isListening = true
    }
    
    public func stop() {
        guard isListening, let reachability = reachability
            else { return }
        isListening = false
        
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}

// MARK: - Status Info
extension Network {
    
    enum RadioAccess: String {
        case unknown, wwan2g, wwan3g, wwan4g
    }
    
    var isWifiOr4gConnected: Bool {
        return isReachable && (isWifiConnected || radioAccess == .wwan4g)
    }
    
    var isWifiConnected: Bool {
        return isReachable && flags?.contains(.isWWAN) == false
    }
    
    var radioAccess: RadioAccess {
        switch CTTelephonyNetworkInfo().currentRadioAccessTechnology {
        case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
            return .wwan2g
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return .wwan3g
        case CTRadioAccessTechnologyLTE:
            return .wwan4g
        default:
            return .unknown
        }
    }
}
