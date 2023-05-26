//
//  LSProjectDetailsViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/6.
//

import UIKit
import SwifterSwift
import RxSwift
import RxDataSources
import LSBaseModules

typealias OpeartionModel = (iconImage:String, title: String)

class LSProjectDetailsViewController: LSBaseViewController {
    
    @IBOutlet weak var headBgView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusTitleLab: UILabel!
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var projectNameLab: UILabel!
    @IBOutlet weak var numberLab: UILabel!
    @IBOutlet weak var projectMoneyLab: UILabel!
    @IBOutlet weak var projectDurationLab: UILabel!
    @IBOutlet weak var clockLab: UILabel!
    @IBOutlet weak var dispatchTimeLab: UILabel!
    @IBOutlet weak var createTimeLab: UILabel!
    @IBOutlet weak var opeartionNameLab: UILabel!
    @IBOutlet weak var refNameLab: UILabel!
    @IBOutlet weak var upClockTimeLab: UILabel!
    @IBOutlet weak var downClockTimeLab: UILabel!
    @IBOutlet weak var createTimeView: UIView!
    @IBOutlet weak var dispatchTimeView: UIView!
    @IBOutlet weak var upClockTimeView: UIView!
    @IBOutlet weak var downClockTimeView: UIView!
    var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    var projectModel: LSHomeProjectModel!
    
    var items = PublishSubject<[SectionModel<String, OpeartionModel>]>()
    
    
    convenience init(_ projectModel: LSHomeProjectModel) {
        self.init()
        self.projectModel = projectModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工单详情"
    }
    
    override func setupViews() {
        self.headBgView.image = UIImage.createGradientImage(startColor: Color(hexString: "#00C294")!, endColor: Color(hexString: "#00AAB7")!, width: UI.SCREEN_WIDTH - 20, height: 75)
        
        self.statusImageView.image = projectModel.status.statusImage
        self.statusTitleLab.text = projectModel.status.statusString
        
        self.roomNameLab.text = projectModel.roomname + (parametersModel().OperationMode == 0 ? "(床位：\(projectModel.bedname))" : "(手牌：\(projectModel.handcardno))")
        self.projectNameLab.text = projectModel.projectname
        self.numberLab.text = projectModel.qty.string
        self.projectMoneyLab.text = "￥" + projectModel.amt.stringValue(retain: 2)
        self.projectDurationLab.text = projectModel.min + "分钟"
        self.clockLab.text = projectModel.ctype.clockString
        self.createTimeLab.text = projectModel.createtime
        self.dispatchTimeLab.text = projectModel.dispatchtime
        self.opeartionNameLab.text = projectModel.createname
        self.refNameLab.text = projectModel.refname
        self.upClockTimeLab.text = projectModel.starttime
        self.downClockTimeLab.text = "预计 " + (projectModel.starttime.date(withFormat: "yyyy-MM-dd HH:mm:ss")?.adding(.minute, value: projectModel.min.int ?? 0).stringTime24(withFormat:"yyyy-MM-dd HH:mm:ss") ?? "")
        
        self.createTimeView.isHidden = projectModel.status != .subscribe
        self.dispatchTimeView.isHidden = !(projectModel.status == .servicing || projectModel.status == .wait)
        self.upClockTimeView.isHidden = projectModel.status != .servicing
        self.downClockTimeView.isHidden = projectModel.status != .servicing
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UI.SCREEN_WIDTH - 10 * 2 - 8 * 3)/3.0, height: 40)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        self.collectionView =  UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(cellWithClass: LSProjectOpeartionCell.self)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(102)
            make.bottom.equalToSuperview().offset(-UI.BOTTOM_HEIGHT)
        }
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, OpeartionModel>> { dataSource, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withClass: LSProjectOpeartionCell.self, for: indexPath)
            cell.iconImage.image = UIImage(named: model.iconImage)
            cell.titleLab.text = model.title
            return cell
        }
        items.bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        
        self.collectionView.rx.modelSelected(OpeartionModel.self).subscribe(onNext: { [weak self] model in
            guard let self = self else {return}
            switch model.title {
            case "技师上钟":
                let clockVC = LSUpClockViewController.creaeFromStoryboard(with: self.projectModel)
                clockVC.presentedWith(self)
            case "技师下钟":
                let clockVC = LSDownClockViewController.creaeFromStoryboard(with: self.projectModel)
                clockVC.presentedWith(self)
            case "商品下单":
                self.navigationController?.pushViewController(LSGoodsViewController(with: self.projectModel), animated: true)
            case "呼叫服务":
                self.navigationController?.pushViewController(LSServiceViewController(with: self.projectModel), animated: true)
            case "项目加钟":
                self.navigationController?.pushViewController(LSAddClockViewController(with: self.projectModel), animated: true)
            case "更换项目":
                LSChangeClockViewController.creaeFromStoryboard(with: self.projectModel).presentedWith(self)
            case "退钟":
                self.navigationController?.pushViewController(LSRejectProjectViewController(with: self.projectModel), animated: true)
            default: break
            }
        }, onError: {_ in
            
        }).disposed(by: self.rx.disposeBag)
    }
    
    override func setupData() {
        let waitData: [OpeartionModel] = [("技师上下钟", "技师上钟"), ("商品下单", "商品下单"), ("呼叫服务", "呼叫服务"), ("项目加钟", "项目加钟"), ("更换项目", "更换项目"), ("退钟", "退钟")]
        
        let servicingData: [OpeartionModel] = [("技师上下钟", "技师下钟"), ("商品下单", "商品下单"), ("呼叫服务", "呼叫服务"), ("项目加钟", "项目加钟"), ("更换项目", "更换项目"), ("退钟", "退钟")]
        
        let sectionModels = [SectionModel.init(model: "", items: self.projectModel.status == .wait ? waitData : servicingData)]
        self.items.onNext(sectionModels)
    }

}


class LSProjectOpeartionCell: UICollectionViewCell {
    var iconImage: UIImageView!
    var titleLab: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.cornerRadius = 5
        self.contentView.borderWidth = 1
        self.contentView.borderColor = Color(hexString: "#D6D6D6")
        
        self.iconImage = {
            let iconImage = UIImageView()
            self.contentView.addSubview(iconImage)
            iconImage.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(17)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 22, height: 22))
            }
            return iconImage
        }()
        
        self.titleLab = {
           let titleLab = UILabel()
            titleLab.textColor = Color(hexString: "#002629")
            titleLab.font = Font.pingFangRegular(13)
            self.contentView.addSubview(titleLab)
            titleLab.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.iconImage.snp.right).offset(4)
            }
            return titleLab
        }()
    }
}
