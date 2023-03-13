//
//  LSWorkbenchModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/11.
//

import Foundation
import HandyJSON

struct LSRoyaltiesTotalModel: HandyJSON {
    var commissionsum = ""
    var list: [LSRoyaltiesItemModel] = []
    
}
struct LSRoyaltiesItemModel: HandyJSON {
    var name = ""
    var count = ""
    var commission = ""
    var selecttype = 0
}


struct LSRoyaltiesDetailsModel: HandyJSON {
    var id = ""
    var projectname = ""
    var amt = ""
    var ctypename = ""
    var commission = ""
    var roomname = ""
    var createtime = ""
}
