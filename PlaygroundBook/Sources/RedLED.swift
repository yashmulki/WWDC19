//
//  RedLED.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-16.
//

import UIKit
import SpriteKit

public class RedLED: LED {
    private let switchOffImage = UIImage(named: "LEDOff.png")
    private let switchOnImage = UIImage(named: "REDLed.png")
    
    override func setup() {
        let startingTexture = SKTexture(image: switchOffImage!)
        self.texture = startingTexture
        super.setup()
    }

    override func setState(state: Bool) {
        let newState = state
        if newState {
            self.texture = SKTexture(image: switchOnImage!)
        } else {
            self.texture = SKTexture(image: switchOffImage!)
        }
        super.setState(state: state)
    }
    
}
