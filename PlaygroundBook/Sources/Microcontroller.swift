//
//  Microcontroller.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit
import SpriteKit

class Microcontroller: SKSpriteNode, Actuator {
    var pins: [SKSpriteNode] = []
    var states: [Bool] = []
    
    func handleReceivedState(state: Bool, fromPin: Int) {
        
    }
    
    
    func setup() {
        // Apply texture
        let microcontrollerTexture = SKTexture(imageNamed: "Arduino.png")
        self.texture = microcontrollerTexture
        self.name = "Microcontroller"
        
        // Add pins
        for i in 0..<5 {
            let pin = Pin(color: UIColor.red, size: CGSize(width: 0.022, height: 0.032))
            pin.name = "Anchor"
            pin.position = CGPoint(x: 0.035 + Double(i) * 0.037, y: 0.0275)
            //pin.name = "Pin\(i)"
            pins.append(pin)
            states.append(false)
            self.addChild(pin)
        }
    }
    
    
}
