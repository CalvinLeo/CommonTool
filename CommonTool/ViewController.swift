//
//  ViewController.swift
//  工具类
//
//  Created by zx on 2021/7/13.
//
    
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let auth = ZXAuthView()
        self.view.addSubview(auth)
        auth.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.height.equalTo(authCodeViewHeight)
            make.top.equalTo(100)
        }
        
        auth.layoutIfNeeded()
        auth.codeNumbers = 4
        auth.becomeFirstRegister()
    }
}




