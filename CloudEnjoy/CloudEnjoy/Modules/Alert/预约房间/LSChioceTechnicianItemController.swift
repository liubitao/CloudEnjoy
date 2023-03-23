//
//  LSChioceTechnicianItemController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/16.
//

import UIKit
import JXSegmentedView
import SwifterSwift
import RxDataSources
import RxSwift

class LSChioceTechnicianItemController: LSBaseViewController {

    
    @IBOutlet weak var clockContainView: UIView!
    @IBOutlet weak var levelContainView: UIView!
    @IBOutlet weak var sexContainView: UIView!
    
    var clockSegmentedView: JXSegmentedView!
    var clockSegmentedDataSource: LSSegmentedTitleDataSource!
    var levelSegmentedView: JXSegmentedView!
    var levelSegmentedDataSource: LSSegmentedTitleDataSource!
    var sexSegmentedView: JXSegmentedView!
    var sexSegmentedDataSource: LSSegmentedTitleDataSource!

    
    @IBOutlet weak var levelViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var levelSelectedView: HWDownSelectedView!
    @IBOutlet weak var sexSelectedView: HWDownSelectedView!

    @IBOutlet weak var tableView: UITableView!
    var items = PublishSubject<[SectionModel<String, LSSysUserModel>]>()
    var jsModels = [LSSysUserModel]()
    
    var clockModels: [LSClockType] = [.wheelClock, .optionClock, .oClock, .callClock]
    var levelModels = [LSJSLevelModel]()
    var sexModels: [(String, String)] = [("不限", ""), ("女", "0"), ("男", "1")]
    var selectedProjectModel: LSOrderProjectModel?
    
    var clockSelectModel: LSClockType!
    var levelSelectModel: LSJSLevelModel!
    var sexSelectModel: (String, String)!
    
    var selectJSModel: LSSysUserModel?

    
    convenience init(selectedProjectModel: LSOrderProjectModel?, selectJSModel: LSSysUserModel?, clockSelectModel: LSClockType?, levelSelectModel: LSJSLevelModel?, sexSelectModel: (String, String)?) {
        self.init()
        self.selectedProjectModel = selectedProjectModel
        self.selectJSModel = selectJSModel
        self.clockSelectModel = clockSelectModel ?? LSClockType.wheelClock
        self.levelSelectModel = levelSelectModel ?? LSJSLevelModel(name: "不限", tlid: "")
        self.sexSelectModel = sexSelectModel ?? ("不限", "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.white
    }
    
    override func setupViews() {
        self.clockSegmentedView = {
            let clockSegmentedView = JXSegmentedView()
            clockSegmentedView.delegate = self
            clockSegmentedView.backgroundColor = Color(hexString: "#FFFFFF")
            clockSegmentedView.contentEdgeInsetLeft = 0
            clockSegmentedView.contentEdgeInsetRight = 0
            clockSegmentedView.clipsToBounds = true
            clockContainView.addSubview(clockSegmentedView)
            clockSegmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.left.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(0)
                make.height.equalTo(40)
            }
            
            clockSegmentedDataSource = LSSegmentedTitleDataSource()
            clockSegmentedDataSource.titles = clockModels.map{$0.clockString}
            clockSegmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
            clockSegmentedDataSource.titleSelectedFont = Font.pingFangRegular(14)
            clockSegmentedDataSource.titleNormalColor = Color(hexString: "#333333")!
            clockSegmentedDataSource.titleSelectedColor = Color(hexString: "#FFFFFF")!
            clockSegmentedDataSource.itemSpacing = 5
            clockSegmentedDataSource.itemWidth = (UI.SCREEN_WIDTH - 30 - 5*3)/4.0
            clockSegmentedDataSource.isItemSpacingAverageEnabled = false
            clockSegmentedDataSource.isSelectedAnimable = false
            clockSegmentedDataSource.backgroundNormalColor = Color(hexString: "#DEFDFF")!
            clockSegmentedDataSource.backgroundSelectedColor = Color(hexString: "#2BB8C2")!
            clockSegmentedView.dataSource = clockSegmentedDataSource

            clockSegmentedView.reloadData()
            return clockSegmentedView
        }()
        
        self.levelSegmentedView = {
            let levelSegmentedView = JXSegmentedView()
            levelSegmentedView.delegate = self
            levelSegmentedView.backgroundColor = Color(hexString: "#FFFFFF")
            levelSegmentedView.contentEdgeInsetLeft = 0
            levelSegmentedView.contentEdgeInsetRight = 0
            levelSegmentedView.clipsToBounds = true
            let layout = levelSegmentedView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.scrollDirection = .vertical
            levelSegmentedView.collectionView.delegate = self
            levelContainView.addSubview(levelSegmentedView)
            levelSegmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.left.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(0)
                make.height.equalTo(40)
            }
            
            levelSegmentedDataSource = LSSegmentedTitleDataSource()
            levelSegmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
            levelSegmentedDataSource.titleSelectedFont = Font.pingFangRegular(14)
            levelSegmentedDataSource.titleNormalColor = Color(hexString: "#333333")!
            levelSegmentedDataSource.titleSelectedColor = Color(hexString: "#FFFFFF")!
            levelSegmentedDataSource.itemSpacing = 5
            levelSegmentedDataSource.itemWidth = (UI.SCREEN_WIDTH - 30 - 5*3)/4.0
            levelSegmentedDataSource.isItemSpacingAverageEnabled = false
            levelSegmentedDataSource.isSelectedAnimable = false
            levelSegmentedDataSource.backgroundNormalColor = Color(hexString: "#DEFDFF")!
            levelSegmentedDataSource.backgroundSelectedColor = Color(hexString: "#2BB8C2")!
            levelSegmentedView.dataSource = levelSegmentedDataSource

            return levelSegmentedView
        }()
        
