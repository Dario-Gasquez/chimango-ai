//
//  VSError.swift
//  
//
//  Created by Dario on 29/08/2021.
//

import Foundation

public enum VSError: String, Error {
    case unknown
    case coreModelCreationFailed
    case objectDetectionFailed
    case noObjectDetected
    case librarySetupFailed
    case detectionModeNotSupported
}


extension VSError: LocalizedError {
    public var errorDescription: String? {
        return "Visual Search Error: \(self.rawValue)"
    }
}
