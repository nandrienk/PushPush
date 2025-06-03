//
//  XCRunHelper.swift
//  PushPush
//

import Foundation

enum XCRunError: Error {
    case devicesListFetchError(_ data: Data)
    case processExecuteError
    case pushSendError(_ stringError: String)
}

class XCRunHelper {
    private let executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
    
    func avaliableSimulators(_ completion: @escaping (Result<DevicesCollection, Error>) -> Void)  {
        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["simctl","list", "--json"]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
        } catch {
            completion(.failure(XCRunError.processExecuteError))
            return
        }
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        
        process.terminationHandler = { _ in
            guard let devicesColletion = try? JSONDecoder().decode(DevicesCollection.self, from: outputData) else {
                completion(.failure(XCRunError.devicesListFetchError(errorData)))
                return
            }
            completion(.success(devicesColletion))
        }
    }
    
    func sendPushNotification(filePath: String,
                              udid: String,
                              bundleId: String,
                              completion: @escaping (Result<String, XCRunError>) -> Void) {
        let process = Process()
        process.executableURL = executableURL
        
        process.arguments = ["simctl", "push", udid, bundleId, filePath]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
        } catch {
            completion(.failure(XCRunError.processExecuteError))
            return
        }
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        
        process.terminationHandler = { _ in
            completion(.success(output))
        }
    }
}
