//
//  LSRoomChioceViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/17.
//

import UIKit
import SwifterSwift
import RxSwift
import RxDataSources
import SnapKit
import LSBaseModules

class LSRoomChioceViewController: LSBaseViewController {

    @IBOutlet weak var roomTypeSelectedView: HWDownSelectedView!
    @IBOutlet weak var roomNumTextField: UITextField!
    
    var collectionView: UICollectionView!
    var items = PublishSubject<[SectionModel<String, LSOrderRoomModel>]>()
    var roomModels = [LSOrderRoomModel]()
    
    var typeModels = [LSRoomTypeModel]()
    
    var selectRoomTypeModel: LSRoomTypeModel?
    var selectRoomModel: LSOrderRoomModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupViews() {
        self.navigationItem.title = "派工"

        self.roomTypeSelectedView.font = Font.pingFangRegular(12)
//        self.roomTypeSelectedView.textColor = Color(hexString: "#909399")
        self.roomTypeSelectedView.placeholder =  "选择房间类型"
        self.roomTypeSelectedView.textAlignment = .left
        self.roomTypeSelectedView.downTextAlignment = .center
        self.roomTypeSelectedView.delegate = self
        
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
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, LSOrderRoomModel>> { [weak self] dataSource, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withClass: LSRoomChioceCell.self, for: indexPath)
            cell.nameLab.text = model.name
            cell.desLab.text = model.roomtypename
            let isSelected = self?.selectRoomModel?.roomid == model.roomid
            cell.nameLab.textColor = isSelected ? Color.white : Color(hexString: "#333333")
            cell.desLab.textColor = isSelected ? Color.white : Color(hexString: "#333333")
            cell.bgView.backgroundColor = isSelected ? Color(hexString: "#2BB8C2") : Color(hexString: "#DEFDFF")
            return cell
        }
        items.bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        
        self.collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            self.selectRoomModel = self.roomModels[indexPath.item]
            self.items.onNext([SectionModel.init(model: "", items: self.roomModels)])
        }, onError: {_ in
            
        }).disposed(by: self.rx.disposeBag)
        
    }
    
    override func setupData() {
        Toast.showHUD()
        Observable.zip(LSWorkbenchServer.getRoomtypeList(cond: "").asObservable(), LSWorkbenchServer.getRoominfoList(cond: "", roomtypeid: "").asObservable()).subscribe { roomTypeModels, roominfoList in
            self.typeModels = [LSRoomTypeModel.init(name: "全部房", roomtypeid: "", id: "")] + (roomTypeModels?.list ?? [])
            self.roomModels = roominfoList?.list ?? []
            self.refreshUI()
        } onError: { error in
            Toast.show(error.localizedDescription)
        } onCompleted: {
            
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        self.roomTypeSelectedView.listArray = self.typeModels.map{$0.name}
        self.items.onNext([SectionModel.init(model: "", items: self.roomModels)])
    }

    @IBAction func searchAction(_ sender: Any) {
        self.networkRoom()
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.navigationController?.pushViewController(LSProjectListViewController(roomModel: self.selectRoomModel))
    }
    
    func networkRoom() {
        Toast.showHUD()
        LSWorkbenchServer.getRoominfoList(cond: self.roomNumTextField.text ?? "", roomtypeid: self.selectRoomTypeModel?.roomtypeid ?? "").subscribe { listModel in
            self.roomModels = listModel?.list ?? []
            self.items.onNext([SectionModel.init(model: "", items: self.roomModels)])
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.roomTypeSelectedView.close()
    }
}




extension LSRoomChioceViewController: HWDownSelectedViewDelegate {
    func downSelectedView(_ selectedView: HWDownSelectedView!, didSelectedAtIndex indexPath: IndexPath!) {
        self.selectRoomTypeModel = self.typeModels[indexPath.row]
        self.networkRoom()
    }
}

class LSRoomChioceCell: UICollectionViewCell {
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


