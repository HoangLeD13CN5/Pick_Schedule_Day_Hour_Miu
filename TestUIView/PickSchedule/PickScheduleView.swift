//
//  PickScheduleView.swift
//  PayPlus
//
//  Created by Admin on 4/19/19.
//  Copyright © 2019 OnePAY. All rights reserved.
//

import UIKit

func addSimpleConstraints(child: UIView, parent: UIView, distance: CGFloat) {
    child.translatesAutoresizingMaskIntoConstraints = false
    child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: distance).isActive = true
    child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -distance).isActive = true
    child.topAnchor.constraint(equalTo: parent.topAnchor, constant: distance).isActive = true
    child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -distance).isActive = true
}

protocol PickScheduleViewDelegate: class {
    func getDay(date:Date)
}

class PickScheduleView: UIView {

    weak var delegate: PickScheduleViewDelegate?
    
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var viewButton: UIView!
    
    @IBOutlet weak var tableAM: UITableView!
    @IBOutlet weak var tableMiu: UITableView!
    @IBOutlet weak var tableHour: UITableView!
    @IBOutlet weak var tableDay: UITableView!
    
    @IBOutlet weak var stackSeparatorTop: UIStackView!
    @IBOutlet weak var stackSeparatorButton: UIStackView!
    
    // MARK: - Table View Property
    public var startTime: Date = Date()
    public var endTime: Date = Date().getNext(nextDay: 10)
    public var hasHapticFeedback: Bool = true
    fileprivate var viewScheduleHeight: CGFloat = 174
    fileprivate var rowHeight: CGFloat = 174/3
    fileprivate var hourRange: [String] = []
    fileprivate var minuteRange: [String] = []
    fileprivate var amRange: [String] = []
    fileprivate var dayRange: [(String,Date)] = []
    
    var currentIndexHour: Int = 0 {
        willSet {
            if self.tableHour.superview != nil {
                let cell = self.tableHour.cellForRow(at: IndexPath(row: self.currentIndexHour, section: 0))
                cell?.textLabel?.textColor = .black
            }
        }
        didSet {
            if self.tableHour.superview != nil {
                let cell = self.tableHour.cellForRow(at: IndexPath(row: self.currentIndexHour, section: 0))
                cell?.textLabel?.textColor = .white
                tableHour.scrollToRow(row: self.currentIndexHour, animated: true)
                if self.currentIndexHour == 0 && self.currentIndexMiu == 0 {
                    self.stackSeparatorTop.isHidden = true
                }else {
                    self.stackSeparatorTop.isHidden = false
                }
                
                if self.currentIndexHour == self.hourRange.count - 1 && self.currentIndexMiu == self.minuteRange.count - 1 {
                    self.stackSeparatorButton.isHidden = true
                }else {
                    self.stackSeparatorButton.isHidden = false
                }
            }
        }
    }
    var currentIndexMiu: Int = 0 {
        willSet {
            if self.tableMiu.superview != nil {
                let cell = self.tableMiu.cellForRow(at: IndexPath(row: self.currentIndexMiu, section: 0))
                cell?.textLabel?.textColor = .black
            }
        }
        didSet {
            if self.tableMiu.superview != nil {
                let cell = self.tableMiu.cellForRow(at: IndexPath(row: self.currentIndexMiu, section: 0))
                cell?.textLabel?.textColor = .white
                tableMiu.scrollToRow(row: self.currentIndexMiu, animated: true)
                if self.currentIndexHour == 0 && self.currentIndexMiu == 0 {
                    self.stackSeparatorTop.isHidden = true
                }else {
                    self.stackSeparatorTop.isHidden = false
                }
                
                if self.currentIndexHour == self.hourRange.count - 1 && self.currentIndexMiu == self.minuteRange.count - 1 {
                    self.stackSeparatorButton.isHidden = true
                }else {
                    self.stackSeparatorButton.isHidden = false
                }
            }
        }
    }
    
    var currentIndexAm: Int = 0 {
        willSet {
            if self.tableAM.superview != nil {
                let cell = self.tableAM.cellForRow(at: IndexPath(row: self.currentIndexAm, section: 0))
                cell?.textLabel?.textColor = .black
            }
        }
        didSet {
            if self.tableAM.superview != nil {
                let cell = self.tableAM.cellForRow(at: IndexPath(row: self.currentIndexAm, section: 0))
                cell?.textLabel?.textColor = .white
                tableAM.scrollToRow(row: self.currentIndexAm, animated: true)
            }
        }
    }
    
