//
//  Switch.swift
//  PlaygroundBook
//
//  Created by Yashvardhan Mulki on 2019-03-15.
//

import UIKit
import SpriteKit

class Switch: SensorComponent {
    private let switchOffImage = UIImage(named: "Switch_Off.png")
    private let switchOnImage = UIImage(named: "Switch_On.png")
    private var receptor: Receptor?
    
    func setup() {
        let startingTexture = SKTexture(image: switchOffImage!)
        self.texture = startingTexture
        receptor = Receptor(color: UIColor.red, size: CGSize(width: 0.05, height: 0.05))
        receptor!.name = "Anchor"
        receptor!.position = CGPoint(x: 0, y: 0)
        addChild(receptor!)
    }
    
    override func setState(state: Bool) {
        guard let receptor = receptor else {return}
        let newState = state
        if newState {
            self.texture = SKTexture(image: switchOnImage!)
        } else {
            self.texture = SKTexture(image: switchOffImage!)
        }
        super.setState(state: newState)
        receptor.sendState(state: newState)
    }
    
}
