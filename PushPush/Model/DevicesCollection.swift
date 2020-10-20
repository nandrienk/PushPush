//
//  DevicesCollection.swift
//  PushPush
//

import Foundation

// MARK: - Device state
enum State: String, Codable {
    case booted = "Booted"
    case shutdown = "Shutdown"
}

// MARK: - DevicesCollection
struct DevicesCollection: Decodable {
    private let dictionary: [String: [Device]]
    
    var devices: [Device] {
        return dictionary.flatMap { $0.value }
    }
    
    var bootedDevices: [Device] {
        return devices.filter { ($0.state == .booted) }
    }
    
    enum CodingKeys: String, CodingKey {
        case dictionary = "devices"
    }
}

// MARK: - Device
struct Device: Codable {
    let udid: String
    let isAvailable: Bool
    let deviceTypeIdentifier: String
    let state: State
    let name: String
}
