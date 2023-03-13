//
//  LSAgreementModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/8.
//

import Foundation
import HandyJSON


struct LSAgreementModel: HandyJSON, Codable{
    var agreementname = ""
    var id = 0
    var content = ""
}

struct LSVerisonModel: HandyJSON{
    var cname = ""
    var updateinfo = ""
}

