//
//  Wire.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit
import SpriteKit

public class Wire: SKSpriteNode {
    var start: SKSpriteNode?
    var end: SKSpriteNode?
    
    func getOtherNode(forNode: SKSpriteNode) -> SKSpriteNode{
        guard let s = start else {return forNode}
        guard let e = end else {return forNode}
        if s.isEqual(forNode) {
            return e
        }
        return s
    }
    
    func configure(withNodes node1: SKSpriteNode, node2: SKSpriteNode) {
        start = node1
        end = node2
//        var circleNode1 = SKSpriteNode(color: .white, size: CGSize(width: 0.1, height: 0.1))
//        var circleNode2 = SKSpriteNode(color: .white, size: CGSize(width: 0.1, height: 0.1))
//        circleNode1.position = CGPoint(x: 0.5, y: 0)
//        circleNode2.position = CGPoint(x: 0.5, y: 1)
//        addChild(circleNode1)
//        addChild(circleNode2)
    }
    
}
