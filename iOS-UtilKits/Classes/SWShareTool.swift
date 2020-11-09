//
//  SWShareTool.swift
//  swagr
//
//  Created by Kory on 2019/9/6.
//  Copyright © 2019 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class SWShareTool {
    // MARK: Public Method
    public class func share(url: URL, presentingVC: UIViewController) {
        share([url], presentingVC: presentingVC)
    }
    
    public class func share(content: String, presentingVC: UIViewController) {
        share([content], presentingVC: presentingVC)
    }
    
    public class func share(for url: URL, with content: String, presentingVC: UIViewController) {
        share([content, url], presentingVC: presentingVC)
    }
    
    public class func shareStream(for url: URL, with content: String, presentingVC: UIViewController) {
        let ac = UIActivityViewController(activityItems: [content, url], applicationActivities: nil)
        ac.setValue(content, forKey: "subject")
        presentingVC.present(ac, animated: true, completion: nil)

    }
    
    // MARK: - Private Method
    private class func share(_ items: [Any], presentingVC: UIViewController) {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        presentingVC.present(ac, animated: true, completion: nil)
    }
}
