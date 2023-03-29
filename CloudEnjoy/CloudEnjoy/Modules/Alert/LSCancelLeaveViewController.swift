//
//  LSCancelLeaveViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/28.
//

import UIKit
import IQKeyboardManagerSwift
import SwifterSwift

class LSCancelLeaveViewController: LSBaseViewController {
    @IBOutlet weak var textView: IQTextView!
    var billid: String!
    weak var presentingController: LSBaseViewController? = nil
    
    class func creaeFromStoryboard(with billid: String) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSCancelLeaveViewController") as! Self
        vc.billid = billid
        return vc
    }
    
    func presentedWith(_ presentingViewController: LSBaseViewController) {
        let transitionAnimationDelegate = TransitionAnimationDelegate()
        transitionAnimationDelegate.overlayTransitioningType = .blackBackground
        transitionAnimationDelegate.touchInBackgroundType = .doNothing
        transitionAnimationDelegate.viewAnimationType = .alphagGradualChange
        transitionAnimationDelegate.enableInteractive = true
        self.transitioningDelegate = transitionAnimationDelegate
        self.modalPresentationStyle = .custom
        self.presentingController = presentingViewController
        presentingViewController.present(self, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white;
        self.view.cornerRadius = 5
        self.view.frame = CGRectMake((UI.SCREEN_WIDTH - 290)/2.0, (UI.SCREEN_HEIGHT - 234)/2.0, 290, 234);
        
        self.textView.cornerRadius = 5
        self.textView.borderColor = Color(hexString: "#707070")!
        self.textView.borderWidth = 1
        
        self.textView.placeholder = "请输入原因"
        self.textView.placeholderTextColor = Color(hexString: "#D2D2D2")
    }

    @IBAction func confirmAction(_ sender: Any) {
        guard let cencelremark = self.textView.text,
              cencelremark.isEmpty == false else {
            Toast.show("请输入取消原因")
            return
        }
        Toast.showHUD()
        LSWorkbenchServer.cancelLeave(billid: self.billid, cencelremark: cencelremark).subscribe { _ in
            Toast.show("该请假已取消")
            NotificationCenter.default.post(name: NSNotification.Name("LeaveListRefresh"), object: nil)
            self.dismiss(animated: true) {
                self.presentingController?.navigationController?.popViewController(animated: true)
            }
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
