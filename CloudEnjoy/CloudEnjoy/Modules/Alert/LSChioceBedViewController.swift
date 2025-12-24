//
//  LSChioceBedViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/19.
//

import UIKit
import SwifterSwift
import PickerView
import RxSwift

class LSChioceBedViewController: LSBaseViewController {

    @IBOutlet weak var pickerView: PickerView!
    
    
    typealias SelectedClosure = (LSBedModel) -> Void
    var selectedClosure: SelectedClosure?
    
    var roomModel: LSOrderRoomModel!
    var bedModel: LSBedModel = LSBedModel()
    var list: [LSBedModel] = []
    
    class func creaeFromStoryboard(roomModel: LSOrderRoomModel, bedModel: LSBedModel?) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChioceBedViewController") as! Self
        vc.roomModel = roomModel
        vc.bedModel = bedModel ?? LSBedModel()
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
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 300+UI.BOTTOM_HEIGHT);
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.selectionStyle = .overlay
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH - 26, height: 44))
        overlayView.backgroundColor = Color(hexString: "#F1FEFF")
        self.pickerView.selectionOverlay = overlayView
    }
    
    override func setupData() {
        Toast.showHUD()
        LSWorkbenchServer.getBedList(roomid: roomModel.roomid).subscribe { models in
            guard let list = models,
                !list.isEmpty else {
                return
            }
            self.list = list
            let row = self.list.firstIndex(where: { $0.bedid == self.bedModel.bedid }) ?? 0
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
        guard self.list.count > self.pickerView.currentSelectedIndex else{
            Toast.show("请选择床位")
            return
        }
        self.bedModel = self.list[self.pickerView.currentSelectedIndex]
        self.selectedClosure?(self.bedModel)
        self.dismiss(animated: true)
    }
    
}

extension LSChioceBedViewController: PickerViewDataSource, PickerViewDelegate {
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        return list[row].name
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
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int) {
        self.bedModel = self.list[self.pickerView.currentSelectedIndex]
    }
}

