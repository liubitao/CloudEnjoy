//
//  LSHomeUserStatusView.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/3.
//

import UIKit
import RxSwift
import SwifterSwift
import LSBaseModules

class LSHomeUserStatusView: UIView {
    
    @IBOutlet var restView: UIView! //休息
    
    
    @IBOutlet var leaveView: UIView! //请假
    @IBOutlet weak var hoursLab: UILabel!
    @IBOutlet weak var leaveTimeLab: UILabel!
    
    @IBOutlet var noSignView: UIView! //未签到
    @IBOutlet weak var signTimeLab: UILabel!
    @IBOutlet weak var signTypeBtn: UIButton!
    
    
    
    @IBOutlet var circleCardView: UIView!//圈牌中
    
    @IBOutlet var orderReceivingView: UIView!//接单中
    @IBOutlet weak var workTimeLab: UILabel!
    @IBOutlet weak var workTypeBtn: UIButton!
    
    
    @IBOutlet var waitClockView: UIView!//待上钟
    @IBOutlet weak var waitTimeLab: UILabel!
    @IBOutlet weak var hadWaitLab: UILabel!
    
    @IBOutlet var servicingView: UIView!//服务中
    @IBOutlet weak var timeRemainingLab: UILabel!
    
    
    @IBOutlet var subscribeView: UIView!//预约中
    @IBOutlet weak var subscribeTimeLab: UILabel!

    
    var userStatusModel: LSUserStatusModel?
    
    var dispose: Disposable?

    
    class func createFromXib() -> Self {
        let view = Bundle.main.loadNibNamed("LSHomeUserStatusView", owner: nil)?.last as! Self
        return view
    }
    
    
    func refreshUI(_ userStatusModel: LSUserStatusModel?) {
        guard let model = userStatusModel else{
            return
        }
        self.userStatusModel = model
        
        self.subviews.forEach{$0.removeFromSuperview()}
        self.dispose?.dispose()
        var view: UIView?
        switch model.status {
            case .rest:
            view = restView
            case .leave:
            view = leaveView
            hoursLab.text = model.hours.stringValue(retain: 2) + "小时/" + model.leavetypename
            leaveTimeLab.text = model.starttime + "至" + model.endtime
            case .noSign: view = noSignView
            signTimeLab.isHidden = model.workshift.isEmpty
            signTypeBtn.isHidden = model.shiftname.isEmpty
            signTimeLab.text = model.workshift + "-" + model.closingtime
            signTypeBtn.setTitle(model.shiftname, for: .normal)
            
            case .circleCard: view = circleCardView
            
            case .orderReceiving: view = orderReceivingView
            workTimeLab.isHidden = model.workshift.isEmpty
            workTypeBtn.isHidden = model.shiftname.isEmpty
            workTimeLab.text = model.workshift + "-" + model.closingtime
            workTypeBtn.setTitle(model.shiftname, for: .normal)
            
            case .waitClock: view = waitClockView
            let dispatchDate = model.dispatchtime.date(withFormat: "yyyy-MM-dd hh:mm:ss") ?? Date()
            let hadOverTime = dispatchDate.compare(Date()) == .orderedAscending
            waitTimeLab.isHidden = hadOverTime
            hadWaitLab.isHidden = !hadOverTime
            if hadOverTime == true {
                self.dispose = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance).subscribe(onNext: { _ in
                    let secondsSince = Date().timeIntervalSince(dispatchDate).int
                    self.hadWaitLab.text = "已等待：" + String(format: "%02d", secondsSince/3600) + ":" + String(format: "%02d", secondsSince/60%60) + ":" + String(format: "%02d", secondsSince%60)
                    let makeAppointmentReminder = (parametersModel().MakeAppointmentReminder == 0 ? 5 : parametersModel().MakeAppointmentReminder) * 60
                    if secondsSince % makeAppointmentReminder == 0 {
                        LSAudioQueueManager.shared.enqueueToQueue(LSAudioOperation(audioName: "你有派工任务请尽快安排上钟(派工后提醒，后台设置每隔几分钟)"))
                    }
                })
            }else {
                waitTimeLab.text = model.dispatchtime
            }
            
            case .servicing: view = servicingView
            self.dispose = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance).subscribe(onNext: { _ in
                let endDate = model.starttime.date(withFormat: "yyyy-MM-dd hh:mm:ss")?.adding(.minute, value: model.min)
                let secondsSince = endDate?.timeIntervalSince(Date()).int ?? 0
                if secondsSince > 0 {
                    self.timeRemainingLab.text = "剩余时长：" + String(format: "%02d", secondsSince/3600) + ":" + String(format: "%02d", secondsSince/60%60) + ":" + String(format: "%02d", secondsSince%60)
                    let nextBellReminder = (parametersModel().NextBellReminder == 0 ? 5 : parametersModel().NextBellReminder) * 60
                    if secondsSince == nextBellReminder {
                        LSAudioQueueManager.shared.enqueueToQueue(LSAudioOperation(audioName: "本次服务即将到时请注意下钟时(下钟前提醒，后台设置提前几分钟)"))
                    }
                }else {
                    let timeoutReminder = (parametersModel().TimeoutReminder == 0 ? 5 : parametersModel().TimeoutReminder) * 60
                    if secondsSince % timeoutReminder == 0 {
                        LSAudioQueueManager.shared.enqueueToQueue(LSAudioOperation(audioName: "本次服务已超时请注意下钟时间(超时提醒，后台设置每隔几分钟)"))
                    }
                    self.timeRemainingLab.text = "剩余时长：00:00:00"
                }
            })
            
        case .subscribe: view = subscribeView
            subscribeTimeLab.text = "到店时间：" + model.tostoretime
            
        }
        self.addSubview(view!)
        view?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    @IBAction func cancelLeaveAction(_ sender: Any) {
        self.viewContainingController()?.navigationController?.pushViewController(LSLeaveViewController(), animated: true)
    }
    
    @IBAction func upWorkAction(_ sender: Any) {
        self.viewContainingController()?.navigationController?.pushViewController(LSClockinViewController(), animated: true)
    }
    
    @IBAction func downWorkAction(_ sender: Any) {
        self.viewContainingController()?.navigationController?.pushViewController(LSClockinViewController(), animated: true)
    }
    
}


