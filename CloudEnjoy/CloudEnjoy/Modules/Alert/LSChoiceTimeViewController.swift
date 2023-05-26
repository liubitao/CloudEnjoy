//
//  LSChoiceTimeViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/29.
//

import UIKit
import SwifterSwift
import SnapKit

class LSChoiceTimeViewController: LSBaseViewController {

    var datePicker: LSDatePickerView? = nil
    
    @IBOutlet weak var titleLab: UILabel!
    
    typealias SelectedClosure = (Date) -> Void
    var selectedClosure: SelectedClosure?
    
    var selectedDate: Date = Date()
    var limitMinDate: Date?
    
    class func creaeFromStoryboard(_ title: String) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChoiceTimeViewController")
        vc.title = title
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
        
        self.titleLab.text = title
        self.datePicker = LSDatePickerView(type: DatePickerStyle.KDatePickerTime, currentDate: self.selectedDate)
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
        let currentDate = self.datePicker!.currentDate
        if let limitMinDate = self.limitMinDate,
              currentDate.compare(limitMinDate) != .orderedDescending {
            Toast.show("请选择大于" + (limitMinDate.stringTime24(withFormat:"yyyy-MM-dd HH:mm")) + "时间")
            return
        }
        self.selectedClosure?(self.datePicker!.currentDate)
        self.dismiss(animated: true)
    }

}

