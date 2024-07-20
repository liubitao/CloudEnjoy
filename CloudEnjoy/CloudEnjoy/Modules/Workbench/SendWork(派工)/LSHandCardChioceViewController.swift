//
//  LSHandCardChioceViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/18.
//

import UIKit
import SwifterSwift
import RxSwift
import RxDataSources
import SnapKit
import LSBaseModules

class LSHandCardChioceViewController: LSBaseViewController {

    @IBOutlet weak var handCardTypeSelectedView: HWDownSelectedView!
    @IBOutlet weak var handCardNumTextField: UITextField!
    
    var collectionView: UICollectionView!
    var items = PublishSubject<[SectionModel<String, LSHandCardModel>]>()
    var handCardModels = [LSHandCardModel]()
    
    var typeModels = [LSHandCardTypeModel]()
    
    var selectHandCardTypeModel: LSHandCardTypeModel?
    var selectHandCardModel: LSHandCardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupViews() {
        self.navigationItem.title = "派工"

        self.handCardTypeSelectedView.font = Font.pingFangRegular(12)
//        self.roomTypeSelectedView.textColor = Color(hexString: "#909399")
        self.handCardTypeSelectedView.placeholder =  "选择手牌类型"
        self.handCardTypeSelectedView.textAlignment = .left
        self.handCardTypeSelectedView.downTextAlignment = .center
        self.handCardTypeSelectedView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UI.SCREEN_WIDTH - 10 * 2 - 7 * 3)/4.0, height: 58)
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        self.collectionView =  UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(cellWithClass: LSRoomChioceCell.self)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(65 + UI.STATUS_NAV_BAR_HEIGHT)
            make.bottom.equalToSuperview().offset(-43 - 10 - UI.BOTTOM_HEIGHT - 10)
        }
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, LSHandCardModel>> { [weak self] dataSource, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withClass: LSRoomChioceCell.self, for: indexPath)
            cell.nameLab.text = model.handcardno
            cell.desLab.text = model.handcardtypename
            let isSelected = self?.selectHandCardModel?.handcardid == model.handcardid
            cell.nameLab.textColor = isSelected ? Color.white : Color(hexString: "#333333")
            cell.desLab.textColor = isSelected ? Color.white : Color(hexString: "#333333")
            cell.bgView.backgroundColor = isSelected ? Color(hexString: "#2BB8C2") : Color(hexString: "#DEFDFF")
            return cell
        }
        items.bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        
        self.collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            self.selectHandCardModel = self.handCardModels[indexPath.item]
            self.items.onNext([SectionModel.init(model: "", items: self.handCardModels)])
        }, onError: {_ in
            
        }).disposed(by: self.rx.disposeBag)
        
    }
    
    override func setupData() {
        Toast.showHUD()
        Observable.zip(LSWorkbenchServer.getHandCardTypeList().asObservable(), LSWorkbenchServer.getHandcardinfoList(cond: "", handcardtypeid: "").asObservable()).subscribe { handCardTypeModels, handCardinfoList in
            self.typeModels = [LSHandCardTypeModel.init(name: "全部手牌")] +  (handCardTypeModels?.list ?? [])
            self.handCardModels = handCardinfoList?.list ?? []
            self.refreshUI()
        } onError: { error in
            Toast.show(error.localizedDescription)
        } onCompleted: {
            
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        self.handCardTypeSelectedView.listArray = self.typeModels.map{$0.name}
        self.items.onNext([SectionModel.init(model: "", items: self.handCardModels)])
    }

    @IBAction func searchAction(_ sender: Any) {
        self.networkHandCard()
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.navigationController?.pushViewController(LSProjectListViewController(handCardModel: self.selectHandCardModel))
    }
    
    func networkHandCard() {
        Toast.showHUD()
        LSWorkbenchServer.getHandcardinfoList(cond: self.handCardNumTextField.text ?? "", handcardtypeid: self.selectHandCardTypeModel?.handcardtypeid ?? "").subscribe { listModel in
            self.handCardModels = listModel?.list ?? []
            self.items.onNext([SectionModel.init(model: "", items: self.handCardModels)])
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handCardTypeSelectedView.close()
    }
}




extension LSHandCardChioceViewController: HWDownSelectedViewDelegate {
    func downSelectedView(_ selectedView: HWDownSelectedView!, didSelectedAtIndex indexPath: IndexPath!) {
        self.selectHandCardTypeModel = self.typeModels[indexPath.row]
        self.networkHandCard()
    }
}

class LSHandCardChioceCell: UICollectionViewCell {
    var nameLab: UILabel!
    var desLab: UILabel!
    var bgView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.bgView = {
            let bgView = UIView()
            bgView.backgroundColor = Color(hexString: "#DEFDFF")
            bgView.cornerRadius = 5
            self.contentView.addSubview(bgView)
            bgView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return bgView
        }()
        self.nameLab = {
           let roomNameLab = UILabel()
            roomNameLab.textColor = Color(hexString: "#333333")
            roomNameLab.font = Font.pingFangRegular(14)
            self.contentView.addSubview(roomNameLab)
            roomNameLab.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(12)
                make.height.equalTo(21)
            }
            return roomNameLab
        }()
        
        self.desLab = {
           let roomTypeLab = UILabel()
            roomTypeLab.textColor = Color(hexString: "#333333")
            roomTypeLab.font = Font.pingFangRegular(11)
            self.contentView.addSubview(roomTypeLab)
            roomTypeLab.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.nameLab.snp.bottom)
                make.height.equalTo(17)
            }
            return roomTypeLab
        }()
    }
    
}


