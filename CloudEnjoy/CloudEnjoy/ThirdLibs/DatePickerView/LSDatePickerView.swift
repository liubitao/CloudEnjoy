//
//  LSDatePickerView.swift
//  DatePicker


import UIKit
import SnapKit
import SwifterSwift

fileprivate let kSCREEN_WIDTH = UIScreen.main.bounds.size.width

enum DatePickerStyle {
    case KDatePickerDate    //年月日
    case KDatePickerTime    //年月日时分
    case KDatePickerSecond  //秒
}

class LSDatePickerView: UIView {
    
    fileprivate var datePickerStyle:DatePickerStyle!
    
    fileprivate var unitFlags:Set<Calendar.Component>!
    
    
    fileprivate var pickerView = UIPickerView()
    
    var currentDate: Date {
        set {
            let  calendar0 = Calendar.init(identifier: .gregorian)//公历
            var comps = DateComponents()//一个封装了具体年月日、时秒分、周、季度等的类
            unitFlags = [.year , .month , .day ]
            
            switch datePickerStyle{
            case .KDatePickerDate:
                break
            case .KDatePickerTime:
                unitFlags = [.year , .month , .day , .hour , .minute ]
            case .KDatePickerSecond:
                unitFlags = [.year , .month , .day , .hour , .minute ,.second]
            default:
                break
            }
            
            comps = calendar0.dateComponents(unitFlags, from: newValue)
            
            startYear = comps.year!
            dayRange = self.isAllDay(year: startYear, month: 1)
            yearRange = 2;
            selectedYear = comps.year ?? 0;
            selectedMonth = comps.month ?? 0;
            selectedDay = comps.day ?? 0;
            selectedHour = comps.hour ?? 0;
            selectedMinute = comps.minute ?? 0;
            selectedSecond = comps.second ?? 0;
        }
        get {
            let selectedMonthFormat = String(format:"%.2d",selectedMonth)
            
            let selectedDayFormat = String(format:"%.2d",selectedDay)
            
            let selectedHourFormat = String(format:"%.2d",selectedHour)
            
            let selectedMinuteFormat = String(format:"%.2d",selectedMinute)
            
            let selectedSecondFormat = String(format:"%.2d",selectedSecond)
            
            switch datePickerStyle {
            case .KDatePickerDate:
                let dateStr = "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat)"
                return dateStr.date(withFormat: "yyyy-MM-dd") ?? Date()
            case .KDatePickerTime:
                let dateStr = "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat) \(selectedHourFormat):\(selectedMinuteFormat)"
                return dateStr.date(withFormat: "yyyy-MM-dd hh:mm") ?? Date()
            case .KDatePickerSecond:
                let dateStr = "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat) \(selectedHourFormat):\(selectedMinuteFormat):\(selectedSecondFormat)"
                return dateStr.date(withFormat: "yyyy-MM-dd hh:mm:ss") ?? Date()
            default:
                let dateStr = "\(selectedYear)-\(selectedMonthFormat)-\(selectedDayFormat) \(selectedHourFormat):\(selectedMinuteFormat)"
                return dateStr.date(withFormat: "yyyy-MM-dd hh:mm") ?? Date()
            }
        }
    }
    
    //数据相关
    fileprivate var yearRange = 2//年的范围
    fileprivate var dayRange = 0 //
    fileprivate var startYear = 0
    
