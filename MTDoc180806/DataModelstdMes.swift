//
//  DataModel.swift
//  MTDoc180806
//
//  Created by 唐子轩 on 2018/8/7.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class Messages: Codable {
    
    let messages: [DataModelstdMes]
    
    init(messages: [DataModelstdMes]) {
        self.messages = messages
    }
}


class DataModelstdMes: Codable {

    let num: String
    let from: String
    let to: String
    let type: String
    let time: String
    let content: String
    
    init(num: String, from: String, to: String, type: String, time: String, content: String) {
        self.num = num
        self.from = from
        self.to = to
        self.type = type
        self.time = time
        self.content = content
        
    }
    
}
