//
//  LSProjectAddViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2024/7/18.
//

import UIKit
import LSBaseModules
import SwifterSwift
import RxSwift
import RxDataSources

typealias ProjectAddItemModel = (selectJSModel: LSSysUserModel?, clockSelectModel: LSClockType?, levelSelectModel: LSJSLevelModel?, sexSelectModel: (String, String)?, bedSelectModel: LSBedModel?, handCardModel: LSHandCardModel?, referrerModel: LSSysUserModel?, remark: String?)
let InitProjectAddItemModel: ProjectAddItemModel = (nil, nil, nil, nil, nil, nil, nil, nil)

class LSProjectAddViewController: LSBaseViewController {

    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectNameLab: UILabel!
    
    @IBOutlet weak var projectDurationLab: UILabel!
    
    @IBOutlet weak var projectPriceLab: UILabel!
    
    @IBOutlet weak var numberLab: UILabel!
    @IBOutlet weak var subtractBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = PublishSubject<[SectionModel<String, ProjectAddItemModel>]>()
    var models = [InitProjectAddItemModel]
    
    var number = 1
    
    var roomModel: LSOrderRoomModel? = nil
    var handCardModel: LSHandCardModel? = nil
    var projectModel: LSOrderProjectModel!
    
    convenience init(projectModel: LSOrderProjectModel, roomModel: LSOrderRoomModel? = nil, handCardModel: LSHandCardModel? = nil) {
        self.init()
        self.projectModel = projectModel
        self.roomModel = roomModel
        self.handCardModel = handCardModel
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择技师"
    }
    