        self.sexSegmentedView = {
            let sexSegmentedView = JXSegmentedView()
            sexSegmentedView.delegate = self
            sexSegmentedView.backgroundColor = Color(hexString: "#FFFFFF")
            sexSegmentedView.contentEdgeInsetLeft = 0
            sexSegmentedView.contentEdgeInsetRight = 0
            sexSegmentedView.clipsToBounds = true
            sexContainView.addSubview(sexSegmentedView)
            sexSegmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.left.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(0)
                make.height.equalTo(40)
            }
            
            sexSegmentedDataSource = LSSegmentedTitleDataSource()
            sexSegmentedDataSource.titles = sexModels.map{$0.0}
            sexSegmentedDataSource.titleNormalFont = Font.pingFangRegular(14)
            sexSegmentedDataSource.titleSelectedFont = Font.pingFangRegular(14)
            sexSegmentedDataSource.titleNormalColor = Color(hexString: "#333333")!
            sexSegmentedDataSource.titleSelectedColor = Color(hexString: "#FFFFFF")!
            sexSegmentedDataSource.itemSpacing = 5
            sexSegmentedDataSource.itemWidth = (UI.SCREEN_WIDTH - 30 - 5*3)/4.0
            sexSegmentedDataSource.isItemSpacingAverageEnabled = false
            sexSegmentedDataSource.isSelectedAnimable = false
            sexSegmentedDataSource.backgroundNormalColor = Color(hexString: "#DEFDFF")!
            sexSegmentedDataSource.backgroundSelectedColor = Color(hexString: "#2BB8C2")!
            sexSegmentedView.dataSource = sexSegmentedDataSource

