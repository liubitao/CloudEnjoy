//
//  LSChioceContainerViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/18.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import SnapKit
import LSBaseModules

enum LSChioceType {
    case room
    case project
    case js
    
    var title: String {
        switch self {
        case .room:
            return "选择房间"
        case .project:
            return "选择项目"
        case .js:
            return "选择技师"
        }
    }
}

class LSChioceContainerViewController: LSBaseViewController {
    @IBOutlet weak var titleLab: UILabel!
    var subViewController: LSBaseViewController!
    
    typealias SelectedClosure = (LSOrderRoomModel?, LSOrderProjectModel?, LSSysUserModel?, LSClockType?, LSJSLevelModel?, (String, String)?) -> Void
    var selectedClosure: SelectedClosure?
    
    var selectRoomModel: LSOrderRoomModel?
    var selectProjectModel: LSOrderProjectModel?
    var selectJSModel: LSSysUserModel?
    
    var clockSelectModel: LSClockType?
    var levelSelectModel: LSJSLevelModel?
    var sexSelectModel: (String, String)?
    var chioceType: LSChioceType = .room
    class func creaeFromStoryboard(chioceType: LSChioceType, selectRoomModel: LSOrderRoomModel?, selectProjectModel: LSOrderProjectModel?, selectJSModel: LSSysUserModel?, clockSelectModel: LSClockType?, levelSelectModel: LSJSLevelModel?, sexSelectModel: (String, String)?) -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSChioceContainerViewController") as! Self
        vc.chioceType = chioceType
        vc.selectRoomModel = selectRoomModel
        vc.selectProjectModel = selectProjectModel
        vc.selectJSModel = selectJSModel
        vc.clockSelectModel = clockSelectModel
        vc.levelSelectModel = levelSelectModel
        vc.sexSelectModel = sexSelectModel
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
        self.view.frame = CGRectMake(0, 0, UI.SCREEN_WIDTH, 516+UI.BOTTOM_HEIGHT);

        self.titleLab.text = self.chioceType.title
        
        
        switch chioceType {
        case .room:
            self.subViewController = LSChoiceRoomItemController(selectRoomModel: self.selectRoomModel)
        case .project:
            self.subViewController = LSChioceProjectItemController(selectPojectModel: self.selectProjectModel)
        case .js:
            self.subViewController = LSChioceTechnicianItemController(selectedProjectModel: self.selectProjectModel, selectJSModel: self.selectJSModel, clockSelectModel: self.clockSelectModel, levelSelectModel: self.levelSelectModel, sexSelectModel: self.sexSelectModel)
        }
        self.addChild(self.subViewController)
        self.view.addSubview(self.subViewController.view)
        self.subViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-63 - UI.BOTTOM_HEIGHT)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let choiceRoomVC = self.subViewController as? LSChoiceRoomItemController
        let choiceProjectVC = self.subViewController as? LSChioceProjectItemController
        let choiceJSVC = self.subViewController as? LSChioceTechnicianItemController
        self.selectedClosure?(choiceRoomVC?.selectRoomModel, choiceProjectVC?.selectPojectModel ?? choiceJSVC?.selectedProjectModel, choiceJSVC?.selectJSModel, choiceJSVC?.clockSelectModel, choiceJSVC?.levelSelectModel, choiceJSVC?.sexSelectModel)
        self.dismiss(animated: true)
    }
}
