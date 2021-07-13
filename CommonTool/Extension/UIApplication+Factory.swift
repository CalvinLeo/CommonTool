//
//  UIWindow+Helpers.swift
//  QdamaECMall
//
//  Created by zx on 2021/5/7.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

/// 获取、创建 app 的对象
extension UIApplication {
    /// 获取当前窗口
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .filter({ $0.isKeyWindow }).first {
                return window
            } else if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        }
    }
    
    // 主窗口
    class func getMainWindow() -> UIWindow? {
        if let window = UIApplication.shared.delegate?.window {
            return window
        }
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first {
                if let mainWindow = windowScene.value(forKey: "delegate.window") as? UIWindow {
                    return mainWindow
                }
                return UIApplication.shared.windows.last
            }
        }
        return UIApplication.shared.keyWindow
    }
}
