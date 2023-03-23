//
//  LSOrderDetailsViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/22.
//

import UIKit
import SwifterSwift

class LSOrderDetailsViewController: LSBaseViewController {

    @IBOutlet weak var stateLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var customerTypeLab: UILabel!
    @IBOutlet weak var mobileLab: UILabel!
    @IBOutlet weak var arriveTimeLab: UILabel!
    @IBOutlet weak var createTimeLab: UILabel!
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var projectNameLab: UILabel!
    @IBOutlet weak var jsLab: UILabel!
    @IBOutlet weak var renameLab: UILabel!
    @IBOutlet weak var createNameLab: UILabel!
    @IBOutlet weak var remarkLab: UILabel!

    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var orderModel: LSOrderModel!
    
    convenience init(orderModel: LSOrderModel) {
        self.init()
        self.orderModel = orderModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "预约详情"
    }
    
    override func setupViews() {
        self.nameLab.text = orderModel.name
        self.stateLab.text = orderModel.statusname
        self.customerTypeLab.text = orderModel.custtype.cutomerString
        self.mobileLab.text = orderModel.mobile
        self.arriveTimeLab.text = orderModel.tostoretime
        self.createTimeLab.text = orderModel.createname
        self.roomNameLab.text = orderModel.roomname
        self.projectNameLab.text = orderModel.projectname
        self.jsLab.text = orderModel.tname
        self.renameLab.text = orderModel.refname
        self.createNameLab.text = orderModel.createname
        self.remarkLab.text = orderModel.remark
        
        self.cancelBtn.isHidden = orderModel.status != .waitYuyue
        self.confirmBtn.isHidden = orderModel.status != .waitYuyue
    }

    @IBAction func cancelBtn(_ sender: Any) {
        let alertVC = UIAlertController.init(title: "取消预约提示", message: "确认要取消当前预约？", defaultActionButtonTitle: "放弃", tintColor: Color(hexString: "#2BB8C2"))
        alertVC.addAction(title: "确认", style: .destructive, isEnabled: true) { _ in
            Toast.showHUD()
            LSWorkbenchServer.cancelYuyue(billid: self.orderModel.billid).subscribe { model in
                Toast.show("该预约已取消")
            } onFailure: { error in
                Toast.show(error.localizedDescription)
            } onDisposed: {
                Toast.hiddenHUD()
            }.disposed(by: self.rx.disposeBag)
        }
        alertVC.show()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let editOrderVC = LSAddOrderViewController(orderModel: self.orderModel)
        self.navigationController?.pushViewController(editOrderVC, animated: true)
    }
}
