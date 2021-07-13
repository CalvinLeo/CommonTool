//
//  Dictionary+TypeConvert.swift
//  QdamaECMall
//
//  Created by zx on 2021/6/12.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation

/// 类型转化
extension Dictionary {
    /// 转化为字符串
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
     }
    
    /// 转化为 Data
    func toData() -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        return data
    }

}
