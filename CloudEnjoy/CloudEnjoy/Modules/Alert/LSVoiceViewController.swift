//
//  LSVoiceViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/8.
//

import UIKit
import LSBaseModules

struct LSVoiceSettingModel: Codable {
    var isOpenVoice = true
    var voiceTimes = "1"
}

class LSVoiceViewController: LSBaseViewController {

    @IBOutlet weak var voiceSwitch: UISwitch!
    
    @IBOutlet weak var voiceTimeLab: UILabel!
    
    class func creaeFromStoryboard() -> Self {
        let sb = UIStoryboard.init(name: "AlertStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LSVoiceViewController")
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
        
        self.voiceSwitch.transform = CGAffineTransformMakeScale(0.67, 0.67);
        
        let voiceSettingModel = AppDataCache.getItem(LSVoiceSettingModel.self, forKey: "voiceSetting") ?? LSVoiceSettingModel(isOpenVoice: true, voiceTimes: "1")
        self.voiceSwitch.isOn = voiceSettingModel.isOpenVoice
        self.voiceTimeLab.text = voiceSettingModel.voiceTimes
    }
    @IBAction func subtractAction(_ sender: Any) {
        guard let voiceTime = voiceTimeLab.text?.int,
              voiceTime > 1 else {
            return
        }
        voiceTimeLab.text = "\(voiceTime - 1)"
    }
    
    @IBAction func addAction(_ sender: Any) {
        guard let voiceTime = voiceTimeLab.text?.int else {
            return
        }
        voiceTimeLab.text = "\(voiceTime + 1)"
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let voiceSettingModel = LSVoiceSettingModel(isOpenVoice: self.voiceSwitch.isOn, voiceTimes: self.voiceTimeLab.text ?? "1")
        AppDataCache.setItem(voiceSettingModel, forKey: "voiceSetting")
        self.dismiss(animated: true)
    }
}
