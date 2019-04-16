//
//  Component.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit
import SpriteKit

public class Component: SKSpriteNode, Moveable {
    var connection: Wire?
    var anchor: Anchor?
    
    func forceRemoveConnection() {
        connection = nil
    }
    
    func setConnection(wire: Wire) {
        if connection != nil {
            guard let current = connection else {return}
            guard let other = current.getOtherNode(forNode: self) as? Pin else { return }
            other.forceRemoveConnection()
            current.removeFromParent()
        }
        connection = wire
    }
    
    func moveConnections() {
        // Move wire
        guard let con = connection else {return}
        guard let anc = anchor else {return}
        guard let other = con.getOtherNode(forNode: self) as? Pin else {return}
        let origin = other.getPositionInParent()
        let newLocation = convert(anc.position, to: parent!)
        
        
        let distance = hypot(newLocation.x - origin.x, newLocation.y - origin.y)
        let vector = CGVector(dx: newLocation.x - origin.x, dy: newLocation.y - origin.y)
        let straight = CGVector(dx:0, dy: 1)
        let angle = atan2(vector.dy, vector.dx) - atan2(straight.dy, straight.dx)
        con.zRotation = angle
        con.size.height = distance
        con.position = origin
    }
    
}
