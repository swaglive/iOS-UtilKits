//
//  DeviceCharacteristic.swift
//  swag
//
//  Created by Barry on 2017/10/19.
//  Copyright © 2017年 Machipopo Corp. All rights reserved.
//

import Foundation

@objc
public enum DeviceScreenType: Int {
        case LongerThan_16_9, Ratio_16_9, Others
}

@objcMembers
public class DeviceCharacteristic : NSObject {
    public class var safeAreaInsets : UIEdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    public class var screenType : DeviceScreenType {
        let ratioStr = String(format: "%.3f", CGFloat(9.0 / 16.0))
        let ratio = Double(ratioStr) ?? 0.0
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let screenRatioStr = String(format: "%.3f", CGFloat(screenWidth / screenHeight))
        let screenRatio = Double(screenRatioStr) ?? 0.0
        if (screenRatio < ratio) {
            return .LongerThan_16_9
        } else if (screenRatio == ratio) {
            return .Ratio_16_9
        } else {
            return .Others
        }
    }
    
    public class var isScreenLongerThen16_9 : Bool {
        return DeviceCharacteristic.screenType == .LongerThan_16_9
    }
}
