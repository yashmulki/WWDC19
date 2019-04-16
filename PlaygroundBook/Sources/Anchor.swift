//
//  Anchor.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-18.
//

import UIKit
import SpriteKit

class Anchor: SKSpriteNode {
    
    
    var spriteParent: Component?
    
    func setup(sprite: Component) {
        spriteParent = sprite
        self.color = UIColor.clear
    }
    
}
