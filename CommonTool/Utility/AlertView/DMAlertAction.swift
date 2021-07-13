//
//  DMAlertAction.swift
//  QdamaECMall
//
//  Created by QDM on 2021/6/1.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

struct DMAlertAction {
    
    enum DMAlertActionStyle {
        case mainDefault
        case cancel
    }
    
    typealias Handler = (() -> Void)
    
    var title: String!                                  // 标题
    var titleColor: UIColor!                            // 颜色
    var bgColor: UIColor!                               // 背景色
    var actionStyle: DMAlertActionStyle! = .mainDefault // 样式
    var handler: Handler?                               // handler 闭包
    var dismiss: Bool? = true                           // 是否自动关闭
    
    init(title: String,
         titleColor: UIColor? = .mainRedColor,
         bgColor: UIColor? = .white,
         actionStyle: DMAlertActionStyle = .mainDefault,
         handler: Handler?) {
        self.title = title
        self.titleColor = titleColor
        self.bgColor = bgColor
        self.actionStyle = actionStyle
        self.handler = handler
    }
}
