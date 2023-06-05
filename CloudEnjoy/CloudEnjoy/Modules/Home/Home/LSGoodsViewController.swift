//
//  LSGoodsViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/4/7.
//

import UIKit
import LSBaseModules
import SwifterSwift
import RxSwift
import RxDataSources

class LSGoodsViewController: LSBaseViewController {
        
    @IBOutlet weak var searchGoodsTextField: UITextField!
    @IBOutlet weak var roomNameLab: UILabel!
    @IBOutlet weak var bedTitleLab: UILabel!
    @IBOutlet weak var bedNoLab: UILabel!
    @IBOutlet weak var refNameLab: UILabel!
    @IBOutlet weak var refNameView: UIView!
    @IBOutlet weak var remarkTextField: UITextField!
    
    var tableView: UITableView!
    var goodsTypeItems = PublishSubject<[SectionModel<String, LSGoodsTypeModel>]>()
    var collectionView: UICollectionView!
    var headerTypeItems = PublishSubject<[SectionModel<String, LSGoodsTypeModel>]>()
    var goodsTableView: UITableView!
    var goodsItems = PublishSubject<[SectionModel<String, LSGoodsModel>]>()

    
    var projectModel: LSHomeProjectModel!
    var goodsTypeModels: [LSGoodsTypeModel]?
    var goodsTypeModels2: [LSGoodsTypeModel]?
    
    var allGoodsModels: [LSGoodsModel]?
    var selectedTypeGoodsModels: [LSGoodsModel]?

    var selectedTypeModel: LSGoodsTypeModel?
    var selectedTypeModel2: LSGoodsTypeModel?

    var referrerModel: LSSysUserModel = LSSysUserModel()

