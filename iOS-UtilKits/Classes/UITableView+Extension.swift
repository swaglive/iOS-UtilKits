//
//  UITableView+Extension.swift
//  swag
//
//  Created by Hokila Jan on 2019/1/16.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

extension UITableView{
    public func registerNib<T:UITableViewCell>(cellType:T.Type, bundle: Bundle? = nil) {
        let identifier = T.reuseIdentifier
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerNib<T:UITableViewCell>(cellTypes:[T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach{registerNib(cellType: $0, bundle: bundle) }
    }
    
    public func registerClass<T:UITableViewCell>(cellType:T.Type, bundle: Bundle? = nil) {
        let identifier = T.reuseIdentifier
        register(T.self, forCellReuseIdentifier: identifier)
    }
    
    public func registerClass<T:UITableViewCell>(cellTypes:[T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach{registerClass(cellType: $0, bundle: bundle) }
    }
    
    public func dequeueReusableCell<T:UITableViewCell>(with type:T.Type, for indexPath:IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
