//
//  Wire.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit
import SpriteKit

class Wire: SKSpriteNode, Moveable {
    
    func moveConnections() {
        
    }

    var component1: Anchor?
    var component2: Anchor?
    
    func sendState(direction: Bool, state: Bool) {
        if direction {
            if component2 is ActuatorAnchor {
                guard let comp = component2 as? ActuatorAnchor else {return}
                comp.transferState(state: state)
            }
        } else {
            if component1 is ActuatorAnchor {
                guard let comp = component1 as? ActuatorAnchor else {return}
                comp.transferState(state: state)
            }
        }
    }
    
    func getState(fromFirst: Bool) -> Bool {
        if fromFirst {
            if component1 is SensorAnchor {
                guard let comp = component1 as? SensorAnchor else {return false}
                return comp.sendState()
        } else {
            if component2 is SensorAnchor {
                guard let comp = component2 as? SensorAnchor else {return false}
                return comp.sendState()
            }
        }
        }
        print("Invalid")
        return false
    }

        
        func testConfigure(starting: Anchor, ending: Anchor) {
            component1 = starting
            component2 = ending
        }
        
    
    }
