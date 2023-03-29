//
//  LSLeaveDetailsViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/28.
//

import UIKit
import SwifterSwift

class LSLeaveDetailsViewController: LSBaseViewController {

    
    @IBOutlet weak var leaveStatusLab: UILabel!
    @IBOutlet weak var leaveTypeLab: UILabel!
    @IBOutlet weak var startTimeLab: UILabel!
    @IBOutlet weak var endTimeLab: UILabel!
    @IBOutlet weak var applyDurationLab: UILabel!
    @IBOutlet weak var leaveReasonLab: UILabel!
    @IBOutlet weak var applyTimeLab: UILabel!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelTimeLab: UILabel!
    @IBOutlet weak var opearNameLab: UILabel!
    @IBOutlet weak var cancelReasonLab: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    var leaveModel: LSLeaveModel!
    convenience init(leaveModel: LSLeaveModel) {
        self.init()
        self.leaveModel = leaveModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "请假详情"
    }
    
    override func setupViews() {
        self.leaveStatusLab.text = leaveModel.statusname
        self.leaveStatusLab.textColor = leaveModel.status == "0" ? Color(hexString: "#FF0000") : Color(hexString: "#FFA200")
        self.leaveTypeLab.text = leaveModel.leavetypename
        self.startTimeLab.text = leaveModel.starttime
        self.endTimeLab.text = leaveModel.endtime
        self.applyDurationLab.text = leaveModel.hours + "小时"
        self.leaveReasonLab.text = leaveModel.remark
        self.applyTimeLab.text = leaveModel.createtime
        
        self.cancelView.isHidden = leaveModel.status != "0"
        self.cancelBtn.isHidden =  !(leaveModel.cstatus == "4" || leaveModel.cstatus == "2")
        if leaveModel.status == "0" {
            self.cancelTimeLab.text = leaveModel.canceltime
            self.opearNameLab.text = leaveModel.updatename
            self.cancelReasonLab.text = leaveModel.cencelremark
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        LSCancelLeaveViewController.creaeFromStoryboard(with: self.leaveModel.billid).presentedWith(self)
    }
}