    fileprivate var selectedYear = 0;
    fileprivate var selectedMonth = 0;
    fileprivate var selectedDay = 0;
    fileprivate var selectedHour = 0;
    fileprivate var selectedMinute = 0;
    fileprivate var selectedSecond = 0;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setUpViews()
    }
    
    convenience init(type:DatePickerStyle, currentDate: Date) {
        self.init(frame: CGRect.zero)
        self.datePickerStyle = type
        self.currentDate = currentDate
        self.setUpViews()
        self.initDatePicker()
    }
    
    convenience init() {
        self.init(type: .KDatePickerDate, currentDate: Date())
    }
    
    fileprivate func setUpViews(){
    
        self.addPickerView()
    }
    
    //设置日历
    fileprivate func addPickerView()  {
        
        self.addSubview(self.pickerView)
        
        self.setPickerP()
        self.setPickerF()
    }
    
    fileprivate func setPickerP()  {
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    fileprivate func setPickerF()  {
        
        pickerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK:计算每个月有多少天
    
    fileprivate func isAllDay(year:Int, month:Int) -> Int {
        
        var day:Int = 0
        switch(month)
        {
        case 1,3,5,7,8,10,12:
            day = 31
        case 4,6,9,11:
            day = 30
        case 2:
            
            if(((year%4==0)&&(year%100==0))||(year%400==0))
            {
                day=29
            }
            else
            {
                day=28;
            }
            
        default:
            break;
        }
        return day;
    }
}

//MARK:初始化数据
extension LSDatePickerView {
    
    fileprivate func initDatePicker() {
        self.pickerView.selectRow(selectedYear - startYear, inComponent: 0, animated: true)
        self.pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: true)
        self.pickerView.selectRow(selectedDay - 1, inComponent: 2, animated: true)
        switch  datePickerStyle{
        case .KDatePickerDate:
            break
        case .KDatePickerTime:
            self.pickerView.selectRow(selectedHour , inComponent: 3, animated: true)
            self.pickerView.selectRow(selectedMinute , inComponent: 4, animated: true)
        case .KDatePickerSecond:
            self.pickerView.selectRow(selectedHour , inComponent: 3, animated: true)
            self.pickerView.selectRow(selectedMinute , inComponent: 4, animated: true)
            self.pickerView.selectRow(selectedSecond, inComponent: 5, animated: true)
        default:
            break
        }
        self.pickerView.reloadAllComponents()
    }
}

extension  LSDatePickerView:UIPickerViewDelegate,UIPickerViewDataSource{
    
    //返回UIPickerView当前的列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return unitFlags == nil ? 0 : unitFlags.count
    }
    
    //确定每一列返回的东西
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return yearRange
        case 1:
            return 12
        case 2:
            return dayRange
        case 3:
            return 24
        case 4:
            return 60
        case 5:
            return 60
        default:
            return 0
        }
    }
    
    //返回一个视图，用来设置pickerView的每行显示的内容。
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel(frame: CGRect(x: kSCREEN_WIDTH * CGFloat(component) / 6 , y: 0, width: kSCREEN_WIDTH/6, height: 30))
        
        label.font = UIFont.systemFont(ofSize: CGFloat(14))
        
        label.tag = component*100+row
        
        label.textAlignment = .center
        
        switch component {
        case 0:
            
            label.frame=CGRect(x:5, y:0,width:kSCREEN_WIDTH/4.0, height:30);
            
            
            label.text="\(self.startYear + row)年";
            
        case 1:
            
            label.frame=CGRect(x:kSCREEN_WIDTH/4.0, y:0,width:kSCREEN_WIDTH/8.0, height:30);
            
            
            label.text="\(row + 1)月";
        case 2:
            
            label.frame=CGRect(x:kSCREEN_WIDTH*3/8, y:0,width:kSCREEN_WIDTH/8.0, height:30);
            
            
            label.text="\(row + 1)日";
        case 3:
            
            label.textAlignment = .right
            
            label.text="\(row )时";
        case 4:
            
            label.textAlignment = .right
            
            label.text="\(row )分";
        case 5:
            
            label.textAlignment = .right
            
            label.frame=CGRect(x:kSCREEN_WIDTH/6, y:0,width:kSCREEN_WIDTH/6.0 - 5, height:30);
            
            
            label.text="\(row )秒";
            
        default:
            label.text="\(row )秒";
        }
        
        return label
    }
    
    //当点击UIPickerView的某一列中某一行的时候，就会调用这个方法
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.selectedYear = self.startYear + row
            
            self.dayRange = self.isAllDay(year: self.startYear, month: self.selectedMonth)
            
            self.pickerView.reloadComponent(2)
        case 1:
            self.selectedMonth =  row + 1
            
            self.dayRange = self.isAllDay(year: self.startYear, month: self.selectedMonth)
            
            self.pickerView.reloadComponent(2)
        case 2:
            selectedDay = row + 1
        case 3:
            selectedHour = row
        case 4:
            selectedMinute = row
        case 5:
            selectedSecond = row
        default:
            selectedSecond = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
}

