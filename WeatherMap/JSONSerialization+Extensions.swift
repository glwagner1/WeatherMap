//
//  JSONSerialization+Extensions.swift
//  
//
//  Created by Gary L Wagner on 8/7/22.
//

import Foundation
import JPCommonAPIs
import JPCoreSwift
import JPNetworkCommunications

public extension JSONSerialization {

    /// Loading resource test files (JSON)
    /// - Parameters:
    ///   - fileName: resource referrence
    ///   - bundle: resource bundle
    ///   - logManager:
    /// - Returns: JSON data bundle
    static func loadJsonDataFromJSON(fileName: String, bundle: Bundle?) throws -> Data? {
        let bundle = bundle ?? Bundle.allFrameworks.first { $0.path(forResource: fileName, ofType: "json") != nil }
        if let path = bundle?.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch {
                Provider.logManager?.LogWarn("Resources :: JSONSerialization :: loadJsonDataFromJSON :: 1 :: Failure | fileName: \(fileName): error: \(error)")
                throw error
            }
        }
        Provider.logManager?.LogWarn("Resources :: JSONSerialization :: loadJsonDataFromJSON :: 2 :: Failure - not found | fileName : \(fileName)")
        let nserror = NSError(domain: "Failure - not found | fileName : \(fileName)", code: 99)

        throw nserror
        return nil

    }

    static func getResourcePath(fileName: String, bundle: Bundle?, type: String = "json") -> String? {
        let bundle = bundle ?? Bundle.allFrameworks.first { $0.path(forResource: fileName, ofType: type) != nil }
        if let path = bundle?.path(forResource: fileName, ofType: type) {
            return path
        }

        Provider.logManager?.LogWarn("Resources :: JSONSerialization :: getResourcePath :: 3 :: Failure - not found | fileName : \(fileName).\(type)")
        return nil

    }

    static func loadJsonDataFromResource(path: String) -> Data? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            return data
        } catch {
            Provider.logManager?.LogWarn("Resources :: JSONSerialization :: loadJsonDataFromJSON :: 4 :: Failure | path: \(path): error: \(error.localizedDescription)")
        }
        return nil

    }

}


