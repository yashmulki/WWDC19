//
//  SmokeDetector.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-21.
//

import UIKit
import SpriteKit

public var smokeIntensity = 0.0

public class SmokeDetector: Analog, Sensing {
    
    func sendInstruction() -> Bool {
        return false
    }
    
    func sendInstruction() -> Double {
        setState(state: smokeIntensity)
        //smokeOverlay.alpha = CGFloat(smokeIntensity)
        return getState()
    }
    
    private let switchOffImage = UIImage(named: "SmokeDetector.png")
    
    func setup() {
        let startingTexture = SKTexture(image: switchOffImage!)
        self.texture = startingTexture
        setState(state: smokeIntensity)
        anchor = Anchor(color: UIColor.clear, size: CGSize(width: 0.03, height: 0.04))
        anchor?.setup(sprite: self)
        anchor?.position = CGPoint(x: 0, y: 0.05)
        addChild(anchor!)
    }
    
    
    
}
