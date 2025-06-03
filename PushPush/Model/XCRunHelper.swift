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
    
    func availableSimulators(_ completion: @escaping (Result<DevicesCollection, Error>) -> Void)  {
        let process = Process()
        process.executableURL = executableURL
        process.arguments = ["simctl","list", "--json"]

        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.standardOutput = outputPipe
        process.standardError = errorPipe

        process.terminationHandler = { _ in
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

            guard let devicesCollection = try? JSONDecoder().decode(DevicesCollection.self, from: outputData) else {
                completion(.failure(XCRunError.devicesListFetchError(errorData)))
                return
            }
            completion(.success(devicesCollection))
        }

        do {
            try process.run()
        } catch {
            completion(.failure(XCRunError.processExecuteError))
            return
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

        process.terminationHandler = { _ in
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

            if !errorData.isEmpty {
                let errorString = String(decoding: errorData, as: UTF8.self)
                completion(.failure(XCRunError.pushSendError(errorString)))
                return
            }

            let output = String(decoding: outputData, as: UTF8.self)
            completion(.success(output))
        }

        do {
            try process.run()
        } catch {
            completion(.failure(XCRunError.processExecuteError))
            return
        }
    }
}
