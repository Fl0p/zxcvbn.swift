//
//  ZxcvbnError.swift
//  Zxcvbn
//
//  Created by Flop But on 20/03/2025.
//
import Foundation

public enum ZxcvbnError: Error {
    case notCompatibleWithOS
    case fileNotFound(String)
    case decompressionFailed(Error)
}
