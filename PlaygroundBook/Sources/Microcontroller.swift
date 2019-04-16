//
//  Microcontroller.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit
import SpriteKit
import PlaygroundSupport

public class Microcontroller: SKSpriteNode {
    
    var pins: [Pin] = []
    var loopTimer: Timer!
    var configurations: [PinConfiguration] = []
    // <-900 is boolean false >900 is boolean true otherwise it is an analog value
    var states: [Double] = []

    
    func setupBase() {
        
        // Apply texture
        let microcontrollerTexture = SKTexture(imageNamed: "Arduino.png")
        self.texture = microcontrollerTexture
        self.name = "Microcontroller"

        // Add pins
        for i in 0..<5 {
            let pin = Pin(color: UIColor.red, size: CGSize(width: 0.025, height: 0.04))
            pin.position = CGPoint(x: 0.035 + Double(i) * 0.037, y: 0.0275)
            pin.name = "Pin\(i)"
            pins.append(pin)
            states.append(0.0)
            configurations.append(PinConfiguration(type: .analogOutput, pin: i))
            self.addChild(pin)
        }
//        loopTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
//            self.backendLoop()
//        })
    }
    
    func backendLoop() {
        // Get all pin values based on configuration
        for i in 0..<5 {
            let type = configurations[i].type
            if type == .digitalInput {
                let enabled: Bool = pins[i].getInput()
                if enabled {
                    states[i] = 999
                } else {
                    states[i] = -999
                }
            } else if type == .analogOutput {
                states[i] = pins[i].getInput()
            }
        }
    }
    
    // User interaction methods - backend
    public func writeBool(to pin: Int, value: Bool) {
        pins[pin-1].sendInput(input: value)
    }
    
    public func writeDouble(to pin: Int, value: Double) {
        pins[pin-1].sendInput(input: value)
    }
    
    public func readBool(from: Int) -> Bool {
        return pins[from-1].getInput()
    }

    public func readDouble(from: Int) -> Double {
        return pins[from-1].getInput()
    }

  
    public func configurePin(for pin: Int, type: PinType) {
        let config = PinConfiguration(type: type, pin: pin)
        configurations[pin-1] = config
        if type == .digitalInput || type == .digitalOutput {
            states[pin-1] = -999.0
        }
    }
    
}

class PinConfiguration {
    var type: PinType
    var pin: Int
    
    init(type: PinType, pin: Int) {
        self.type = type
        self.pin = pin
    }
    
}

public enum PinType: String {
    case digitalInput = "digitalInput"
    case analogInput = "analogInput"
    case digitalOutput = "digitalOutput"
    case analogOutput = "analogOutput"
}




