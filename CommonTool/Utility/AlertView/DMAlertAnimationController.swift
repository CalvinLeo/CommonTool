//
//  DMAlertAnimationController.swift
//  警告提示框动画
//
//  Created by zx on 2021/7/6.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 自定义转场类
class DMAlertAnimationController : NSObject {
    enum DMAlertAnimationStyle {
        case presenting
        case dismissing
    }
    
    var animationType: DMAlertAnimationStyle = .presenting
    
    convenience init(type: DMAlertAnimationStyle) {
        self.init()
        self.animationType = type
    }
}

// MARK: - 动画类
extension DMAlertAnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let animatDuration = self.animationType == .presenting ? 0.5 : 1
        return animatDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if self.animationType == .presenting {
            if let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? DMAlertController {
                containerView.addSubview(toVC.view)
                let alertView = toVC.alertView
                // 警告框
                if toVC.alertStyle == .tips {
                    toVC.view.backgroundColor = UIColor.black.withAlphaComponent(0)
                    toVC.view.layoutIfNeeded()
                    alertView.snp.updateConstraints { (make) in
                        make.centerY.equalTo(toVC.view.snp.centerY)
                    }
                    
                    UIView.animate(withDuration: 0.3,
                                   delay: 0.1,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 0,
                                   options: .curveEaseIn) {
                        toVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                        toVC.view.layoutIfNeeded()
                    } completion: { (finished) in
                        transitionContext.completeTransition(true)
                    }
                } else if toVC.alertStyle == .active { //
                    toVC.view.alpha = 0
                    alertView.layoutIfNeeded()
                    alertView.alpha = 0.3
                    let size = alertView.frame.size
                    
                    alertView.snp.updateConstraints { make in
                        make.width.equalTo(size.width - 50)
                        make.height.equalTo(size.height - 50)
                    }
                    alertView.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.7,
                                   delay: 0.1,
                                   usingSpringWithDamping: 0.4,
                                   initialSpringVelocity: 0,
                                   options: [.curveLinear]) {
                        toVC.view.alpha = 1
                        alertView.alpha = 1
                        alertView.snp.updateConstraints { make in
                            make.size.equalTo(size)
                        }
                        alertView.layoutIfNeeded()
                        
                    } completion: { (finished) in
                        transitionContext.completeTransition(true)
                    }
                } else {
                    toVC.view.alpha = 0
                    UIView.animate(withDuration: 0.3,
                                   delay: 0.1,
                                   usingSpringWithDamping: 1.0,
                                   initialSpringVelocity: 1,
                                   options: [.beginFromCurrentState, .allowUserInteraction]) {
                        toVC.view.alpha = 1
                    } completion: { (finished) in
                        transitionContext.completeTransition(true)
                    }
                }
            }
        } else if (self.animationType == .dismissing) {
            if let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? DMAlertController {
                
                if fromVC.alertStyle == .tips {
                    let alertView = fromVC.alertView
                    let closeButton = fromVC.closeButton
                    let frame = alertView.frame
                    let btnFrame = closeButton.frame
                    
                    UIView.animate(withDuration: 0.3,
                                   delay: 0.1,
                                   usingSpringWithDamping: 1.0,
                                   initialSpringVelocity: 0,
                                   options: .curveEaseIn) {
                        alertView.frame = CGRect(x: frame.origin.x, y: -(SystemDesign.screenWidth + frame.size.height) / 2,
                                                 width: frame.size.width, height: frame.size.height)
                        closeButton.frame = CGRect(x: btnFrame.origin.x, y: alertView.frame.maxY,
                                                   width: btnFrame.size.width, height: btnFrame.size.height)
                    } completion: { (finished) in
                        transitionContext.completeTransition(true)
                    }
                } else {
                    UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.beginFromCurrentState, .allowUserInteraction]) {
                        fromVC.view.alpha = 0
                    } completion: { (finish) in
                        transitionContext.completeTransition(true)
                    }
                }
            }
        }
    }
}


