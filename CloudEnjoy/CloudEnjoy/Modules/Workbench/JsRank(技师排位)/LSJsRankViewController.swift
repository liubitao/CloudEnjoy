//
//  LSJsRankViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/21.
//

import UIKit
import RxSwift
import RxDataSources
import LSBaseModules

class LSJsRankViewController: LSBaseViewController {

    
    @IBOutlet weak var jobDownSelectedView: HWDownSelectedView!
    @IBOutlet weak var shiftDownSelectedView: HWDownSelectedView!
    
    @IBOutlet weak var mineRankView: UIView!
    
    @IBOutlet weak var rankView: UIView!
    
    @IBOutlet weak var rankLab: UILabel!
    
    @IBOutlet weak var shiftLab: UILabel!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var jobLab: UILabel!
    
    @IBOutlet weak var jobStateLab: UILabel!
    
    @IBOutlet weak var jobDescLab: UILabel!
    
    @IBOutlet weak var mineViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var items = PublishSubject<[SectionModel<String, LSRankJSModel>]>()
    var jsModels = [LSRankJSModel]()
    
    
    var jobModels = [LSSysJobModel]()
    var shiftModels = [LSShiftModel]()
    
    var currentJob: LSSysJobModel?
    var currentshift: LSShiftModel?
    
    
    let rankColors = ["#2BB8C2", "#FF0000", "#FF6F00", "#0066FF", ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "技师排位"
    }
    
    
    override func setupViews() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.mineRankView.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = UIColor(hexString: "#707070")!.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [NSNumber(value: 2),NSNumber(value: 2)]
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 15, y: 77))
        path.addLine(to: CGPoint(x: UI.SCREEN_WIDTH - 30, y: 77))
        shapeLayer.path = path
        self.mineRankView.layer.addSublayer(shapeLayer)
    
        self.jobDownSelectedView.font = Font.pingFangRegular(12)
        self.jobDownSelectedView.backgroundColor = UIColor.clear
        self.jobDownSelectedView.isBorder = false
        self.jobDownSelectedView.placeholder = "岗位"
        self.jobDownSelectedView.textAlignment = .center
        self.jobDownSelectedView.downTextAlignment = .center
        self.jobDownSelectedView.delegate = self
        
        self.shiftDownSelectedView.font = Font.pingFangRegular(12)
        self.shiftDownSelectedView.backgroundColor = UIColor.clear
        self.shiftDownSelectedView.isBorder = false
        self.shiftDownSelectedView.placeholder = "班次"
        self.shiftDownSelectedView.textAlignment = .center
        self.shiftDownSelectedView.downTextAlignment = .center
        self.shiftDownSelectedView.delegate = self
        
        let tableHeaderView: UIView = {
            let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UI.SCREEN_WIDTH, height: 38))
            tableHeaderView.backgroundColor = UIColor.clear
            let titleLab = UILabel(frame: CGRectMake(14, 10, 100, 19))
            titleLab.text = "技师排位"
            titleLab.font = UIFont.systemFont(ofSize: 13)
            titleLab.textColor = UIColor(hexString: "#333333")
            tableHeaderView.addSubview(titleLab)
            return tableHeaderView
        }()

        do {
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = tableHeaderView
            tableView.rowHeight = 51
            tableView.sectionFooterHeight = 5
            tableView.sectionHeaderHeight = 0
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSJsRankTableViewCell.self)
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSRankJSModel>> {[weak self] dataSource, tableView, indexPath, element in
                let cell: LSJsRankTableViewCell = tableView.dequeueReusableCell(withClass: LSJsRankTableViewCell.self)
                guard let self = self else{ return cell }
                cell.rankView.cornerRadius = 12
                cell.rankView.borderColor = UIColor(hexString: self.rankColors[element.isort <= 3 ? element.isort : 0])
                cell.rankView.borderWidth = 1
                cell.rankLab.textColor = UIColor(hexString: self.rankColors[element.isort <= 3 ? element.isort : 0])
                cell.rankLab.text = element.isort.string
                cell.shiftLab.text = element.workname
                cell.nameLab.text = element.name
                cell.jobLab.text =  element.techlevelname.isEmpty ? "" : "(\(element.techlevelname))"
                cell.jobStateLab.text = element.statusDes
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        }
    }
    
    override func setupData() {
        let getSysJobObservable = LSWorkbenchServer.getSysJobList().asObservable()
        let getShiftObservable = LSWorkbenchServer.getShiftList().asObservable()
        let getUserObservable = LSWorkbenchServer.getArtificerList(code: userModel().code).asObservable().map{$0?.last}
        Observable.zip(getSysJobObservable, getShiftObservable, getUserObservable).subscribe {[weak self] (jobListModel, shiftListModel, userModel) in
            guard let jobModels = jobListModel?.list,
                  let shiftModels = shiftListModel?.list,
                  let userModel = userModel,
                  let self = self else{
                return
            }
            self.jobModels = jobModels
            self.shiftModels = shiftModels
            self.jobDownSelectedView.listArray = jobModels.map{$0.name}
            self.shiftDownSelectedView.listArray = shiftModels.map{$0.name}
            self.currentJob = jobModels.first(where: {$0.jobid == userModel.jobid})
            self.currentshift = shiftModels.first(where: {$0.shiftid == userModel.shiftid})
            self.jobDownSelectedView.text = self.currentJob?.name
            self.shiftDownSelectedView.text = self.currentshift?.name
            self.networkJS()
        } onError: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
        }.disposed(by: self.rx.disposeBag)
    }
    
    func networkJS() {
        let jobid = self.currentJob?.jobid ?? ""
        let shiftid = self.currentshift?.shiftid ?? ""
        LSWorkbenchServer.getArtificerList(jobid: jobid, shiftid: shiftid).subscribe { jsModels in
            guard let models = jsModels else {return}
            self.jsModels = models
            self.refreshUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        let sectionModels = self.jsModels.map{SectionModel.init(model: "", items: [$0])}
        self.items.onNext(sectionModels)
        
        if let mineModel = self.jsModels.first(where: {$0.userid == userModel().userid}) {
            self.mineRankView.isHidden = false
            self.mineViewHeight.constant = 120
            self.rankView.cornerRadius = 12
            self.rankView.borderColor = UIColor(hexString: rankColors[mineModel.isort <= 3 ? mineModel.isort : 0])
            self.rankView.borderWidth = 1
            self.rankLab.textColor = UIColor(hexString: rankColors[mineModel.isort <= 3 ? mineModel.isort : 0])
            self.rankLab.text = mineModel.isort.string
            self.shiftLab.text = mineModel.workname
            self.nameLab.text = mineModel.name
            self.jobLab.text = mineModel.techlevelname.isEmpty ? "" : "(\(mineModel.techlevelname))"
            self.jobDescLab.text = mineModel.userclock
        }else {
            self.mineRankView.isHidden = true
            self.mineViewHeight.constant = 0
        }
    }
}

extension LSJsRankViewController: HWDownSelectedViewDelegate {
    func downSelectedView(_ selectedView: HWDownSelectedView!, didSelectedAtIndex indexPath: IndexPath!) {
        if selectedView == self.jobDownSelectedView {
            self.currentJob = self.jobModels[indexPath.row]
        }else if selectedView == self.shiftDownSelectedView {
            self.currentshift = self.shiftModels[indexPath.row]
        }
        self.networkJS()
    }
}

