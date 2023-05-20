//
//  LSWorkOrderDetailsController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/27.
//

import UIKit
import LSBaseModules

class LSWorkOrderDetailsController: LSBaseViewController {

    @IBOutlet weak var jsLab: UILabel!
    @IBOutlet weak var roomLab: UILabel!
    @IBOutlet weak var clockTypeLab: UILabel!
    @IBOutlet weak var projectNameLab: UILabel!
    @IBOutlet weak var createNameLab: UILabel!
    @IBOutlet weak var createTimeLab: UILabel!
    @IBOutlet weak var refNameLab: UILabel!
    
    @IBOutlet weak var upClockTimeLab: UILabel!
    @IBOutlet weak var upClockNameLab: UILabel!
    @IBOutlet weak var downClockTimeLab: UILabel!
    @IBOutlet weak var downClockNameLab: UILabel!
    
    @IBOutlet weak var orderNoLab: UILabel!
    @IBOutlet weak var unitPriceLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var discountPriceLab: UILabel!
    @IBOutlet weak var cashierNameLab: UILabel!
    @IBOutlet weak var cashierTimeLab: UILabel!
    
    @IBOutlet weak var projectRoyaltyLab: UILabel!
    
    var orderModel: LSOrderDetailsModel?
    var billid: String!
    convenience init(billid: String) {
        self.init()
        self.billid = billid
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工单详情"
    }
    
    override func setupData() {
        Toast.showHUD()
        LSWorkbenchServer.projectDetails(billid: self.billid).subscribe { orderDetailsModel in
            self.orderModel = orderDetailsModel
            self.refreshUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        guard let orderModel = orderModel else {
            return
        }
        jsLab.text = orderModel.tname
        roomLab.text = orderModel.roomname + (parametersModel().OperationMode == 0 ? "(床位：\(orderModel.bedname))" : "(手牌：\(orderModel.handcardno))")
        clockTypeLab.text = orderModel.ctype.clockString
        projectNameLab.text = orderModel.projectname
        createNameLab.text = orderModel.createname
        createTimeLab.text = orderModel.createtime
        refNameLab.text = orderModel.refname
        
        upClockTimeLab.text = orderModel.starttime
        upClockNameLab.text = orderModel.startname
        downClockTimeLab.text = orderModel.endtime
        downClockNameLab.text = orderModel.endname
        
        orderNoLab.text = orderModel.billno
        unitPriceLab.text = "￥" + orderModel.price.stringValue(retain: 2) + "/" + (orderModel.qty.int?.string ?? "1")
        priceLab.text = "￥" + orderModel.amt.stringValue(retain: 2)
        discountPriceLab.text = "￥" + (orderModel.yprice - orderModel.amt).stringValue(retain: 2)
        cashierNameLab.text = orderModel.cashname
        cashierTimeLab.text = orderModel.billdate
        
        projectRoyaltyLab.text = "￥" + orderModel.commission.stringValue(retain: 2)
    }

}
