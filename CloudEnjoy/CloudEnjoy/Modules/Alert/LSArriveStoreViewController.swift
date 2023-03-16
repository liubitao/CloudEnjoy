//
//  LSArriveStoreViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/16.
//

import UIKit
import SwifterSwift
import SnapKit

class LSArriveStoreViewController: LSBaseViewController {

    var datePicker: LSDatePickerView? = nil
    
    typealias SelectedClosure = (Date) -> Void
    var selectedClosure: SelectedClosure?
    
    var arriveDate: Date = Date()
    
    class func creaeFromStoryboard() -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSArriveStoreViewController")
        return vc as! Self
    }
    
    func presentedWith(_ presentingViewController: LSBaseViewController) {
        let transitionAnimationDelegate = TransitionAnimationDelegate()
        transitionAnimationDelegate.overlayTransitioningType = .blackBackground
        transitionAnimationDelegate.touchInBackgroundType = .doNothing
        transitionAnimationDelegate.viewAnimationType = .transformFromBottom
        transitionAnimationDelegate.enableInteractive = true
        self.transitioningDelegate = transitionAnimationDelegate
        self.modalPresentationStyle = .custom
        presentingViewController.present(self, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white;
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 243+UI.BOTTOM_HEIGHT);
        self.datePicker = LSDatePickerView(type: DatePickerStyle.KDatePickerTime, currentDate: self.arriveDate)
        self.view.addSubview(self.datePicker!)
        self.datePicker?.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(27)
            make.height.equalTo(132)
        }
    }
    

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.selectedClosure?(self.datePicker!.currentDate)
        self.dismiss(animated: true)
    }

}
