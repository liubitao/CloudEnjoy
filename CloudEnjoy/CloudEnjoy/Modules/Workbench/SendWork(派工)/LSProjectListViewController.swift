//
//  LSProjectListViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/18.
//

import UIKit
import LSBaseModules
import SwifterSwift
import RxSwift
import RxDataSources

class LSProjectListViewController: LSBaseViewController {
    
    @IBOutlet weak var searchProjectTextField: UITextField!
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var roomNameLab: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cartCalculateLab: UILabel!
    @IBOutlet weak var cartBtn: UIButton!
    var tableView: UITableView!
    var projectTypeItems = PublishSubject<[SectionModel<String, LSProjectTypeModel>]>()
    var projectTableView: UITableView!
    var projectsItems = PublishSubject<[SectionModel<String, LSOrderProjectModel>]>()
    
    var projectTypeModels: [LSProjectTypeModel]?
    var allProjectModels: [LSOrderProjectModel]?
    var selectedTypeModel: LSProjectTypeModel?
    var selectedTypeProjectModels: [LSOrderProjectModel]?
    
    var roomModel: LSOrderRoomModel? = nil
    var handCardModel: LSHandCardModel? = nil
    
    convenience init(roomModel: LSOrderRoomModel? = nil, handCardModel: LSHandCardModel? = nil) {
        self.init()
        self.roomModel = roomModel
        self.handCardModel = handCardModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "派工"
    }
    
