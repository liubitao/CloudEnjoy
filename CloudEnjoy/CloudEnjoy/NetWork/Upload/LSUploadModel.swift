//
//  LSUploadModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/10.
//

import Foundation
import SmartCodable

struct LSUploadPhotoModel: SmartCodable {
    var msg = ""
    var code = 0
    var imgurl = ""
    var imgid = ""
}


struct LSUploadFileModel: SmartCodable {
    var msg = ""
    var imgurl = ""
}

