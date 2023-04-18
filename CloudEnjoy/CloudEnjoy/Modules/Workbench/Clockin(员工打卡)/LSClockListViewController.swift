//
//  LSClockListViewController.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/3/30.
//

import UIKit
import JXSegmentedView
import RxDataSources
import SwifterSwift
import RxSwift
import LSNetwork
import SnapKit

class LSClockListViewController: LSBaseViewController {
    var calender: FSCalendar!
    var workTypeLab: UILabel!
    var workTimeLab: UILabel!
    var workDurationLab: UILabel!
    var tableView: UITableView!

    
    
    var items = PublishSubject<[SectionModel<String, LSPlaceClockModel>]>()

    var punchinDic = [Date: Bool]()
    var placePunchinModel: LSPlacePunchinModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupViews() {
        self.calender = {
            let calendar = FSCalendar(frame: CGRect(x: 10, y: 10, width: UI.SCREEN_WIDTH - 20, height: 250))
            calendar.backgroundColor = UIColor.white
            calendar.cornerRadius = 5
            calendar.dataSource = self
            calendar.delegate = self
            calendar.placeholderType = .none
            calendar.firstWeekday = 2
            calendar.weekdayHeight = 35
            calendar.calendarWeekdayView.backgroundColor = UIColor(hexString: "#F5F5F5")
            calendar.allowsMultipleSelection = false
            let appearance = calendar.appearance
            appearance.titleFont = Font.pingFangRegular(15)
            appearance.weekdayFont = Font.pingFangRegular(13)
            appearance.headerTitleFont = Font.pingFangRegular(18)
            appearance.caseOptions = .weekdayUsesSingleUpperCase
            appearance.weekdayTextColor = Color(hexString: "#999999")!
            appearance.headerTitleColor = Color(hexString: "#010101")!
            appearance.headerDateFormat = "yyyy年MM月"
            appearance.headerMinimumDissolvedAlpha = 0
            appearance.titleDefaultColor = Color(hexString: "#333333")
            appearance.titleSelectionColor = Color(hexString: "#FFFFFF")
            appearance.todayColor = UIColor(patternImage: UIImage(named: "椭圆 3 拷贝 3")!)
            appearance.titleTodayColor = Color(hexString: "#333333")
            appearance.selectionColor = Color(hexString: "#2BC7AF")
            calendar.select(Date())
            view.addSubview(calendar)
            return calendar
        }()
        
        let headerView = {
            let headerView = UIView(frame: CGRectMake(0, 0, UI.SCREEN_WIDTH - 20, 45))
            headerView.backgroundColor = Color.white
            headerView.roundCorners([UIRectCorner.topLeft, UIRectCorner.topRight], radius: 5)

            self.workTypeLab = UILabel()
            workTypeLab.textColor = Color(hexString: "#292929")
            workTypeLab.font = Font.pingFangMedium(16)
            headerView.addSubview(workTypeLab)
            workTypeLab.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
            
            self.workTimeLab = UILabel()
            workTimeLab.textColor = Color(hexString: "#292929")
            workTimeLab.font = Font.pingFangMedium(16)
            headerView.addSubview(workTimeLab)
            workTimeLab.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = headerView.bounds
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.strokeColor = Color(hexString: "#707070")!.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPattern = [NSNumber(value: 2),NSNumber(value: 2)]
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 15, y: 45))
            path.addLine(to: CGPoint(x: headerView.bounds.size.width - 15, y: 45))
            shapeLayer.path = path
            headerView.layer.addSublayer(shapeLayer)
            return headerView
        }()
        
        
        let footerView = {
            let footerView = UIView(frame: CGRectMake(0, 0, UI.SCREEN_WIDTH - 20, 45))
            footerView.roundCorners([UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 5)
            footerView.backgroundColor = Color.white
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = footerView.bounds
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.strokeColor = Color(hexString: "#707070")!.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPattern = [NSNumber(value: 2),NSNumber(value: 2)]
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 15, y: 0))
            path.addLine(to: CGPoint(x: footerView.bounds.size.width - 15, y: 0))
            shapeLayer.path = path
            footerView.layer.addSublayer(shapeLayer)
            
            self.workDurationLab = UILabel()
            workDurationLab.textColor = Color(hexString: "#292929")
            workDurationLab.font = Font.pingFangMedium(16)
            footerView.addSubview(workDurationLab)
            workDurationLab.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
            return footerView
        }()
        
        self.tableView = {
            let tableView = UITableView(frame: CGRect.zero, style: .plain)
            tableView.backgroundColor = Color.clear
            tableView.cornerRadius = 5
            
            tableView.tableFooterView = footerView
            tableView.tableHeaderView = headerView
            tableView.sectionHeaderHeight = 0
            tableView.sectionFooterHeight = 0
            tableView.rowHeight = 100
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            tableView.register(nibWithCellClass: LSVipTableViewCell.self)
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.top.equalTo(self.calender.snp.bottom).offset(7)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview()
            }
            tableView.register(nibWithCellClass: LSClockInTableViewCell.self)
            
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LSPlaceClockModel>> { dataSource, tableView, indexPath, element in
                let cell: LSClockInTableViewCell = tableView.dequeueReusableCell(withClass: LSClockInTableViewCell.self)
                cell.upLineView.isHidden = indexPath.row == 0
                cell.downLineView.isHidden = indexPath.row == ((self.placePunchinModel?.userclocklist.count ?? 0) - 1)
                cell.titleLab.text = element.ctype.clockinString
                cell.clockTimeLab.text = element.clockintime
                cell.clockAddressLab.text = element.adr
                return cell
            }
            items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
            return tableView
        }()
    }
    override func setupData() {
        let placeListSingle = LSWorkbenchServer.getPlacePunchinList(datetime: Date().beginning(of: .month)!.string(withFormat: "yyyy-MM-dd"))
        let dayPlaceSingle = LSWorkbenchServer.getPlacePunchin(datetime: Date().string(withFormat: "yyyy-MM-dd"))
        Observable.zip(placeListSingle.asObservable(), dayPlaceSingle.asObservable()).subscribe { listModel, model in
            listModel?.forEach({ model in
                if let date = model.datetime.date(withFormat: "yyyy-MM-dd hh:mm:ss") {
                    self.punchinDic[date] = model.xbstatus == 1 && model.sbstatus == 1
                }
            })
            self.calender.reloadData()
            self.placePunchinModel = model
            self.refreshUI()
        } onError: { error in
            Toast.show(error.localizedDescription)
        } onCompleted: {
            
        } onDisposed: {
        }.disposed(by: self.rx.disposeBag)
    }
    
    func workData(curretnDate: Date) {
        LSWorkbenchServer.getPlacePunchinList(datetime: curretnDate.beginning(of: .month)!.string(withFormat: "yyyy-MM-dd")).subscribe { listModel in
            listModel?.forEach({ model in
                if let date = model.datetime.date(withFormat: "yyyy-MM-dd hh:mm:ss") {
                    self.punchinDic[date] = model.xbstatus == 1 && model.sbstatus == 1
                }
            })
            self.calender.reloadData()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func refreshUI() {
        guard let model = self.placePunchinModel else {return}
        self.workTypeLab.text = "班次：" + model.shiftname
        self.workTimeLab.text = model.workshift + "-" + model.closingtime
        self.workDurationLab.text = "工作时长：" + (model.offclockintime.date(withFormat: "yyyy-MM-dd hh:mm:ss")?.hoursSince(model.onclockintime.date(withFormat: "yyyy-MM-dd hh:mm:ss") ?? Date()).int.string ?? "0")  + "h"
        items.onNext([SectionModel(model: "", items: model.userclocklist)])
    }
}

extension LSClockListViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.workData(curretnDate: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        Toast.showHUD()
        LSWorkbenchServer.getPlacePunchin(datetime: date.string(withFormat: "yyyy-MM-dd")).subscribe { model in
            self.placePunchinModel = model
            self.refreshUI()
        } onFailure: { error in
            Toast.show(error.localizedDescription)
        } onDisposed: {
            Toast.hiddenHUD()
        }.disposed(by: self.rx.disposeBag)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        guard let isNormal = self.punchinDic[date],
              date.compare(Date().beginning(of: .day)!) == .orderedAscending else {
            return [Color.clear]
        }
        return isNormal ? [Color.cyan] : [Color.red]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        guard let isNormal = self.punchinDic[date],
              date.compare(Date().beginning(of: .day)!) == .orderedAscending else {
            return [Color.clear]
        }
        return isNormal ? [Color.cyan] : [Color.red]
    }
    
}

extension LSClockListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
