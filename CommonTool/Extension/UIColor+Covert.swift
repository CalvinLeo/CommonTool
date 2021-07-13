//
//  UIColor+Covert.swift
//  QdamaECMall
//
//  Created by zx on 2021/4/26.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

/// 颜色置换
extension UIColor {
    /// 将十六进制的颜色值转换为UIColor
    ///
    /// - Parameters:
    ///   - hexColor: 要转化的十六进制颜色值，格式为0xFF0000
    ///   - alpha: 颜色的透明度
    /// - Returns: 转换后的颜色值
    class func color(hexColor: NSInteger, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
                            green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
                            blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,
                            alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0,
                  green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0,
                  blue: ((CGFloat)(hex & 0xFF)) / 255.0,
                  alpha: 1.0)
    }
    
    /// 将颜色字符串转换为颜色，hexString 格式为 #FFFFFF
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
             
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
            
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
            
        let mask = 0x000000FF
        let redValue = Int(color >> 16) & mask
        let greenValue = Int(color >> 8) & mask
        let blueValue = Int(color) & mask
             
        let red   = CGFloat(redValue) / 255.0
        let green = CGFloat(greenValue) / 255.0
        let blue  = CGFloat(blueValue) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 将颜色转为字符串
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
            
        let multiplier = CGFloat(255.999999)
             
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
            
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
