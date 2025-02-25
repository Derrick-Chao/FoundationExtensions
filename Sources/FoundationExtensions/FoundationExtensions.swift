// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

/*
 匯總常用的一些 Extension，以供不同 App 取用。
 */

// MARK: - Bundle
public extension Bundle {
    var appName: String { getInfo("CFBundleName")  }
    var displayName: String {getInfo("CFBundleDisplayName")}
    var language: String { getInfo("CFBundleDevelopmentRegion")}
    var identifier: String { getInfo("CFBundleIdentifier")}
    var copyright: String { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    var appBuild: String { getInfo("CFBundleVersion") }
    var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

// MARK: - NSObject
public extension NSObject {
    
    class func getClassName() -> String {
        return String(describing: self)
    }
}

// MARK: - String
public extension String {
    /// 格式：yyyy-MM-dd HH:mm:ss
    func fullDateFormatter() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    /// 格式：yyyy-MM-dd HH:mm
    func fullDateWithoutSecondFormatter() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    /// 格式：yyyy-MM-dd
    func nonHourAndMinuteDateFormatter() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    /**
     時間格式 ISO 8601 轉換
     
     "yyyy"：4位數的年份，例如2022。
     "MM"：2位數的月份，例如01。
     "dd"：2位數的日期，例如01。
     "HH"：24小時制的小時，例如00或23。
     "hh"：12小時制的小時，例如12或11。
     "mm"：2位數的分鐘，例如01或59。
     "ZZZZZ"：ISO 8601格式的時區偏移量，例如+08:00。
     */
    func iso8601Formatter() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    /// 計算字串高度
    /// - Parameters:
    ///   - width: 要放置的View的寬度
    ///   - font: 要設置的font
    /// - Returns: 計算後適當的高度
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        
//        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingRect = (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        return ceil(boundingRect.height)
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = font
        label.text = self
        label.sizeToFit()
        // 由於計算完後的高度內容似乎不太準確，額外上下加一些空間
        let padding: CGFloat = 16.0 + 16.0
        return label.bounds.height + padding
    }
}

// MARK: - Date
public extension Date {
    
    static func getTomorrowDate() -> Date? {
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        return tomorrow
    }
    
    static func getTheDayAfterTomorrow() -> Date? {
        
        let today = Date()
        let theDayOfTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)
        return theDayOfTomorrow
    }
    
    func isDateInTheDayAfterTomorrow() -> Bool {
        
        if let today = Date().nonHourAndMinuteDateFormatter().nonHourAndMinuteDateFormatter(), let checkDay = self.nonHourAndMinuteDateFormatter().nonHourAndMinuteDateFormatter() {
//            dPrint("today: \(today), self: \(checkDay)")
            let dateComponents = Calendar.current.dateComponents([.day], from: today, to: checkDay)
            if let day = dateComponents.day, day == 2 {
//                dPrint("isDateInTheDayAfterTomorrow: \(day)")
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /// 格式： HH:mm
    func hourAndMinuteFormatter() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    /// 格式： yyyy/MM/dd HH:mm
    func fullDateSlashFormatter() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: self)
    }
    
    /// 格式： yyyy-MM-dd
    func nonHourAndMinuteDateFormatter() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    /// 格式： HH:mm
    func hourAndMinuteDateFormatter() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    /// 格式： yyyy-MM-dd HH:mm:ss, 時區台灣台北
    func fullDateFormatterAtTaipei() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei") ?? TimeZone.current
        return formatter.string(from: self)
    }
    
    
    /// iso8601 格式，時區台灣台北
    /// - Returns: 輸出範例 2025-03-01T12:00:00+0800
    func iso8601FormatterAtTaipei() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return formatter.string(from: self)
    }
    
    
    /// iso8601 格式
    /// - Parameter identifier: 時區識別碼
    /// - Returns: 輸出範例 2025-03-01T12:00:00+0000
    func iso8601Formatter(identifier: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(identifier: identifier)
        return formatter.string(from: self)
    }
}
