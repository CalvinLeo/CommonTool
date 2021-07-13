//
//  FontStyle.swift
//  
//
//  Created by zx on 2021/4/26.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

/// UI 字体设计规范
struct FontDesign {
    // MARK: - 主字样，苹方-简
    /// 重体
    private static let fontBoldName = "PingFangSC-Bold"
    /// 粗体
    private static let fontMediumName = "PingFangSC-Medium"
    /// 常规
    private static let fontRegularName = "PingFangSC-Regular"
    /// 细体
    private static let fontLightName = "PingFangSC-Light"
    
    // MARK: - 通用字体
    /// 24 号粗体
    static let m24 = mediumFont(size: CGFloat(24.0)~)
    /// 24 号常规
    static let r24 = regularFont(size: CGFloat(24.0)~)
    /// 24 号细体
    static let l24 = lightFont(size: CGFloat(24.0)~)
    
    /// 22 号粗体
    static let m22 = mediumFont(size: CGFloat(22.0)~)
    /// 22 号常规
    static let r22 = regularFont(size: CGFloat(22.0)~)
    /// 22 号细体
    static let l22 = lightFont(size: CGFloat(22.0)~)
    
    /// 18 号粗体
    static let m18 = mediumFont(size: CGFloat(18.0)~)
    /// 18 号常规
    static let r18 = regularFont(size: CGFloat(18.0)~)
    /// 18 号细体
    static let l18 = lightFont(size: CGFloat(18.0)~)
    
    /// 17 号粗体
    static let m17 = mediumFont(size: CGFloat(17.0)~)
    
    /// 16 号粗体
    static let m16 = mediumFont(size: CGFloat(16.0)~)
    /// 16 号常规
    static let r16 = regularFont(size: CGFloat(16.0)~)
    /// 16 号细体
    static let l16 = lightFont(size: CGFloat(16.0)~)
    
    /// 14 号粗体
    static let m14 = mediumFont(size: CGFloat(14.0)~)
    /// 14 号常规
    static let r14 = regularFont(size: CGFloat(14.0)~)
    /// 14 号细体
    static let l14 = lightFont(size: CGFloat(14.0)~)
    
    /// 12 号粗体
    static let m12 = mediumFont(size: CGFloat(12.0)~)
    /// 12 号常规
    static let r12 = regularFont(size: CGFloat(12.0)~)
    /// 12 号细体
    static let l12 = lightFont(size: CGFloat(12.0)~)
    
    // MARK: - public func
    /**
     备用
     */
//    static func boldFont(size: CGFloat) -> UIFont {
//        return UIFont(name: fontBoldName, size: size) ?? UIFont.boldSystemFont(ofSize: size)
//    }
    
    static func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontMediumName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontRegularName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func lightFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontLightName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
