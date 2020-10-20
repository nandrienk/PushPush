//
//  SimulatorModel.swift
//  Created by nandrienko on 10/18/20.
//

import Foundation

enum DeviceState: String, Codable {
    case shutdown = "Shutdown"
    case booted = "Booted"
}

struct SimulatorModel: Codable {
    var name: String
    var state: DeviceState
    var udid: String
    var isAvailable: Bool
}
