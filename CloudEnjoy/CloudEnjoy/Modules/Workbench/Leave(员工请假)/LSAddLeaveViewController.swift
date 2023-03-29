//
//  LSAddLeaveViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/28.
//

import UIKit
import LSBaseModules
import RxSwift

class LSAddLeaveViewController: LSBaseViewController {

    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeTextField: UITextField!

    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var durationLab: UILabel!
    
    @IBOutlet weak var reasonTextField: UITextField!
    
    var leaveTypeModel: LSLeaveTypeModel?
    var startTime: Date?
    var endTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新增请假"
    }
    
    override func setupViews() {
        self.typeView.rx.tapGesture().when(.recognized).subscribe {[weak self] _ in
            guard let self = self else { return }
            let choiceTypeVC = LSChoiceLeaveTypeController.creaeFromStoryboard(with: self.leaveTypeModel)
            choiceTypeVC.selectedClosure = { leaveTypeModel in
                self.leaveTypeModel = leaveTypeModel
                self.typeTextField.text = leaveTypeModel.name
            }
            choiceTypeVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.startTimeView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            let choiceTimeVC = LSChoiceTimeViewController.creaeFromStoryboard("开始时间")
            choiceTimeVC.selectedDate = self.startTime ?? Date()
            choiceTimeVC.selectedClosure = { startTime in
                self.startTime = startTime
                self.startTimeTextField.text = startTime.string(withFormat: "yyyy-MM-dd hh:mm")
                self.endTime = nil
                self.endTimeTextField.text = ""
            }
            choiceTimeVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.endTimeView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self,
                  let startTime = self.startTime else { return }
            let choiceTimeVC = LSChoiceTimeViewController.creaeFromStoryboard("结束时间")
            choiceTimeVC.selectedDate = self.endTime ?? Date()
            choiceTimeVC.limitMinDate = startTime
            choiceTimeVC.selectedClosure = { endTime in
                self.endTime = endTime
                self.endTimeTextField.text = endTime.string(withFormat: "yyyy-MM-dd hh:mm")
                self.durationLab.text = endTime.hoursSince(startTime).roundString(retain: 0)
            }
            choiceTimeVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
    }

    @IBAction func submitAction(_ sender: Any) {
        guard let leaveTypeModel = self.leaveTypeModel,
              let startTime = self.startTime?.string(withFormat: "yyyy-MM-dd hh:mm"),
              let endTime = self.endTime?.string(withFormat: "yyyy-MM-dd hh:mm"),
              let hours = self.durationLab.text,
              hours.isEmpty == false,
              let reason = self.reasonTextField.text,
              reason.isEmpty == false else {
            Toast.show("请填写完全")
            return
        }
        Toast.showHUD()
        LSWorkbenchServer.insertLeave(leavetypeid: leaveTypeModel.leavetypeid, leavetypename: leaveTypeModel.name, starttime: startTime, endtime: endTime, hours: hours, remark: reason, name: userModel().name, branchname: userModel().branchname).subscribe { _ in
            Toast.show("该请假已提交")
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("LeaveListRefresh"), object: nil)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
   

}