    var currentIndexDay: Int = 0 {
        willSet {
            if self.tableDay.superview != nil {
                if let cell = self.tableDay.cellForRow(at: IndexPath(row: self.currentIndexDay, section: 0)) as? DayPickerScheduleCell {
                    cell.lblDay.textColor = UIColor(red:0.77, green:0.76, blue:0.84, alpha:1.0)
                    cell.lblWeek.textColor = UIColor(red:0.77, green:0.76, blue:0.84, alpha:1.0)
                }
            }
        }
        didSet {
            if self.tableDay.superview != nil {
                if let cell = self.tableDay.cellForRow(at: IndexPath(row: self.currentIndexDay, section: 0)) as? DayPickerScheduleCell {
                    cell.lblDay.textColor = .white
                    cell.lblWeek.textColor = UIColor(red:0.78, green:0.58, blue:0.31, alpha:1.0)
                }
                tableDay.scrollToRow(row: self.currentIndexDay, animated: true)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initXib()
    }
    
    private func initXib(){
        self.effectView()
        let view = loadNib()
        addSubview(view)
        addSimpleConstraints(child: view, parent: self, distance: 0)
        self.setupView()
        self.setData()
    }
    
    func setupView() {
        self.setupTableView(tableView: self.tableHour)
        self.setupTableView(tableView: self.tableMiu)
        self.setupTableView(tableView: self.tableAM)
        self.setupTableView(tableView: self.tableDay)
        self.stackSeparatorTop.isHidden = true
        self.setupConnerView(view: self.viewSchedule)
    }
    
    func setupConnerView(view:UIView) {
        view.layer.cornerRadius = 5
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentInset = UIEdgeInsets(top: (viewScheduleHeight - rowHeight) / 2, left: 0, bottom: (viewScheduleHeight - rowHeight) / 2, right: 0)
        self.tableHour.contentInset = contentInset
        self.tableMiu.contentInset = contentInset
        self.tableAM.contentInset = contentInset
        self.tableDay.contentInset = contentInset
        
        self.tableHour.separatorStyle = .none
        self.tableMiu.separatorStyle = .none
        self.tableAM.separatorStyle = .none
        self.tableDay.separatorStyle = .none
        
    }
    
    private func setupTableView(tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = rowHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: (viewScheduleHeight - rowHeight) / 2, left: 0, bottom: (viewScheduleHeight - rowHeight) / 2, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.scrollsToTop = false
        
        if tableView == self.tableDay {
            self.registerCell()
        }
    }
    
    func effectView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func setData() {
        var date = self.startTime
        while true {
            let weekString = self.getWeek(week: date.weekday)
            self.dayRange.append((weekString,date))
            date = date.getNext(nextDay: 1)
            if date > self.endTime {
                break
            }
        }
        for index in 1...12 {
            var hour = "\(index)"
            if index <= 9 {
                hour = "0\(index)"
            }
            self.hourRange.append(hour)
        }
        for index in 0...59 {
            var miu = "\(index)"
            if index <= 9 {
                miu = "0\(index)"
            }
            self.minuteRange.append(miu)
        }
        amRange.append("AM")
        amRange.append("PM")
    }
    
    func getWeek(week: Int) -> String {
        switch week {
        case 1:
            return "MONDAY"
        case 2:
            return "TUEDAY"
        case 3:
            return "WEDNESDAY"
        case 4:
            return "THURSDAY"
        case 5:
            return "FRIDAY"
        case 6:
            return "SATURDAY"
        default:
            return "SUNDAY"
        }
    }
    
    @IBAction func tapCreateBooking(_ sender: Any) {
        var hour = self.currentIndexHour + 1
        if self.currentIndexAm == 1 {
            hour = self.currentIndexHour + 13
        }
        var dateComponents = DateComponents()
        dateComponents.year = self.dayRange[self.currentIndexDay].1.year
        dateComponents.month = self.dayRange[self.currentIndexDay].1.month
        dateComponents.day = self.dayRange[self.currentIndexDay].1.day
        dateComponents.hour = hour
        dateComponents.minute = self.currentIndexMiu
        let userCalendar = Calendar.current
        let date = userCalendar.date(from: dateComponents)
        delegate?.getDay(date: date ?? Date())
    }
    
    @IBAction func tapCancelBooking(_ sender: Any) {
        
    }
}

extension PickScheduleView: UITableViewDataSource {
    func registerCell () {
         self.tableDay.register(UINib(nibName: "DayPickerScheduleCell", bundle: nil), forCellReuseIdentifier: "DayPickerScheduleCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableHour == tableView {
            return self.hourRange.count
        }else if tableView == tableMiu{
            return self.minuteRange.count
        }else if tableView == tableAM{
            return self.amRange.count
        }else {
            return self.dayRange.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableDay == tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DayPickerScheduleCell", for: indexPath) as! DayPickerScheduleCell
             let dayString = "\(self.dayRange[indexPath.row].1.day) THÁNG \(self.dayRange[indexPath.row].1.month)"
            cell.lblDay.text = dayString
            cell.lblWeek.text = self.dayRange[indexPath.row].0
            if indexPath.row == 0 {
                cell.lblDay.textColor = .white
                cell.lblWeek.textColor = UIColor(red:0.78, green:0.58, blue:0.31, alpha:1.0)
            }else {
                cell.lblDay.textColor = UIColor(red:0.77, green:0.76, blue:0.84, alpha:1.0)
                cell.lblWeek.textColor = UIColor(red:0.77, green:0.76, blue:0.84, alpha:1.0)
            }
           
            return cell
        }else {
            var data:String = ""
            if tableHour == tableView {
                data = self.hourRange[indexPath.row]
            }else if tableView == tableMiu {
                data = self.minuteRange[indexPath.row]
            }else if tableView == tableAM{
                data = self.amRange[indexPath.row]
            }
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            if tableView == tableAM {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            }
            if indexPath.row == 0 {
                cell.textLabel?.textColor = .white
            }else {
                cell.textLabel?.textColor = .black
            }
            cell.textLabel?.text = data
            return cell
        }
    }
}

extension PickScheduleView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewSchedule.frame.height / 3
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewSchedule.frame.height / 3
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            if #available(iOS 10.0, *), hasHapticFeedback {
                let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
                selectionFeedbackGenerator.selectionChanged()
            }
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
        
