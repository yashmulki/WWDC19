//
//  Pin.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-15.
//

import UIKit
import SpriteKit

class Pin: SKSpriteNode, SensorAnchor, ActuatorAnchor {
    var wire = Wire()
    
    
    func sendState(state: Bool) {
        if self.isEqual(wire.component1) {
            wire.sendState(direction: true, state: state)
        } else {
            wire.sendState(direction: false, state: state)
        }
    }
    
    func transferState(state: Bool) {
        
    }
    
    func createConnection(withWire: Wire) {
        
    }
    

}
