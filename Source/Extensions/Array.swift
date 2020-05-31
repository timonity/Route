//
//  Array.swift
//  Route
//
//  Created by Nikolai Timonin on 27.05.2020.
//

import Foundation

extension Array {

    public func prefix(through condition: (Element) throws -> Bool) -> Array<Element>? {
        do {
            guard let idx = try firstIndex(where: condition) else { return nil }

            return Array(self.prefix(through: idx))

        } catch {
            return nil
        }
    }
}
