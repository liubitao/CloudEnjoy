//
//  LSRejectProjectViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/12.
//

import UIKit
import LSBaseModules
import SwifterSwift

class LSRejectProjectViewController: LSBaseViewController {

    @IBOutlet weak var roomNameLab: UILabel!
    
    @IBOutlet weak var bedNameLab: UILabel!
    
    
    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var jsNameLab: UILabel!
    
    @IBOutlet weak var clockTypeLab: UILabel!
    
    @IBOutlet weak var serviceStatusLab: UILabel!
    
    
    @IBOutlet weak var upClockTimeLab: UILabel!
    
    @IBOutlet weak var clockDurationLab: UILabel!
    
    
    @IBOutlet weak var rejectMarkTextField: UITextField!
    
    
    @IBOutlet weak var upClockView: UIView!
    @IBOutlet weak var clockDurationView: UIView!
    @IBOutlet weak var remarkView: UIView!
    
    var projectModel: LSHomeProjectModel!
    
    convenience init(with projectModel: LSHomeProjectModel) {
        self.init()
        self.projectModel = projectModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupViews() {
        self.roomNameLab.text = projectModel.roomname
        self.bedNameLab.text = projectModel.bedname
        self.projectNameLab.text = projectModel.projectname
        self.jsNameLab.text = userModel().name
        self.clockTypeLab.text = projectModel.ctype.clockString
        self.serviceStatusLab.text = projectModel.status.statusString
        self.upClockView.isHidden = projectModel.status != .servicing
        self.clockDurationView.isHidden = projectModel.status != .servicing
        if projectModel.status == .servicing {
        self.upClockTimeLab.text = projectModel.starttime
        self.clockDurationLab.text = Date().minutesSince(projectModel.starttime.date(withFormat: "yyyy-MM-dd hh:mm:ss") ?? Date()) + "分钟"
        }
    }

    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let remark = self.rejectMarkTextField.text,
              remark.isEmpty == false else {
            Toast.show("请输入您退钟的备注")
            return
        }
        Toast.showHUD()
        LSHomeServer.returnClock(billid: self.projectModel.billid, remark: remark).subscribe { _ in
            self.navigationController?.popToRootViewController(animated: true)
            Toast.show("已退单成功")
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
}
