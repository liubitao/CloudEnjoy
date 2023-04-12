//
//  LSHomeUserStatusView.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/3.
//

import UIKit
import RxSwift
import SwifterSwift

class LSHomeUserStatusView: UIView {
    
    @IBOutlet var restView: UIView! //休息
    
    
    @IBOutlet var leaveView: UIView! //请假
    @IBOutlet weak var hoursLab: UILabel!
    @IBOutlet weak var leaveTimeLab: UILabel!
    
    @IBOutlet var noSignView: UIView! //未签到
    
    @IBOutlet var circleCardView: UIView!//圈牌中
    
    @IBOutlet var orderReceivingView: UIView!//接单中
    @IBOutlet weak var workTimeLab: UILabel!
    @IBOutlet weak var workTypeBtn: UIButton!
    
    
    @IBOutlet var waitClockView: UIView!//待上钟
    @IBOutlet weak var waitTimeLab: UILabel!
    
    
    @IBOutlet var servicingView: UIView!//服务中
    @IBOutlet weak var timeRemainingLab: UILabel!
    
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
            hoursLab.text = model.hours + "小时/" + model.leavetypename
            leaveTimeLab.text = model.starttime + "至" + model.endtime
            case .noSign: view = noSignView
            case .circleCard: view = circleCardView
            case .orderReceiving: view = orderReceivingView
            workTimeLab.text = model.workshift + "-" + model.closingtime
            workTypeBtn.setTitle(model.shiftname, for: .normal)
            case .waitClock: view = waitClockView
            waitTimeLab.text = model.dispatchtime
            case .servicing: view = servicingView
            self.dispose = Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.asyncInstance).subscribe({ _ in
                let endDate = model.starttime.date(withFormat: "yyyy-MM-dd hh:mm:ss")?.adding(.minute, value: model.min)
                let secondsSince = endDate?.timeIntervalSince(Date()).int ?? 0
                self.timeRemainingLab.text = "剩余时长：" + String(format: "%02d", secondsSince/3600) + ":" + String(format: "%02d", secondsSince/60) + ":" + String(format: "%02d", secondsSince%3600)
            })
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


