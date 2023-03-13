//
//  LSSystemViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/3.
//

import UIKit
import LSBaseModules

class LSSystemViewController: LSBaseViewController {

    @IBOutlet weak var screenSwitch: UISwitch!
    
    @IBOutlet weak var voiceView: UIView!
    
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var newVersionView: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var aboutView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统设置"
    }
    
    override func setupViews() {
        self.versionLabel.text = "V\(UIApplication.shared.version.unwrapped(or: ""))"
        screenSwitch.transform = CGAffineTransformMakeScale(0.67, 0.67);
        self.newVersionView.cornerRadius = 5
        self.newVersionView.isHidden = true
        let screenBool = AppDataCache.get(key: "screenSwitch") as? Bool ?? true
        screenSwitch.isOn = screenBool

        voiceView.rx.tapGesture().when(.recognized).subscribe { [weak self]_ in
            guard let self = self else {return}
            LSVoiceViewController.creaeFromStoryboard().presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        versionView.rx.tapGesture().when(.recognized).subscribe { _ in
            Toast.show("暂未上架，后期填充")
        }.disposed(by: self.rx.disposeBag)
        
        aboutView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(LSAboutViewController(), animated: true)
        }.disposed(by: self.rx.disposeBag)
        
    }
    
    override func setupData() {
        LSAppServer.getVersion().subscribe { versionModel in
            guard let versionModel = versionModel else {
                self.newVersionView.isHidden = true
                return
            }
            self.newVersionView.isHidden = versionModel.cname == UIApplication.shared.version.unwrapped(or: "")
        } onFailure: { _ in
            
        }.disposed(by: self.rx.disposeBag)

    }
    
    @IBAction func switchScreenAction(_ sender: UISwitch) {
        AppDataCache.set(key: "screenSwitch", value: sender.isOn)
        UIApplication.shared.isIdleTimerDisabled = sender.isOn
    }
}
