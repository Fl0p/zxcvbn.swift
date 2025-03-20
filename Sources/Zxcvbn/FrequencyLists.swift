//
//  File.swift
//
//
//  Created by Niil Öhlin on 2023-01-03.
//

import Foundation

enum FrequencyLists {
    static var json: [String: Any] {
        do {
            let data = try Data.dataWithLZMAFile(name: "frequency_lists")
            return try JSONSerialization.jsonObject(with: data) as! [String: Any]
        } catch {
            fatalError("Failed to parse json: \(error)")
        }
    }
}
