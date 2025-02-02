//
//  LoggerUtils.swift
//  CurrencyConverter
//
//  Created by Ruslan Kasian on 02.02.2025.
//

import OSLog

extension Logger {
    
    static var isLogEnabled: Bool {
        return Config.isLoggingEnabled
    }
    
    private static var subsystem = Bundle.main.bundleIdentifier ?? "CurrencyConverter"
    
    static let network = Logger(subsystem: subsystem, category: "network")
    
}

extension Logger {
   
    func warning(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .error, "\(message, privacy: .public)")
        }
    }
    
    func info(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .info, "\(message, privacy: .public)")
        }
    }

    func error(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .error, "\(message, privacy: .public)")
        }
    }
    
    func debug(_ message: String) {
        if Logger.isLogEnabled {
            self.log(level: .debug, "\(message, privacy: .public)")
        }
    }
}
