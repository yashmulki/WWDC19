//
//  Switch.swift
//  PlaygroundBook
//
//  Created by Yashvardhan Mulki on 2019-03-15.
//

import UIKit
import SpriteKit

public class Switch: Digital, Tappable, Sensing {
    public func sendInstruction() -> Bool {
        return getState()
    }
    
    public func sendInstruction() -> Double {
        return 0.0
    }

    private let switchOffImage = UIImage(named: "Switch_Off.png")
    private let switchOnImage = UIImage(named: "Switch_On.png")
    
    func setup() {
        let startingTexture = SKTexture(image: switchOffImage!)
        self.texture = startingTexture
        anchor = Anchor(color: UIColor.clear, size: CGSize(width: 0.03, height: 0.04))
        anchor?.name = "Anchor"
        anchor?.position = CGPoint(x: 0, y: 0.03)
        anchor?.setup(sprite: self)
        addChild(anchor!)
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
    
    public func handleTap() {
        setState(state: !getState())
    }
    
}