    override func setupViews() {
        projectImageView.kf.setImage(with: imgUrl(projectModel.images))
        projectNameLab.text = projectModel.name
        projectDurationLab.text = projectModel.smin + "分钟"
        projectPriceLab.text = "￥" + projectModel.lprice.stringValue(retain: 2)
        
        subtractBtn.isEnabled = number > 1
        
        
        tableView.backgroundColor = Color.clear
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 0.01))
        tableView.sectionHeaderHeight = 7
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = 180
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(nibWithCellClass: LSProjectAddTableViewCell.self)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ProjectAddItemModel>> { dataSource, tableView, indexPath, element in
            let cell: LSProjectAddTableViewCell = tableView.dequeueReusableCell(withClass: LSProjectAddTableViewCell.self)
            if element.clockSelectModel == .wheelClock {
                cell.jsLab1.superview?.isHidden = false
                cell.jsLab2.superview?.isHidden = false
                cell.jsLab3.superview?.isHidden = false
                cell.jsLab1.text = element.clockSelectModel?.clockString
                cell.jsLab2.text = element.levelSelectModel?.name
                cell.jsLab3.text = element.sexSelectModel?.0
            }else if element.selectJSModel != nil {
                cell.jsLab1.superview?.isHidden = false
                cell.jsLab2.superview?.isHidden = false
                cell.jsLab3.superview?.isHidden = true
                cell.jsLab1.text = element.clockSelectModel?.clockString
                cell.jsLab2.text = element.selectJSModel?.name
            }else {
                cell.jsLab1.superview?.isHidden = true
                cell.jsLab2.superview?.isHidden = true
                cell.jsLab3.superview?.isHidden = true
            }
            cell.jsPlaceholderLab.isHidden = element.clockSelectModel != nil
            
            cell.bedTextField.text = element.bedSelectModel?.name
            cell.handCardTextField.text = element.handCardModel?.name
            cell.referrerTextField.text = element.referrerModel?.name
            cell.remarkTextField.text = element.remark
            
            
            cell.jsView.rx.tapGesture().when(.recognized).subscribe { [weak self, weak cell] _ in
                guard let self = self,
                    let cell = cell else {return}
                let choiceRoomVC = LSChioceContainerViewController.creaeFromStoryboard(chioceType: .js, selectRoomModel: self.roomModel, selectProjectModel: self.projectModel, selectJSModel: element.selectJSModel, clockSelectModel: element.clockSelectModel, levelSelectModel: element.levelSelectModel, sexSelectModel: element.sexSelectModel)
                choiceRoomVC.selectedClosure = { (selectRoomModel, selectProjectModel, selectJSModel, clockSelectModel, levelSelectModel, sexSelectModel) in
                    if  let _ = selectProjectModel {
                        let clockSelectModel = clockSelectModel ?? .wheelClock
                        let levelSelectModel = levelSelectModel ?? .init(name: "不限", tlid: "")
                        let sexSelectModel = sexSelectModel ?? ("不限", "")
                        
                        cell.jsPlaceholderLab.isHidden = true
                        
                        if clockSelectModel == .wheelClock {
                            cell.jsLab1.superview?.isHidden = false
                            cell.jsLab2.superview?.isHidden = false
                            cell.jsLab3.superview?.isHidden = false
                            cell.jsLab1.text = clockSelectModel.clockString
                            cell.jsLab2.text = levelSelectModel.name
                            cell.jsLab3.text = sexSelectModel.0
                        }else if let jSModel = selectJSModel {
                            cell.jsLab1.superview?.isHidden = false
                            cell.jsLab2.superview?.isHidden = false
                            cell.jsLab3.superview?.isHidden = true
                            cell.jsLab1.text = clockSelectModel.clockString
                            cell.jsLab2.text = jSModel.name
                        }else {
                            cell.jsLab1.superview?.isHidden = true
                            cell.jsLab2.superview?.isHidden = true
                            cell.jsLab3.superview?.isHidden = true
                        }
                        
                        var changeElement = element
                        changeElement.selectJSModel = selectJSModel
                        changeElement.selectJSModel = selectJSModel
                        changeElement.clockSelectModel = clockSelectModel
                        changeElement.levelSelectModel = levelSelectModel
                        changeElement.sexSelectModel = sexSelectModel
                        self.models[indexPath.section] = changeElement
                    }
                }
                choiceRoomVC.presentedWith(self)
            }.disposed(by: cell.rx.reuseBag)
            
            cell.referrerView.rx.tapGesture().when(.recognized).subscribe { [weak self, weak cell] _ in
                guard let self = self,
                    let cell = cell else {return}
                let referrerVC = LSReferrerViewController.creaeFromStoryboard(with: element.referrerModel)
                referrerVC.selectedClosure = { referrerModel in
                    var changeElement = element
                    changeElement.referrerModel = referrerModel
                    self.models[indexPath.section] = changeElement
                    cell.referrerTextField.text = referrerModel.name
                }
                referrerVC.presentedWith(self)
            }.disposed(by: cell.rx.reuseBag)
            
            cell.remarkTextField.rx.text.subscribe { [weak self, weak cell] text in
                guard let self = self,
                    let cell = cell else {return}
                var changeElement = element
                changeElement.remark = text
                self.models[indexPath.section] = changeElement
            }.disposed(by: cell.rx.reuseBag)
            
            
            
            return cell
        }
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        let sectionModels = self.models.map{ SectionModel(model: "", items: [$0])}
        self.items.onNext(sectionModels)
    }

    @IBAction func subtractAction(_ sender: Any) {
        number -= 1
        self.subtractBtn.isEnabled = number > 1
        self.numberLab.text = number.string

        models.removeLast()
        let sectionModels = models.map{ SectionModel(model: "", items: [$0])}
        items.onNext(sectionModels)
    }
    
    @IBAction func plusAction(_ sender: Any) {
        number += 1
        self.subtractBtn.isEnabled = number > 1
        self.numberLab.text = number.string
        
        models.append(InitProjectAddItemModel)
        let sectionModels = models.map{ SectionModel(model: "", items: [$0])}
        items.onNext(sectionModels)
    }
    
}