            sexSegmentedView.reloadData()
            return sexSegmentedView
        }()
        
        self.levelSelectedView.font = Font.pingFangRegular(12)
        self.levelSelectedView.placeholder = "选择技师类型"
        self.levelSelectedView.textAlignment = .left
        self.levelSelectedView.downTextAlignment = .center
        self.levelSelectedView.delegate = self
        
        self.sexSelectedView.font = Font.pingFangRegular(12)
        self.sexSelectedView.placeholder = "选择技师性别"
        self.sexSelectedView.textAlignment = .left
        self.sexSelectedView.downTextAlignment = .center
        self.sexSelectedView.delegate = self
        self.sexSelectedView.listArray = sexModels.map{$0.0}
        
        {
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
            tableView.rowHeight = 100
//            tableView.separatorInset = 
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSJSTableViewCell.self)
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSSysUserModel>> { dataSource, tableView, indexPath, element in
                let cell: LSJSTableViewCell = tableView.dequeueReusableCell(withClass: LSJSTableViewCell.self)
                cell.jsImgView.kf.setImage(with: imgUrl(element.imgurl))
                cell.jsNoLab.text = "技号：\(element.code)"
                cell.jsNameLab.text = "名称：\(element.name)"
                cell.jslevelLab.text = "等级：\(element.tlname)"
                cell.selectImgView.isHighlighted = element.code == self.selectJSModel?.code
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            
            tableView.rx.itemSelected.subscribe { [weak self] indexPath in
                guard let self = self else {return}
                self.selectJSModel = self.jsModels[indexPath.row]
                self.items.onNext([SectionModel.init(model: "", items: self.jsModels)])
            }.disposed(by: self.rx.disposeBag)
        }()
    }
    
    override func setupData() {
        self.networkJSLevel()
    }
    func networkJSLevel() {
        Toast.showHUD()
        LSWorkbenchServer.getLevelList().subscribe { listModel in
            self.levelModels = listModel?.list ?? []
            self.levelModels.insert(LSJSLevelModel(name: "不限", tlid: ""), at: 0)
            self.refreshUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)

    }
    
    func networkJS() {
        Toast.showHUD()
        LSWorkbenchServer.userGetList(projectid: self.selectedProjectModel?.projectid ?? "", tlid: self.levelSelectModel.tlid, sex: self.sexSelectModel.1).subscribe { listModel in
            self.jsModels = listModel?.list ?? []
            self.items.onNext([SectionModel.init(model: "", items: self.jsModels)])
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        self.levelSelectedView.listArray = levelModels.map{$0.name}
        self.levelSegmentedDataSource.titles = levelModels.map{$0.name}
        levelSegmentedView.reloadData()
        levelSegmentedView.layoutIfNeeded()
        let contentHeight = levelSegmentedView.collectionView.collectionViewLayout.collectionViewContentSize.height
        levelViewHeight.constant = contentHeight + 40
        levelSegmentedView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
        
    }
}


extension LSChioceTechnicianItemController: JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    func listWillAppear() {
        guard clockSegmentedView.selectedIndex != 0 else { return }
        self.networkJS()
    }
}

extension LSChioceTechnicianItemController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int){
        self.clockSelectModel = self.clockModels[index]
        guard segmentedView == self.clockSegmentedView else {
            if segmentedView == levelSegmentedView {
                self.levelSelectModel = self.levelModels[index]
                self.levelSelectedView.text = self.levelModels[index].name
            }else if segmentedView == sexSegmentedView {
                self.sexSelectModel = self.sexModels[index]
                self.sexSelectedView.text = self.sexModels[index].0
            }
            return
        }
        
        if index != 0 { self.networkJS() }
        let isSelectedWheel = index == 0
        
        selectJSModel = nil
        
        self.levelContainView.isHidden = !isSelectedWheel
        self.sexContainView.isHidden = !isSelectedWheel
        self.levelSelectedView.isHidden = isSelectedWheel
        self.sexSelectedView.isHidden = isSelectedWheel
        self.tableView.isHidden = isSelectedWheel
        
        
    }
}


extension LSChioceTechnicianItemController: HWDownSelectedViewDelegate {
    func downSelectedView(_ selectedView: HWDownSelectedView!, didSelectedAtIndex indexPath: IndexPath!) {
        if selectedView == self.levelSegmentedView {
            self.levelSelectModel = self.levelModels[indexPath.row]
            self.levelSegmentedView.selectItemAt(index: indexPath.row)
        }else if selectedView == self.sexSegmentedView {
            self.sexSelectModel = self.sexModels[indexPath.row]
            self.sexSegmentedView.selectItemAt(index: indexPath.row)
        }
        self.networkJS()
    }
}

extension LSChioceTechnicianItemController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.levelSegmentedView.selectItemAt(index: indexPath.item)
    }
}

extension LSChioceTechnicianItemController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UI.SCREEN_WIDTH - 30 - 5*3)/4.0, height: 40)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
