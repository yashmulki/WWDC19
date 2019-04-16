//
//  Pin.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-15.
//

import UIKit
import SpriteKit

public class Pin: SKSpriteNode {
    var connection: Wire?
    
    func getPositionInParent() -> CGPoint {
        return convert(CGPoint(x: 0, y: 0), to: parent!.parent!)
    }
    
    func setConnection(wire: Wire) {
        if connection != nil {
            guard let current = connection else {return}
            guard let other = current.getOtherNode(forNode: self) as? Component else { return }
            other.forceRemoveConnection()
            current.removeFromParent()
        }
        connection = wire
    }
    
    func forceRemoveConnection() {
        connection = nil
    }
    
 
    func sendInput(input: Bool) {
        guard let otherNode = connection?.getOtherNode(forNode: self) as? Digital else { return}
        guard let other = otherNode as? Actuating else {return}
        other.recieveInstruction(instruction: input)
    }
    
    func sendInput(input: Double) {
        guard let otherNode = connection?.getOtherNode(forNode: self) as? Analog else {return}
        guard let other = otherNode as? Actuating else {return}
        other.recieveInstruction(instruction: input)
    }
    
    
    func getInput() -> Bool {
        // Send message across wire
        guard let otherNode = connection?.getOtherNode(forNode: self) as? Digital else {return false}
        guard let other = otherNode as? Sensing else {return false}
        return other.sendInstruction()
    }
    
    
    func getInput() -> Double {
        guard let otherNode = connection?.getOtherNode(forNode: self) as? Analog else {return 0.0}
        guard let other = otherNode as? Sensing else {return 0.0}
        return other.sendInstruction()
    }

}
