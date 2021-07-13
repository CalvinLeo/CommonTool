//
//  UIViewController+Helpers.swift
//  QdamaECMall
//
//  Created by zx on 2021/5/7.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

/// 获取创建 VC
extension UIViewController {
    // MARK: - 找到当前显示的 viewcontroller
    class func current(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        
        if let split = base as? UISplitViewController {
            return current(base: split.presentingViewController)
        }
        return base
    }
}