    override func setupViews() {
        self.roomView.isHidden = parametersModel().OperationMode != .roomAndBed
      
        self.roomNameLab.text = roomModel?.name ?? ""
        
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
            tableView.register(nibWithCellClass: LSProjectTypeTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.width.equalTo(85)
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 48 + 5)
                make.bottom.equalTo(stackView.snp.top).offset(-10)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSProjectTypeModel>> { dataSource, tableView, indexPath, element in
                let cell: LSProjectTypeTableViewCell = tableView.dequeueReusableCell(withClass: LSProjectTypeTableViewCell.self)
                cell.titleLab.text = element.name
                cell.bgView.backgroundColor = element.projecttypeid == self.selectedTypeModel?.projecttypeid ? Color(hexString: "#00AAB6") : Color.white
                cell.titleLab.textColor = element.projecttypeid == self.selectedTypeModel?.projecttypeid ? Color.white : Color.black
                return cell
            }
            projectTypeItems.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
                guard let self = self,
                      let model = self.projectTypeModels?[indexPath.row] else {return}
                self.selectedTypeModel = model
                self.refreshTypeUI()
                self.selectedTypeProjectModels = (indexPath.row == 0 ? self.allProjectModels : self.allProjectModels?.filter{$0.projecttypeid == model.projecttypeid || model.projecttypeid.isEmpty})
                if let key = self.searchProjectTextField.text,
                   key.isEmpty == false {
                    self.selectedTypeProjectModels = self.selectedTypeProjectModels?.filter{$0.name.contains(key)}
                }
                let sectionModels = self.selectedTypeProjectModels?.map{SectionModel(model: "", items: [$0])} ?? [SectionModel(model: "", items: [])]
                self.projectsItems.onNext(sectionModels)
            }).disposed(by: self.rx.disposeBag)
            return tableView
        }()
        
        self.projectTableView = {
            var projectTableView = UITableView(frame: CGRect.zero, style: .grouped)
            var leftSpace = 16
            if #available(iOS 13.0, *) {
                leftSpace = 0
                projectTableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
            }
            projectTableView.backgroundColor = Color.clear
            projectTableView.tableFooterView = UIView()
            projectTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH - 92, height: 0.01))
            projectTableView.sectionHeaderHeight = 6
            projectTableView.sectionFooterHeight = 0
            projectTableView.showsVerticalScrollIndicator = false
            projectTableView.separatorStyle = .none
            projectTableView.rowHeight = 78
            if #available(iOS 15.0, *) {
                projectTableView.sectionHeaderTopPadding = 0
            }
            projectTableView.register(nibWithCellClass: LSProjectTableViewCell.self)
            view.addSubview(projectTableView)
            projectTableView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(92 + leftSpace)
                make.right.equalToSuperview().offset(-leftSpace)
                make.top.equalToSuperview().offset(UI.STATUS_NAV_BAR_HEIGHT + 48 + 5)
                make.bottom.equalTo(stackView.snp.top).offset(-10)
            }
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSOrderProjectModel>> {[weak self] dataSource, tableView, indexPath, element in
                let cell: LSProjectTableViewCell = tableView.dequeueReusableCell(withClass: LSProjectTableViewCell.self)
                guard let self = self else {
                    return cell
                }
                cell.projectPicImageView.kf.setImage(with: imgUrl(element.images))
                cell.projectNameLab.text = element.name
                cell.projectDurationLab.text = element.smin + "分钟"
                cell.projectPriceLab.text = "￥" + element.lprice.stringValue(retain: 2)
                cell.plusBtn.rx.tap.subscribe(onNext: { [weak self] _ in
                    guard let self = self else {return}
                    let vc = LSProjectAddViewController(projectModel: element, roomModel: self.roomModel, handCardModel: self.handCardModel)
                    self.navigationController?.pushViewController(vc)
                }).disposed(by: cell.rx.reuseBag)
                
                return cell
            }
            projectsItems.bind(to: projectTableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            return projectTableView
        }()
        
        
    }
    
    override func setupData() {
        Toast.showHUD()
        LSWorkbenchServer.getProjecttypeList().subscribe { projectTypeModel in
            let defaultSelectedTypeModel = LSProjectTypeModel(name: "全部项目")
            self.projectTypeModels = [LSProjectTypeModel(name: "全部项目")] + (projectTypeModel?.list ?? [])
            self.selectedTypeModel = defaultSelectedTypeModel
            self.refreshTypeUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
        
        LSWorkbenchServer.getProjectinfoList().subscribe { listModel in
            self.allProjectModels = listModel?.list ?? []
            self.selectedTypeProjectModels = self.allProjectModels
            let sectionModels = self.selectedTypeProjectModels?.map{SectionModel(model: "", items: [$0])} ?? [SectionModel(model: "", items: [])]
            self.projectsItems.onNext(sectionModels)
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshTypeUI() {
        self.projectTypeItems.onNext([SectionModel(model: "", items: self.projectTypeModels!)])
    }
    
    @IBAction func searchGoodsAction(_ sender: Any) {
        guard let selectedTypeModel = self.selectedTypeModel else {
            return
        }
        self.selectedTypeProjectModels = self.allProjectModels?.filter{$0.projecttypeid == selectedTypeModel.projecttypeid || selectedTypeModel.projecttypeid.isEmpty}
        if let key = self.searchProjectTextField.text,
            key.isEmpty == false {
            self.selectedTypeProjectModels = self.selectedTypeProjectModels?.filter{$0.name.contains(key)}
        }
        let sectionModels = self.selectedTypeProjectModels?.map{SectionModel(model: "", items: [$0])} ?? [SectionModel(model: "", items: [])]
        self.projectsItems.onNext(sectionModels)
    }
    
    
    @IBAction func cartAction(_ sender: Any) {
        
    }
    
    @IBAction func confirmAction(_ sender: Any) {
//        guard let goodsModels = self.allGoodsModels?.filter({$0.number > 0}),
//              goodsModels.isEmpty == false else {
//            Toast.show("请选择商品后，再下单")
//            return
//        }
//        guard self.referrerModel.userid.isEmpty == false else {
//            Toast.show("请选择推荐人")
//            return
//        }
//        let productlist = goodsModels.map{["productid": $0.productid,
//                                           "qty": $0.number,
//                                           "amt": $0.sellprice * $0.number.double,
//                                           "price": $0.sellprice,
//                                           "productname": $0.name,
//                                           "rprice": $0.sellprice]}.ls_toJSONString() ?? ""
//        Toast.showHUD()
//        LSHomeServer.addProduct(billid: self.projectModel.billid, roomid: self.projectModel.roomid, bedid: self.projectModel.bedid, refid: self.referrerModel.userid, refname: self.referrerModel.name, refjobid: self.referrerModel.jobid, productlist: productlist, remark: remarkTextField.text ?? "").subscribe { _ in
//            Toast.show("商品已下单成功")
//            self.navigationController?.popViewController(animated: true)
//        } onFailure: { error in
//            Toast.show(error.localizedDescription)
//        } onDisposed: {
//            Toast.hiddenHUD()
//        }.disposed(by: self.rx.disposeBag)
    }
    
    
    
}