        if !decelerate {
            alignTableViewToRow(tableView: tableView)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
        
        alignTableViewToRow(tableView: tableView)
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
        
        alignTableViewToRow(tableView: tableView)
    }
    
    private func alignTableViewToRow(tableView: UITableView) {
        let row = tableView.getRowScroll()
        // did select time
        if tableView == self.tableHour {
            currentIndexHour = row
        } else if tableView == self.tableMiu {
            currentIndexMiu = row
        }else if tableView == self.tableAM {
            currentIndexAm = row
        }else if tableView == self.tableDay {
            currentIndexDay = row
        }
    }
    
    public func reload() {
        self.tableHour.reloadAndLayout()
        self.tableMiu.reloadAndLayout()
    }
}

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

internal extension UITableView {
    func reloadAndLayout() {
        reloadData()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func getRowScroll() -> Int {
        var relativeOffset = CGPoint(x: 0, y: contentOffset.y + contentInset.top)
        relativeOffset.y = min(contentSize.height + contentInset.top, relativeOffset.y)
        
        let row = Int(round(relativeOffset.y / rowHeight))
        return row
    }
    
    func scrollToRow(row: Int, animated: Bool) {
        let scroll = CGFloat(row) * rowHeight - contentInset.top
        setContentOffset(CGPoint(x: 0, y: scroll), animated: animated)
    }
}

//MARK: - Extentions Date
extension Date {
    func stringFromDate(format: String) -> String {
        var formatter: DateFormatter
        formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = NSCalendar(calendarIdentifier: .ISO8601)! as Calendar
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: +7) as TimeZone
        return formatter.string(from: self)
    }
    
    func getDateComponents() -> DateComponents {
        let calendar = Calendar.current
        return (calendar as NSCalendar).components([
            NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day,
            NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.weekday
            ], from: self)
    }
    
    
    /// SwifterSwift: User’s current calendar.
    public var calendar: Calendar {
        return Calendar.current
    }
    
    /// SwifterSwift: Era.
    public var era: Int {
        return calendar.component(.era, from: self)
    }
    
    /// SwifterSwift: Quarter.
    public var quarter: Int {
        return calendar.component(.quarter, from: self)
    }
    
    /// SwifterSwift: Week of year.
    public var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    /// SwifterSwift: Week of month.
    public var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }
    
    /// SwifterSwift: Year.
    public var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.year = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Month.
    public var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.month = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Day.
    public var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.day = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Weekday.
    public var weekday: Int {
        get {
            return calendar.component(.weekday, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: self)
            component.weekday = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Hour.
    public var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.hour = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Minutes.
    public var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.minute = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Seconds.
    public var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.second = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Nanoseconds.
    public var nanosecond: Int {
        get {
            return calendar.component(.nanosecond, from: self)
        }
        set {
            if let date = calendar.date(bySetting: .nanosecond, value: newValue, of: self) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Milliseconds.
    public var millisecond: Int {
        get {
            return calendar.component(.nanosecond, from: self) / 1000000
        }
        set {
            let ns = newValue * 1000000
            if let date = calendar.date(bySetting: .nanosecond, value: ns, of: self) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Check if date is in future.
    public var isInFuture: Bool {
        return self > Date()
    }
    
    /// SwifterSwift: Check if date is in past.
    public var isInPast: Bool {
        return self < Date()
    }
    
    /// SwifterSwift: Check if date is in today.
    public var isInToday: Bool {
        return calendar.isDateInToday(self)
    }
    
    /// SwifterSwift: Check if date is within yesterday.
    public var isInYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }
    
    /// SwifterSwift: Check if date is within tomorrow.
    public var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    /// SwifterSwift: Check if date is within a weekend period.
    public var isInWeekend: Bool {
        return calendar.isDateInWeekend(self)
    }
    
    /// SwifterSwift: Check if date is within a weekday period.
    public var isInWeekday: Bool {
        return !calendar.isDateInWeekend(self)
    }
    
    func getNext(nextDay: Int) -> Date {
        return calendar.date(byAdding: .day, value: nextDay, to: self)!
    }
}
