//
//  LSAddOrderViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import RxGesture
import RxSwift
import SwifterSwift
import LSBaseModules
import HandyJSON
import LSNetwork

class LSAddOrderViewController: LSBaseViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var customerTypeView: UIView!
    @IBOutlet weak var customerTypeTextField: UITextField!
    
    @IBOutlet weak var mobildTextField: UITextField!
    
    @IBOutlet weak var arriveTimeView: UIView!
    @IBOutlet weak var arriveTimeTextField: UITextField!
    
    @IBOutlet weak var reserveTimeView: UIView!
    @IBOutlet weak var reserveTimeTextField: UITextField!
    
    @IBOutlet weak var customerNumLab: UILabel!
    
    @IBOutlet weak var referrerView: UIView!
    @IBOutlet weak var referrerLab: UILabel!
    
    @IBOutlet weak var remarkTextField: UITextField!
    
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var roomLab: UITextField!
    
    @IBOutlet weak var projectView: UIView!
    @IBOutlet weak var projectLab: UITextField!
    
    @IBOutlet weak var jsView: UIView!
    @IBOutlet weak var jsPlaceholderLab: UILabel!
    
    
    @IBOutlet weak var jsLab1: UILabel!
    @IBOutlet weak var jsLab2: UILabel!
    @IBOutlet weak var jsLab3: UILabel!
    @IBOutlet weak var jsLabView1: UIView!
    @IBOutlet weak var jsLabView2: UIView!
    @IBOutlet weak var jsLabView3: UIView!

    
    var customerType: LSCustomerType = .common
    var arriveDate: Date = Date().adding(.hour, value: 1)
    var timeType: LSReserveTimeType = .fifteen
    var referrerModel = LSSysUserModel(userid: userModel().userid, name: userModel().name)
    var selectRoomModel: LSOrderRoomModel?
    var selectProjectModel: LSOrderProjectModel?
    var selectJSModel: LSSysUserModel?
    var clockSelectModel: LSClockType?
    var levelSelectModel: LSJSLevelModel?
    var sexSelectModel: (String, String)?
    
    var orderModel: LSOrderModel?
    convenience init(orderModel: LSOrderModel) {
        self.init()
        self.orderModel = orderModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "新增预约"
    }
    
    override func setupViews() {
        if let orderModel = self.orderModel {
            self.orderModel = orderModel
            self.nameTextField.text = orderModel.name
            self.customerType = orderModel.custtype
            self.customerTypeTextField.text = orderModel.custtype.cutomerString
            self.mobildTextField.text = orderModel.mobile
            self.arriveTimeTextField.text = orderModel.tostoretime
            self.arriveDate = orderModel.tostoretime.date(withFormat: "yyyy-MM-dd HH:mm") ?? Date()
            self.timeType = orderModel.reservemin
            self.reserveTimeTextField.text = orderModel.reservemin.timeString
            self.customerNumLab.text = orderModel.qty
            self.referrerLab.text = orderModel.refname
            self.referrerModel = LSSysUserModel(userid: orderModel.refid, name: orderModel.refname)
            self.remarkTextField.text = orderModel.remark
            self.roomLab.text = orderModel.roomname
            self.selectRoomModel = LSOrderRoomModel(roomid: orderModel.roomid, name: orderModel.roomname)
            self.projectLab.text = orderModel.projectname
            self.selectProjectModel = LSOrderProjectModel(name: orderModel.projectname, projectid: orderModel.projectid)
            if orderModel.ctype == .wheelClock {
                self.jsPlaceholderLab.isHidden = true
                self.jsLab1.text = orderModel.ctypename
                self.jsLabView1.isHidden = false
            }else {
                self.jsPlaceholderLab.isHidden = true
                self.jsLab1.text = orderModel.ctypename
                self.jsLabView1.isHidden = false
                self.jsLab2.text = orderModel.tname
                self.jsLabView2.isHidden = false
            }
        }else {
            self.customerTypeTextField.text = self.customerType.cutomerString
            self.arriveTimeTextField.text = self.arriveDate.string(withFormat: "yyyy-MM-dd HH:mm")
            self.reserveTimeTextField.text = timeType.timeString
            self.referrerLab.text = self.referrerModel.name
        }
        
        self.jsLabView1.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView1.borderWidth = 1
        self.jsLabView2.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView2.borderWidth = 1
        self.jsLabView3.borderColor = Color(hexString: "#2BB8C2")
        self.jsLabView3.borderWidth = 1
        
        self.customerTypeView.rx.tapGesture().when(.recognized).subscribe {[weak self] _ in
            guard let self = self else {return}
            let choiceCustomerVC = LSChoiceCustomerViewController.creaeFromStoryboard()
            choiceCustomerVC.customerType = self.customerType
            choiceCustomerVC.selectedClosure = { customerType in
                self.customerType = customerType
                self.customerTypeTextField.text = customerType.cutomerString
            }
            choiceCustomerVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.arriveTimeView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let arriveStoreVC = LSArriveStoreViewController.creaeFromStoryboard()
            arriveStoreVC.arriveDate = self.arriveDate
            arriveStoreVC.selectedClosure = { arriveDate in
                self.arriveDate = arriveDate
                self.arriveTimeTextField.text = self.arriveDate.string(withFormat: "yyyy-MM-dd HH:mm")
            }
            arriveStoreVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.reserveTimeView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let reserveTimeVC = LSReserveTimeViewController.creaeFromStoryboard()
            reserveTimeVC.timeType = self.timeType
            reserveTimeVC.selectedClosure = { timeType in
                self.timeType = timeType
                self.reserveTimeTextField.text = timeType.timeString
            }
            reserveTimeVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.referrerView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let referrerVC = LSReferrerViewController.creaeFromStoryboard(with: self.referrerModel)
            referrerVC.referrerModel = self.referrerModel
            referrerVC.selectedClosure = { referrerModel in
                self.referrerModel = referrerModel
                self.referrerLab.text = referrerModel.name
            }
            referrerVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.roomView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            self.chioceDesc(selectedIndex: 0)
        }.disposed(by: self.rx.disposeBag)
        
        self.projectView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            self.chioceDesc(selectedIndex: 1)
        }.disposed(by: self.rx.disposeBag)
        
        self.jsView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self,
                  let _ = self.selectProjectModel else {
                Toast.show("请先选择项目")
                return
            }
            self.chioceDesc(selectedIndex: 2)
        }.disposed(by: self.rx.disposeBag)
    }
    
    func chioceDesc(selectedIndex: Int) {
        let choiceRoomVC = LSChoiceRoomViewController.creaeFromStoryboard(selectRoomModel: self.selectRoomModel, selectProjectModel: self.selectProjectModel, selectJSModel: self.selectJSModel, selectedIndex: selectedIndex, clockSelectModel: clockSelectModel, levelSelectModel: levelSelectModel, sexSelectModel: sexSelectModel)
        choiceRoomVC.selectedClosure = { (selectRoomModel, selectProjectModel, selectJSModel, clockSelectModel, levelSelectModel, sexSelectModel) in
            if let roomModel = selectRoomModel {
                self.selectRoomModel = roomModel
                self.roomLab.text = "\(roomModel.name)"
            }
            
            if let projectModel = selectProjectModel {
                self.selectProjectModel = projectModel
                self.projectLab.text = "\(projectModel.name)-￥\(projectModel.lprice.stringValue(retain: 2))/\(projectModel.smin)分钟"
            }
            
            if  let _ = selectProjectModel {
                let clockSelectModel = clockSelectModel ?? .wheelClock
                let levelSelectModel = levelSelectModel ?? .init(name: "不限", tlid: "")
                let sexSelectModel = sexSelectModel ?? ("不限", "")
                
                self.selectJSModel = selectJSModel
                self.clockSelectModel = clockSelectModel
                self.levelSelectModel = levelSelectModel
                self.sexSelectModel = sexSelectModel
                self.jsPlaceholderLab.isHidden = true
                
                if self.clockSelectModel == .wheelClock {
                    self.jsLab1.superview?.isHidden = false
                    self.jsLab2.superview?.isHidden = false
                    self.jsLab3.superview?.isHidden = false
                    self.jsLab1.text = clockSelectModel.clockString
                    self.jsLab2.text = levelSelectModel.name
                    self.jsLab3.text = sexSelectModel.0
                }else if let jSModel = selectJSModel {
                    self.jsLab1.superview?.isHidden = false
                    self.jsLab2.superview?.isHidden = false
                    self.jsLab3.superview?.isHidden = true
                    self.jsLab1.text = clockSelectModel.clockString
                    self.jsLab2.text = jSModel.name
                }else {
                    self.jsLab1.superview?.isHidden = true
                    self.jsLab2.superview?.isHidden = true
                    self.jsLab3.superview?.isHidden = true
                }
            }
        }
        choiceRoomVC.presentedWith(self)
    }

    @IBAction func subtractAction(_ sender: Any) {
        guard let customerNum = customerNumLab.text?.int,
              customerNum > 1 else {
            return
        }
        customerNumLab.text = "\(customerNum - 1)"
    }
    
    @IBAction func addAction(_ sender: Any) {
        guard let customerNum = customerNumLab.text?.int else {
            return
        }
        customerNumLab.text = "\(customerNum + 1)"
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        guard let name = self.nameTextField.text,
            name.isEmpty == false else {
            Toast.show("请输入个人客户名称")
            return
        }
        guard let moblie = self.mobildTextField.text,
              moblie.isEmpty == false else {
            Toast.show("请输入信息")
            return
        }
        guard let selectRoomModel = self.selectRoomModel else {
            Toast.show("请选择预约房间")
            return
        }
        guard let selectProjectModel = self.selectProjectModel else {
            Toast.show("请选择服务项目")
            return
        }
        guard let clockSelectModel = self.clockSelectModel else {
            Toast.show("请选择预约技师")
            return
        }
        guard (clockSelectModel == .wheelClock &&
              nil != self.levelSelectModel &&
               nil != self.sexSelectModel) || (
                clockSelectModel != .wheelClock &&
                nil != self.selectJSModel) else {
            Toast.show("请选择预约技师")
            return
        }
        let roomlist = [["roomid": selectRoomModel.roomid,
                         "roomname": selectRoomModel.name]].ls_toJSONString()
        var project: [String : Any] = ["projectid": selectProjectModel.projectid,
                            "projectname": selectProjectModel.name,
                            "roomid": selectRoomModel.roomid,
                            "roomname": selectRoomModel.name,
                            "ctype": clockSelectModel.rawValue]
        if let jsModel = self.selectJSModel {
            project["tid"] = jsModel.userid
        }else {
            project["tlid"] = levelSelectModel!.tlid
            project["sex"] = sexSelectModel!.1
        }
        Toast.showHUD()
        var serverSingle: Single<LSNetworkResultModel>?
        var toastString = ""
        if let orderModel = self.orderModel {
            serverSingle = LSWorkbenchServer.updateYuyue(billid: orderModel.billid, name: name, mobile: moblie, custtype: self.customerType, qty: self.customerNumLab.text ?? "1", refid: self.referrerModel.userid, tostoretime: self.arriveDate.string(withFormat: "yyyy-MM-dd hh:mm"), reservemin: self.timeType.reserveString, remark: self.remarkTextField.text ?? "", roomlist: roomlist ?? "", projectlist: [project].ls_toJSONString() ?? "", status: orderModel.status.string)
            toastString = "预约修改成功"
        }else {
            serverSingle = LSWorkbenchServer.insertAppointment(name: name, mobile: moblie, custtype: self.customerType, qty: self.customerNumLab.text ?? "1", refid: self.referrerModel.userid, tostoretime: self.arriveDate.string(withFormat: "yyyy-MM-dd hh:mm"), reservemin: self.timeType.reserveString, remark: self.remarkTextField.text ?? "", roomlist: roomlist ?? "", projectlist: [project].ls_toJSONString() ?? "")
            toastString = "预约创建成功"
        }
        serverSingle?.subscribe { _ in
            self.navigationController?.popToRootViewController(animated: true)
            Toast.show(toastString)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)

        
    }
}
