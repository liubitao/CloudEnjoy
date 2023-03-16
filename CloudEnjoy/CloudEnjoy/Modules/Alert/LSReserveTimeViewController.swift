//
//  LSReserveTimeViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/16.
//

import UIKit
import SwifterSwift
import PickerView


class LSReserveTimeViewController: LSBaseViewController {

    @IBOutlet weak var pickerView: PickerView!
    
    typealias SelectedClosure = (LSReserveTimeType) -> Void
    var selectedClosure: SelectedClosure?
    
    var timeType: LSReserveTimeType = .fifteen
    
    var dataSource = LSReserveTimeType.allCases.map{$0.timeString}
    
    class func creaeFromStoryboard() -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSReserveTimeViewController")
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
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        let row = LSReserveTimeType.allCases.firstIndex(of: self.timeType) ?? 0
        self.pickerView.selectRow(row, animated: false)
        self.pickerView.selectionStyle = .overlay
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH - 26, height: 44))
        overlayView.backgroundColor = Color(hexString: "#F1FEFF")
        self.pickerView.selectionOverlay = overlayView
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.timeType = LSReserveTimeType.allCases[self.pickerView.currentSelectedIndex]
        self.selectedClosure?(self.timeType)
        self.dismiss(animated: true)
    }
    
}

extension LSReserveTimeViewController: PickerViewDataSource, PickerViewDelegate {
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        return dataSource[row]
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
