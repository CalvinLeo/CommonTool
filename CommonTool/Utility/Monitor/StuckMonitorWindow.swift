//
//  StuckMonitorVC.swift
//  QdamaECMall
//
//  Created by QDM on 2021/5/18.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

class StuckMonitorWindow: UIWindow {
    var stuckMonitorObs : NSKeyValueObservation?
    var label: UILabel?
    static let shared = StuckMonitorWindow()
    
    init() {
        super.init(frame: CGRect(x: 2, y: 50, width: 80, height: 30))
        configUI()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .red
        self.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        label = UILabel(frame: self.bounds)
        label?.textAlignment = .center
        label?.font = FontDesign.r12
        label?.textColor = .mainRedColor
        label?.text = "FPS监测"
        label?.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(pan:)))
        label?.addGestureRecognizer(panGesture)
        
        self.addSubview(label!)

        /*
         swift4.0 kvo
         */
        stuckMonitorObs = StuckMonitor.shared.observe(\StuckMonitor.FPS, options: [.new]) {(_, change) in
            DispatchQueue.main.async {
                self.label?.text = "FPS: " + String(format: "%.2f", change.newValue!)
            }
        }
    }
    
    @objc func panGestureAction(pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        switch pan.state {
        case .began:
            self.frame = UIScreen.main.bounds
        case .changed:
            self.label?.center = point
        case .ended, .cancelled:
            var originX = 2.0
            let originY = max(point.y - 15, UIApplication.shared.statusBarFrame.size.height)
            if point.x > (UIScreen.main.bounds.width) * 0.5 {
                originX = Double((UIScreen.main.bounds.width - 82.0))
            }
            self.frame = CGRect(x: CGFloat(originX), y: originY, width: 80, height: 30)
            self.label?.frame = self.bounds
            self.backgroundColor = .clear
        default:
            break
        }
    }
    /*
     addObserver()
     
     func addObserver() {
         StuckMonitor.shared.addObserver(self, forKeyPath: "FPS", options: [.new, .old], context: nil)
     }

     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                                context: UnsafeMutableRawPointer?) {
         if keyPath == "FPS" {
             DispatchQueue.main.async {
                 self.label?.text = "FPS: " + String(format: "%.2f", StuckMonitor.shared.FPS)
             }
         }
     }
     */

    
}
