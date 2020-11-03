//
//  Predicates.swift
//  swag
//
//  Created by Mike Yu on 19/09/2017.
//  Copyright © 2017 Machipopo Corp. All rights reserved.
//

import Foundation

struct AppPredicates {
    static let email: NSPredicate = {
        let regex = "^(([^<>()\\[\\]\\\\.,;:\\s@\"]+(\\.[^<>()\\[\\]\\\\.,;:\\s@\"]+)*)|(\".+\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$"
        return NSPredicate(format: "SELF MATCHES %@", regex)
    }()
}
