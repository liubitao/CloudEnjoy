//
//  LSHomeModel.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/24.
//

import Foundation
import HandyJSON

struct LSJSHomeModel: HandyJSON {
    var basesaleductamt = ""
    var rechargesaleductamt = ""
    var txsaleductamt = ""
    var ph = "" //今日排行
    var commissionsum = ""  //今日提成
    var sumqty = "" //我的钟数
    var addcardsaleductamt = ""
    var userid = ""
    var overtimesaleductamt = ""
}


struct LSRankModel: HandyJSON {
    var headimg = ""
    var tlname = ""
    var sumqty = ""
    var usercode = ""
    var username = ""
}
