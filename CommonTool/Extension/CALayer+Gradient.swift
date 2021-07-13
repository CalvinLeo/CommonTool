//
//  CALayer+Gradient.swift
//  渐变色Layer
//
//  Created by zx on 2021/7/5.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    /// 渐变色图层
    static func gradientWithRect(rect: CGRect, fromColor: UIColor, toColor: UIColor) -> CALayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.locations = [0.25, 0.5, 0.75, 1]
        gradientLayer.frame = rect
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return gradientLayer
    }
}
