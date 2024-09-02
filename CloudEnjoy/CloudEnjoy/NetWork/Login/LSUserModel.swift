//
//  LSUserModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/9.
//

import Foundation
import SmartCodable

struct LSLoginAccountModel: SmartCodable {
    var account: String?
    var mobile: String?
    var code: String?
}

struct LSPhotoModel: SmartCodable {
    var imgid = ""
    var img = ""
    var detimg = false
    var isSelected = false
    
    enum CodingKeys: CodingKey {
        case imgid
        case img
        case detimg
    }
}

