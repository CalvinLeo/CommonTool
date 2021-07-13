//
//  StuckMonitor.swift
//  卡顿监测
//
//  Created by QDM on 2021/5/18.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

class WeakProxy: NSObject {
    weak var target: NSObjectProtocol?
    init(target: NSObjectProtocol) {
        self.target = target
        super.init()
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return (target?.responds(to: aSelector) ?? false) || super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
}

class StuckMonitor: NSObject {
    
    let queueKey = "com.qdama.com.stuck.monitor.queue"
    
    var lastTime: TimeInterval = 0
    var monitorQueue: DispatchQueue?
    var displayLink: CADisplayLink?
    @objc dynamic var FPS: Double = 0
    // 记录方法执行次数
    var count: Int = 0
    
    static var shared = StuckMonitor()
    
    override init() {
        monitorQueue = DispatchQueue(label: queueKey)
        super.init()
    }
    
    // 开启监听
    func startMonitor() {
        displayLink = CADisplayLink(target: WeakProxy(target: self), selector: #selector(monitorAction(link:)))
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    // 停止
    func endMonitor() {
        self.displayLink?.invalidate()
    }
    
    // 监测事件
    @objc func monitorAction(link: CADisplayLink) {
        guard lastTime != 0 else {
            lastTime = link.timestamp
            return
        }
        count += 1
        let timePassed = link.timestamp - lastTime
        
        guard timePassed >= 1 else {
            return
        }
        lastTime = link.timestamp
        FPS = Double(count) / timePassed
        count = 0
//        DLog("FPS ===== \(round(FPS))")
    }
}
