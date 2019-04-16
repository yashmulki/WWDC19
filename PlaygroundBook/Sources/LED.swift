//
//  LED.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-16.
//

import UIKit
import SpriteKit

public class LED: Digital, Actuating {
    
    func recieveInstruction(instruction: Bool) {
        setState(state: instruction)
    }
    
    func recieveInstruction(instruction: Double) {
        print("Double instruction sent to digital component - LED")
    }
    
    func setup() {
        anchor = Anchor(color: UIColor.clear, size: CGSize(width: 0.03, height: 0.04))
        anchor?.setup(sprite: self)
        anchor?.position = CGPoint(x: 0, y: 0.04)
        addChild(anchor!)
    }

}
