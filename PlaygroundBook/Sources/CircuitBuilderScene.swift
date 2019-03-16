//
//  CircuitBuilderScene.swift
//  PlaygroundBook
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

protocol Moveable {
    func moveConnections()
}

protocol Tappable {
    func handleTap()
}

protocol Anchor {
    func createConnection(withWire:Wire)
}

protocol SensorAnchor: Anchor {
    func sendState(state: Bool)
}

protocol ActuatorAnchor: Anchor {
    func transferState(state:Bool)
}

protocol Actuator {
    func handleReceivedState(state:Bool, fromPin: Int)
}

import UIKit
import SpriteKit
import AVFoundation

class CircuitBuilderScene: SKScene {
    
    // All mutable nodes in scene
    private var mutableChildren:[Component] = []
    
    // Graphics
    private var width: CGFloat!
    private var height: CGFloat!
    
    // Node actions
    private var lastTouchedNode: SKNode? = nil
    private var lastTouchPosition: CGPoint? = nil
    
    // Nodes
    private var microcontrollerNode = Microcontroller()
    
    convenience init(configuration: [String: Bool]) {
        self.init()
    }
    
    func addComponent(atPosition: CGPoint, ofType: String) {
        switch ofType {
        case "Switch":
            let switchNode = Switch(color: UIColor.clear, size: CGSize(width: 0.075, height: 0.075))
            switchNode.position = atPosition
            switchNode.setup()
            self.addChild(switchNode)
        case "LightSensor":
            break
        default:
            break
        }
    }
    
    override func didMove(to view: SKView) {
        // Calculate required values
        width = view.frame.width
        height = view.frame.height
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        // Set up background and add to scene
        let backgroundTexture = SKTexture(imageNamed: "BuilderBackground.png")
        let backgroundNode = SKSpriteNode(texture: backgroundTexture, size: CGSize(width: 0.5, height: 1))
        backgroundNode.name = "Background"
        backgroundNode.position = CGPoint(x: 0.25, y: 0.5)
        self.addChild(backgroundNode)
        
        // Add microcontroller node
        microcontrollerNode = Microcontroller(color: UIColor.clear, size: CGSize(width: 0.269, height: 0.275))
        microcontrollerNode.position = CGPoint(x: 0.2, y: 0.7)
        microcontrollerNode.setup()
        microcontrollerNode.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(microcontrollerNode)
    }
    
}

// Handle dragging around moveable nodes
extension CircuitBuilderScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let position = touch.location(in: self)
        let touchedNode = self.nodes(at: position).first { (node) -> Bool in
            return node is Moveable
        }
        lastTouchedNode = touchedNode
        
        if lastTouchPosition == nil {
            lastTouchPosition = position
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        guard let end = lastTouchPosition else {return}
        let position = touch.location(in: self)
        let dist = calcDistance(first: end, second: position)
        let touchedNode = self.nodes(at: position).first { (node) -> Bool in
            return node is Tappable
        }
        if (dist < 0.0005) {
            guard let node = touchedNode as? Tappable else {return}
            node.handleTap()
        }
        lastTouchPosition = nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        panForTranslation(translation: translation)
    }
    
    func panForTranslation(translation: CGPoint) {
        guard let lastTouched = lastTouchedNode else {return}
        let position = lastTouched.position
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        lastTouched.position = aNewPosition
    }

    func calcDistance(first: CGPoint, second: CGPoint) -> Float {
        return hypotf(Float(second.x - first.x), Float(second.y - first.y));
    }
    
    
}

extension CircuitBuilderScene {
//    func drawWire(wire: Wire) {
//        guard let first = wire.component1 as? SKNode else { return }
//        guard let second = wire.component2 as? SKNode else {return}
//       // let startingPos = convert(first.position, from: parent!)
//        //let endingPos = convert(second.position, from: parent!)
//        drawLine(fromPoint: first.position, toPoint: second.position)
//    }
//    
//    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
//        let path = CGMutablePath()
//        path.move(to: fromPoint)
//        path.addLine(to: toPoint)
//        var layer = CAShapeLayer()
//        layer.path = path
//        layer.strokeColor = UIColor.red.cgColor
//        layer.lineWidth = 1.0
//        layer.zPosition = 5
//        view?.layer.addSublayer(layer)
//        
//    }
}

