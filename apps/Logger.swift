//
//  Logger.swift
//  apps
//

import Foundation

class Logger {
    static func log(_ message: String, file: String = #file, line: Int = #line) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())
        let className = (file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print("[\(timestamp)] (\(className):\(line)) \(message)")
    }
}
