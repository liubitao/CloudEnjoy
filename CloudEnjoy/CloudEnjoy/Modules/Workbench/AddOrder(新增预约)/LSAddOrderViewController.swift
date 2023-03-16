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
    @IBOutlet weak var jsLab: UITextField!
    
    var customerType: LSCustomerType = .common
    var arriveDate: Date = Date()
    var timeType: LSReserveTimeType = .fifteen
    var referrerModel = LSSysUserModel(userid: userModel().userid, name: userModel().name)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新增预约"
    }
    
    override func setupViews() {
        self.customerTypeTextField.text = self.customerType.cutomerString
        self.arriveTimeTextField.text = self.arriveDate.string(withFormat: "yyyy-MM-dd HH:mm")
        self.reserveTimeTextField.text = timeType.timeString
        self.referrerLab.text = self.referrerModel.name
        
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
            
        }.disposed(by: self.rx.disposeBag)
        
        self.jsView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            
        }.disposed(by: self.rx.disposeBag)
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
        
        
    }
}
