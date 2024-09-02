//
//  LSAgreementModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/8.
//

import Foundation
import SmartCodable


struct LSAgreementModel: SmartCodable, Codable{
    var agreementname = ""
    var id = 0
    var content = ""
}

struct LSVerisonModel: SmartCodable{
    var cname = ""
    var updateinfo = ""
}

