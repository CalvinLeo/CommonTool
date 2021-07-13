//
//  String+Wrapper.swift
//  QdamaECMall
//
//  Created by zx on 2021/7/7.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation

/// 去除首尾空格
@propertyWrapper struct TirmmingWhitespace {
    var value: String
    
    var wrappedValue: String {
        get { value }
        set {
            let whitespace = NSCharacterSet.whitespacesAndNewlines
            value = newValue.trimmingCharacters(in: whitespace)
        }
    }
    
    init(_ initialValue: String = "") {
        value = initialValue
    }
}