    convenience init(with projectModel: LSHomeProjectModel) {
        self.init()
        self.projectModel = projectModel
        self.referrerModel = LSSysUserModel(userid: projectModel.refid, name: projectModel.refname, jobid: projectModel.jobid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商品下单"
    }
    
    override func setupViews() {
        self.roomNameLab.text = projectModel.roomname
        self.bedTitleLab.text = parametersModel().OperationMode == 0 ? "床位号" : "手牌号"
        self.bedNoLab.text =  parametersModel().OperationMode == 0 ? projectModel.bedname : projectModel.handcardno
        self.refNameLab.text = projectModel.refname
        
        self.refNameView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else {return}
            let referrerVC = LSReferrerViewController.creaeFromStoryboard(with: self.referrerModel)
            referrerVC.referrerModel = self.referrerModel
            referrerVC.selectedClosure = { referrerModel in
                self.referrerModel = referrerModel
                self.refNameLab.text = referrerModel.name
            }
            referrerVC.presentedWith(self)
        }.disposed(by: self.rx.disposeBag)
        
        self.tableView = {
            let tableView = UITableView(frame: CGRect.zero, style: .plain)
            tableView.backgroundColor = Color.clear
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 85, height: 0.01))
            tableView.sectionHeaderHeight = 0
            tableView.sectionFooterHeight = 0
            tableView.separatorStyle = .none
            tableView.rowHeight = 46
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSGoodsTypeTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.width.equalTo(85)
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 48 + 5)
                make.bottom.equalToSuperview().offset(-UI.BOTTOM_HEIGHT - 245 - 25)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSGoodsTypeModel>> { dataSource, tableView, indexPath, element in
                let cell: LSGoodsTypeTableViewCell = tableView.dequeueReusableCell(withClass: LSGoodsTypeTableViewCell.self)
                cell.titleLab.text = indexPath.row == 0 ? "全部商品" : element.name
                cell.bgView.backgroundColor = element.typeid == self.selectedTypeModel?.typeid ? Color(hexString: "#00AAB6") : Color.white
                cell.titleLab.textColor = element.typeid == self.selectedTypeModel?.typeid ? Color.white : Color.black
                cell.numberView.isHidden = element.number <= 0
                cell.numberLab.text = element.number.string
                return cell
            }
            goodsTypeItems.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
                guard let self = self,
                      let model = self.goodsTypeModels?[indexPath.row] else {return}
                self.selectedTypeModel = model
                self.goodsTypeModels2 = (model.children.isEmpty || model.typeid == "0") ? [] : ([model] + model.children)
                self.selectedTypeModel2 = model
                self.refreshTypeUI()
                self.selectedTypeGoodsModels = (indexPath.row == 0 ? self.allGoodsModels : self.allGoodsModels?.filter{$0.typeid == model.typeid})
                if let key = self.searchGoodsTextField.text,
                   key.isEmpty == false {
                    self.selectedTypeGoodsModels = self.selectedTypeGoodsModels?.filter{$0.name.contains(key)}
                }
                let sectionModels = self.selectedTypeGoodsModels?.map{SectionModel(model: "", items: [$0])} ?? [SectionModel(model: "", items: [])]
                self.goodsItems.onNext(sectionModels)
            }).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
        self.collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: (UI.SCREEN_WIDTH - 102 - 10 - 8 * 2)/3, height: 32)
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            let collectionView =  UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.clear
            collectionView.isScrollEnabled = false
            collectionView.register(nibWithCellClass:LSGoodsTypeCollectionViewCell.self)
            self.view.addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(102)
                make.right.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 48 + 5 + 3)
                make.height.equalTo(10)
            }
            let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, LSGoodsTypeModel>> { [weak self] dataSource, collectionView, indexPath, element in
                let cell = collectionView.dequeueReusableCell(withClass: LSGoodsTypeCollectionViewCell.self, for: indexPath)
                cell.titleLab.text = indexPath.row == 0 ? "全部商品" : element.name
                cell.bgView.backgroundColor = element.typeid == self?.selectedTypeModel2?.typeid ? Color(hexString: "#00AAB6") : Color.white
                cell.titleLab.textColor = element.typeid == self?.selectedTypeModel2?.typeid ? Color.white : Color(hexString: "#666666")
                return cell
            }
            headerTypeItems.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            
            collectionView.rx.modelSelected(LSGoodsTypeModel.self).subscribe(onNext: {[weak self] model in
                guard let self = self else {return}
                self.selectedTypeModel2 = model
                self.collectionView.reloadData()
                self.selectedTypeGoodsModels = self.allGoodsModels?.filter{$0.typeid == model.typeid}
                if let key = self.searchGoodsTextField.text,
                   key.isEmpty == false {
                    self.selectedTypeGoodsModels = self.selectedTypeGoodsModels?.filter{$0.name.contains(key)}
                }
                let sectionModels = self.selectedTypeGoodsModels?.map{SectionModel(model: "", items: [$0])} ?? [SectionModel(model: "", items: [])]
                self.goodsItems.onNext(sectionModels)
            }).disposed(by: self.rx.disposeBag)
            
            return collectionView
        }()
        
        self.goodsTableView = {
            var goodsTableView = UITableView(frame: CGRect.zero, style: .grouped)
            var leftSpace = 16
            if #available(iOS 13.0, *) {
                leftSpace = 0
                goodsTableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
            }
            goodsTableView.backgroundColor = Color.clear
            goodsTableView.tableFooterView = UIView()
            goodsTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH - 92, height: 0.01))
            goodsTableView.sectionHeaderHeight = 6
            goodsTableView.sectionFooterHeight = 0
            goodsTableView.showsVerticalScrollIndicator = false
            goodsTableView.separatorStyle = .none
            goodsTableView.rowHeight = 78
            if #available(iOS 15.0, *) {
                goodsTableView.sectionHeaderTopPadding = 0
            }
            goodsTableView.register(nibWithCellClass: LSGoodsTableViewCell.self)
            view.addSubview(goodsTableView)
            goodsTableView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(92 + leftSpace)
                make.right.equalToSuperview().offset(-leftSpace)
                make.top.equalTo(self.collectionView.snp.bottom).offset(3)
                make.bottom.equalToSuperview().offset(-UI.BOTTOM_HEIGHT - 245 - 10)
            }

            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSGoodsModel>> { dataSource, tableView, indexPath, element in
                let cell: LSGoodsTableViewCell = tableView.dequeueReusableCell(withClass: LSGoodsTableViewCell.self)
                cell.goodsPicImageView.kf.setImage(with: imgUrl(element.imageurl))
                cell.goodsNameLab.text = element.name
                cell.goodsStockLab.text = "库存：" + element.stockqty.string
                cell.goodsPriceLab.text = "￥" + element.sellprice.stringValue(retain: 2)
                cell.goodsNumberLab.text = element.number.string
                cell.goodsNumberLab.isHidden = element.number == 0
                cell.subtractBtn.isHidden = element.number == 0
                cell.subtractBtn.rx.tap.subscribe { [weak self, weak cell] _ in
                    guard let self = self,
                          let cell = cell else {return}
                    guard let number = cell.goodsNumberLab.text?.int,
                          number >= 1 else {
                        return
                    }
                    element.number -= 1
                    
                    let allType = self.goodsTypeModels?.first
                    allType?.number -= 1
                    if allType?.typeid != self.selectedTypeModel?.typeid {
                        self.selectedTypeModel?.number -= 1
                    }else {
                        self.goodsTypeModels?.first{$0.typeid == element.typeid}?.number -= 1
                    }
                    
                    self.tableView.reloadData()
                    self.goodsTableView.reloadData()
                }.disposed(by: cell.rx.reuseBag)
                
                cell.plusBtn.rx.tap.subscribe { [weak self, weak cell] _ in
                    guard let self = self,
                          let cell = cell else {return}
                    guard let number = cell.goodsNumberLab.text?.int,
                          number < element.stockqty  else {
                        return
                    }
                    element.number += 1
                    
                    let allType = self.goodsTypeModels?.first
                    allType?.number += 1
                    if allType?.typeid != self.selectedTypeModel?.typeid {
                        self.selectedTypeModel?.number += 1
                    }else {
                        self.goodsTypeModels?.first{$0.typeid == element.typeid}?.number += 1
                    }
                    self.tableView.reloadData()
                    self.goodsTableView.reloadData()
                }.disposed(by: cell.rx.reuseBag)
                return cell
            }
            goodsItems.bind(to: goodsTableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            return goodsTableView
        }()
       
        
    }
    
    override func setupData() {
        Toast.showHUD()
        LSHomeServer.getGoodsTypeList(spid: storeModel().spid.string, sid: storeModel().sid.string).subscribe { goodsTypeModel in
            guard let goodsTypeModel = goodsTypeModel else{
                return
            }
            self.goodsTypeModels = [goodsTypeModel] + goodsTypeModel.children
            self.goodsTypeModels2 = []
            self.selectedTypeModel = goodsTypeModel
            self.selectedTypeModel2 = goodsTypeModel
            self.refreshTypeUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)

        LSHomeServer.getProductList(spid: storeModel().spid.string, sid: storeModel().sid.string, is_page: "0", page: "1", typeid: "0", itemstatus: "0", name: "", quick: "1").subscribe { listModel in
            self.allGoodsModels = listModel?.list.filter{$0.stockqty > 0 || ($0.stockqty <= 0 && parametersModel().OverStockPerSale != 3)}
            self.selectedTypeGoodsModels = self.allGoodsModels
            let sectionModels = self.selectedTypeGoodsModels?.map{SectionModel(model: "", items: [$0])} ?? [SectionModel(model: "", items: [])]
            self.goodsItems.onNext(sectionModels)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshTypeUI() {
        self.goodsTypeItems.onNext([SectionModel(model: "", items: self.goodsTypeModels!)])
        self.headerTypeItems.onNext([SectionModel(model: "", items: self.goodsTypeModels2!)])
        self.collectionView.layoutIfNeeded()
        self.collectionView.snp.updateConstraints { make in
            make.height.equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
    }
    
    @IBAction func searchGoodsAction(_ sender: Any) {
        guard let key = self.searchGoodsTextField.text,
            key.isEmpty == false  else {
            return
        }
        self.selectedTypeGoodsModels = self.selectedTypeGoodsModels?.filter{$0.name.contains(key)}
        let sectionModels = self.selectedTypeGoodsModels?.map{SectionModel(model: "", items: [$0])} ?? [SectionModel(model: "", items: [])]
        self.goodsItems.onNext(sectionModels)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let goodsModels = self.allGoodsModels?.filter({$0.number > 0}),
              goodsModels.isEmpty == false else {
            Toast.show("请选择商品后，再下单")
            return
        }
        guard self.referrerModel.userid.isEmpty == false else {
            Toast.show("请选择推荐人")
            return
        }
        let productlist = goodsModels.map{["productid": $0.productid,
                                           "qty": $0.number,
                                           "amt": ($0.sellprice ?? 0) * $0.number.double,
                                           "price": $0.sellprice,
                                           "productname": $0.name,
                                           "rprice": $0.sellprice]}.ls_toJSONString() ?? ""
        Toast.showHUD()
        LSHomeServer.addProduct(billid: self.projectModel.billid, roomid: self.projectModel.roomid, bedid: self.projectModel.bedid, refid: self.referrerModel.userid, refname: self.referrerModel.name, refjobid: self.referrerModel.jobid, productlist: productlist, remark: remarkTextField.text ?? "").subscribe { _ in
            Toast.show("商品已下单成功")
            self.navigationController?.popViewController(animated: true)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    
    
}



