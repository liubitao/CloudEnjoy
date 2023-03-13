//
//  LSUserModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/9.
//

import Foundation
import HandyJSON

struct LSPhotoModel: HandyJSON {
    var imgid = ""
    var img = ""
    var detimg = false
    var isSelected = false
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper >>> self.isSelected
    }
    
}

