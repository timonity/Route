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
        case debug
        case warning
        case error
        case critical
    }

    // MARK: Public preperties

    static var isVerbose: Bool = false

    // MARK: Private methods

    private static func log(_ msg: String, level: Level) {
        print(msg)
    }

    // MARK: Public methods

    static func debug(_ msg: String) {
        log(msg, level: .debug)
    }

    static func error(_ msg: String) {
        log(msg, level: .error)
    }

    static func warning(_ msg: String) {
        log(msg, level: .warning)
    }

    static func critical(_ msg: String) {
        log(msg, level: .critical)
    }
}
