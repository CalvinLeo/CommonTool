//
//  UIButton+ImagePosition.swift
//  
//
//  Created by zx on 2021/5/26.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

/// 按钮图片位置
enum ButtonImagePosition {
    case left
    case top
    case right
    case bottom
}

/// 设置按钮图片的位置
extension UIButton {
    private struct AssociatedKey {
        static var positionKey: String = "positionKey"
        static var spaceKey: String = "spaceKey"
    }
    /// 图片位置
    var imagePosition: ButtonImagePosition? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.positionKey) as? ButtonImagePosition
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.positionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 图片和文字间距
    var space: Float? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.spaceKey) as? Float
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.spaceKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 设置按钮图片的位置及其间距
    /// - Parameters:
    ///   - imagePosition: 图片位置
    ///   - space: 图片和文字间距
    func setImageWithPosition(imagePosition: ButtonImagePosition, space: Float = 5.0) {
        self.imagePosition =  imagePosition
        self.space = space
        
        setTitle(currentTitle, for: .normal)
        setImage(currentImage, for: .normal)
        
        let imageHeight: CGFloat = imageView?.image?.size.height ?? 0.0
        let imageWidth: CGFloat = imageView?.image?.size.width ?? 0.0
        
        let title: NSString = titleLabel?.text as NSString? ?? ""
        let font: UIFont = titleLabel?.font ?? UIFont.systemFont(ofSize: 14.0)
        let attribute = [NSAttributedString.Key.font: font]
        let labelWidth: CGFloat = title.size(withAttributes: attribute).width
        let labelHeight: CGFloat = title.size(withAttributes: attribute).height
        
        let spacing: CGFloat = CGFloat(self.space ?? 5.0)
        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2
        let imageOffsetY = imageHeight / 2 + spacing / 2
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2
        let labelOffsetY = labelHeight / 2 + spacing / 2
        
        let tempWidth = max(labelWidth, imageWidth)
        let changedWidth = labelWidth + imageWidth - tempWidth
        let tempHeight = max(labelHeight, imageHeight)
        let changedHeight = labelHeight + imageHeight + spacing - tempHeight
        
        switch (imagePosition) {
        case .left: setLeft()
        case .right: setRight(labelWidth: labelWidth, imageWidth: imageWidth)
        case .top:
            setTop(imageOffsetX: imageOffsetX,
                   imageOffsetY: imageOffsetY,
                   labelOffsetX: labelOffsetX,
                   labelOffsetY: labelOffsetY,
                   changedWidth: changedWidth,
                   changedHeight: changedHeight)
        case .bottom:
            setBottom(imageOffsetX: imageOffsetX,
                      imageOffsetY: imageOffsetY,
                      labelOffsetX: labelOffsetX,
                      labelOffsetY: labelOffsetY,
                      changedHeight: changedHeight,
                      changedWidth: changedWidth)
        }
    }
    
    private func setLeft() {
        let spacing: CGFloat = CGFloat(self.space ?? 5.0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 2)
    }
    
    private func setRight(labelWidth: CGFloat, imageWidth: CGFloat) {
        let spacing: CGFloat = CGFloat(self.space ?? 5.0)
        imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: labelWidth + spacing / 2,
                                       bottom: 0,
                                       right: -(labelWidth + spacing / 2))
        titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -(imageWidth + spacing / 2),
                                       bottom: 0,
                                       right: imageWidth + spacing / 2)
        contentEdgeInsets = UIEdgeInsets(top: 0,
                                         left: spacing / 2,
                                         bottom: 0,
                                         right: spacing / 2)
    }
    
    private func setTop(imageOffsetX: CGFloat,
                        imageOffsetY: CGFloat,
                        labelOffsetX: CGFloat,
                        labelOffsetY: CGFloat,
                        changedWidth: CGFloat,
                        changedHeight: CGFloat) {
        imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY,
                                       left: imageOffsetX,
                                       bottom: imageOffsetY,
                                       right: -imageOffsetX)
        titleEdgeInsets = UIEdgeInsets(top: labelOffsetY,
                                       left: -labelOffsetX,
                                       bottom: -labelOffsetY,
                                       right: labelOffsetX)
        contentEdgeInsets = UIEdgeInsets(top: imageOffsetY,
                                         left: -changedWidth / 2,
                                         bottom: changedHeight - imageOffsetY,
                                         right: -changedWidth / 2)
    }
    
    private func setBottom(imageOffsetX: CGFloat,
                           imageOffsetY: CGFloat,
                           labelOffsetX: CGFloat,
                           labelOffsetY: CGFloat,
                           changedHeight: CGFloat,
                           changedWidth: CGFloat) {
        imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX,
                                       bottom: -imageOffsetY, right: -imageOffsetX)
        titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX,
                                       bottom: labelOffsetY, right: labelOffsetX)
        contentEdgeInsets = UIEdgeInsets(top: changedHeight - imageOffsetY,
                                         left: -changedWidth / 2,
                                         bottom: imageOffsetY,
                                         right: -changedWidth / 2)
    }
    
    /// 刷新控件
    func relayoutIfNeed() {
        setImageWithPosition(imagePosition: self.imagePosition ?? .left, space: self.space ?? 5.0)
    }
}
