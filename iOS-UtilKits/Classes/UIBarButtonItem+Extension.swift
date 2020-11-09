//
//  UIBarButtonItem+Extension.swift
//  swagr
//
//  Created by Kory on 2019/11/4.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
    
    /// Typealias for UIBarButtonItem closure.
    private typealias UIBarButtonItemTargetClosure = (UIBarButtonItem) -> ()

    private class UIBarButtonItemClosureWrapper: NSObject {
        let closure: UIBarButtonItemTargetClosure
        init(_ closure: @escaping UIBarButtonItemTargetClosure) {
            self.closure = closure
        }
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIBarButtonItemTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIBarButtonItemClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIBarButtonItemClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc public class func back() -> UIBarButtonItem {
        return UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    @objc
    public convenience init(
        image: UIImage,
        style: UIBarButtonItem.Style,
        closure: @escaping (UIBarButtonItem) -> ()) {
        self.init(image: image, style: style, target: nil, action: nil)
        targetClosure = closure
        action = #selector(UIBarButtonItem.closureAction)
    }
    
    @objc public func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}
