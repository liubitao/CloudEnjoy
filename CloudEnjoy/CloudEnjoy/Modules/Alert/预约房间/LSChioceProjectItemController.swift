//
//  LSChioceProjectItemController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/16.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import RxSwift
import RxDataSources
import SnapKit
import LSBaseModules

class LSChioceProjectItemController: LSBaseViewController {
    
    @IBOutlet weak var projectTypeSelectedView: HWDownSelectedView!

    var collectionView: UICollectionView!
    var items = PublishSubject<[SectionModel<String, LSOrderProjectModel>]>()
    var projectModels = [LSOrderProjectModel]()
    
    var typeModels = [LSProjectTypeModel]()
    
    var selectProjectTypeModel: LSProjectTypeModel?
    var selectPojectModel: LSOrderProjectModel?

    convenience init(selectPojectModel: LSOrderProjectModel?) {
        self.init()
        self.selectPojectModel = selectPojectModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupViews() {
        self.projectTypeSelectedView.font = Font.pingFangRegular(12)
        self.projectTypeSelectedView.placeholder = "选择项目类型"
        self.projectTypeSelectedView.textAlignment = .left
        self.projectTypeSelectedView.downTextAlignment = .center
        self.projectTypeSelectedView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UI.SCREEN_WIDTH - 10 * 2 - 8 * 2)/3.0, height: 58)
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        self.collectionView =  UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(cellWithClass: LSOrderCell.self)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(65)
            make.bottom.equalToSuperview()
        }
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, LSOrderProjectModel>> { [weak self] dataSource, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withClass: LSOrderCell.self, for: indexPath)
            cell.nameLab.text = model.name
            cell.desLab.text = "￥\(model.lprice.stringValue(retain: 2))/\(model.smin)分钟"
            let isSelected = self?.selectPojectModel?.projectid == model.projectid
            cell.nameLab.textColor = isSelected ? Color.white : Color(hexString: "#333333")
            cell.desLab.textColor = isSelected ? Color.white : Color(hexString: "#333333")
            cell.bgView.backgroundColor = isSelected ? Color(hexString: "#2BB8C2") : Color(hexString: "#DEFDFF")
            return cell
        }
        items.bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        
        self.collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            self.selectPojectModel = self.projectModels[indexPath.item]
            self.items.onNext([SectionModel.init(model: "", items: self.projectModels)])
        }, onError: {_ in
            
        }).disposed(by: self.rx.disposeBag)
        
    }
    
    override func setupData() {
        Toast.showHUD()
        Observable.zip(LSWorkbenchServer.getProjecttypeList().asObservable(), LSWorkbenchServer.getProjectinfoList().asObservable()).subscribe { projectTypeModels, projectinfoList in
            self.typeModels = projectTypeModels?.list ?? []
            self.projectModels = projectinfoList?.list ?? []
            self.refreshUI()
        } onError: { error in
            Toast.show(error.localizedDescription)
        } onCompleted: {
            
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        self.projectTypeSelectedView.listArray = self.typeModels.map{$0.name}
        self.items.onNext([SectionModel.init(model: "", items: self.projectModels)])
    }
    
    func networkRoom() {
        Toast.showHUD()
        LSWorkbenchServer.getProjectinfoList(projecttypeid: self.selectProjectTypeModel?.projecttypeid ?? "").subscribe { listModel in
            self.projectModels = listModel?.list ?? []
            self.items.onNext([SectionModel.init(model: "", items: self.projectModels)])
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }


}

extension LSChioceProjectItemController: HWDownSelectedViewDelegate {
    func downSelectedView(_ selectedView: HWDownSelectedView!, didSelectedAtIndex indexPath: IndexPath!) {
        self.selectProjectTypeModel = self.typeModels[indexPath.row]
        self.networkRoom()
    }
}

extension LSChioceProjectItemController: JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
}
