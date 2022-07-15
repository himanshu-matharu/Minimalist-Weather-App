//
//  Collection+MostFrequent.swift
//  Minimalist Weather
//
//  Created by Himanshu Matharu on 2022-07-15.
//

import Foundation

extension Collection {

    /**
     Returns the most frequent element in the collection.
     */
    func mostFrequent() -> Self.Element?
    where Self.Element: Hashable {
        let counts = self.reduce(into: [:]) {
            return $0[$1, default: 0] += 1
        }

        return counts.max(by: { $0.1 < $1.1 })?.key
    }
}
