//
//  Logger.swift
//  Flow
//
//  Created by Nikolai Timonin on 25.05.2020.
//

import Foundation

final class Logger {

    // MARK: Types

    enum Level {
        case warning
        case error
    }

    // MARK: Public methods

    static func log(_ msg: String, level: Level) {
        print(msg)
    }

    static func error(_ msg: String) {
        log(msg, level: .error)
    }

    static func warning(_ msg: String) {
        log(msg, level: .warning)
    }
}
