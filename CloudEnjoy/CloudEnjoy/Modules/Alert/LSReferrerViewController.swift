//
//  LSReferrerViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/16.
//

import UIKit
import SwifterSwift
import PickerView
import RxSwift

class LSReferrerViewController: LSBaseViewController {

    @IBOutlet weak var pickerView: PickerView!
    
    typealias SelectedClosure = (LSSysUserModel) -> Void
    var selectedClosure: SelectedClosure?
    
    var referrerModel: LSSysUserModel = LSSysUserModel()
    
    var dataSource: [LSSysUserModel] = []
    
    class func creaeFromStoryboard(with referrerModel: LSSysUserModel) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSReferrerViewController") as! Self
        vc.referrerModel = referrerModel
        return vc
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
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 400+UI.BOTTOM_HEIGHT);
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.selectionStyle = .overlay
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH - 26, height: 44))
        overlayView.backgroundColor = Color(hexString: "#F1FEFF")
        self.pickerView.selectionOverlay = overlayView
    }
    
    override func setupData() {
        Toast.showHUD()
        LSWorkbenchServer.userGetList().subscribe { model in
            guard let list = model?.list else {
                return
            }
            let row = list.firstIndex(where: { $0.userid == self.referrerModel.userid }) ?? 0
            self.dataSource = list
            self.pickerView.reloadPickerView()
            self.pickerView.selectRow(row, animated: false)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)

    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.referrerModel = self.dataSource[self.pickerView.currentSelectedIndex]
        self.selectedClosure?(self.referrerModel)
        self.dismiss(animated: true)
    }
    
}

extension LSReferrerViewController: PickerViewDataSource, PickerViewDelegate {
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        return dataSource[row].name
    }
   
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        label.font = Font.pingFangMedium(14)

        if highlighted {
            label.textColor = Color(hexString: "#2BB8C2")
        } else {
            label.textColor = Color(hexString: "#333333")
        }
    }
}

