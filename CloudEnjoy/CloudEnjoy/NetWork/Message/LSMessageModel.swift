//
//  LSMessageModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/24.
//

import Foundation
import SmartCodable


enum LSMsgType: String, CaseIterable, SmartCaseDefaultable {
    case all = ""
    case yuyue = "1"
    case wait = "2"
    case paigong = "3"
    case other = "4"
}

struct LSMessageModel: SmartCodable {
    var createtime = ""
    var title = ""
    var content = ""
    var msgid = ""
    var msgtype = ""
    var status = ""
    var msgType = LSMsgType.all
    var see = ""
    
    var isSelected = false
}
