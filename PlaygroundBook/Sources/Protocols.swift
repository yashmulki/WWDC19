//
//  Protocols.swift
//  PlaygroundBook
//
//  Created by Yashvardhan Mulki on 2019-03-16.
//

import Foundation
import PlaygroundSupport


// User screeen interaction protocols
protocol Moveable {
    func moveConnections()
}

protocol Tappable {
    func handleTap()
}

// Component interaction protocols
protocol Sensing {
    func sendInstruction() -> Bool
    func sendInstruction() -> Double
}

protocol Actuating {
    func recieveInstruction(instruction: Bool)
    func recieveInstruction(instruction: Double)
}





