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

        case info
        case error
    }

    // MARK: Public methods

    static func log(msg: String, level: Level) {
        print(msg)
    }

    static func logError(withMsg msg: String) {
        log(msg: msg, level: .error)
    }

    static func log(info: String) {
        log(msg: info, level: .info)
    }
}
