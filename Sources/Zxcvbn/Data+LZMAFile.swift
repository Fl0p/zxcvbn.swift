//
//  Data+LZMAFile.swift
//  Zxcvbn
//
//  Created by Flop But on 20/03/2025.
//
import Foundation

public extension Data {
    static func dataWithLZMAFile(name: String) throws -> Data {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            guard let url = Bundle.module.url(forResource: name, withExtension: "lzma") else {
                throw ZxcvbnError.fileNotFound("\(name).lzma")
            }
            do {
                let compressed = try Data(contentsOf: url) as NSData
                let decompressed = try compressed.decompressed(using: .lzma)
                
                return decompressed as Data
            } catch {
                throw ZxcvbnError.decompressionFailed(error)
            }
        } else {
            throw ZxcvbnError.notCompatibleWithOS
        }
    }
}
