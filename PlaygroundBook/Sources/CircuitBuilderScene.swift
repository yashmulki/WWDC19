//
//  CircuitBuilderScene.swift
//  PlaygroundBook
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//


import UIKit
import SpriteKit
import AVFoundation

public class CircuitBuilderScene: SKScene {
    
    // All mutable nodes in scene
    private var mutableChildren:[Component] = []
    
    // Graphics
    private var width: CGFloat!
    private var height: CGFloat!
    
    // Node actions
    private var lastTouchedNode: SKNode? = nil
    private var lastTouchPosition: CGPoint? = nil
    
    // Nodes
    public var microcontrollerNode = Microcontroller()
    private var isMakingWire: Bool = false
    private var currentWire: Wire?
    private var wireOrigin: CGPoint?
    private var wireOriginNode: SKSpriteNode?
    private var wires: [Wire] = []
    
    convenience init(configuration: [String: Bool]) {
        self.init()
    }
    
    func addComponent(atPosition: CGPoint, ofType: String) {
        switch ofType {
        case "Switch":
            let switchNode = Switch(color: UIColor.clear, size: CGSize(width: 0.075, height: 0.075))
            switchNode.position = atPosition
            switchNode.setup()
            let wire = Wire()
            wire.configure(withNodes: microcontrollerNode.pins[0], node2: switchNode)
            switchNode.connection = wire
            microcontrollerNode.configurePin(for: 1, type: .digitalInput)
            microcontrollerNode.pins[0].connection = wire
            self.addChild(switchNode)
        case "RedLED":
            let ledNode = RedLED(color: UIColor.clear, size: CGSize(width: 0.075, height: 0.075))
            ledNode.position = atPosition
            ledNode.setup()
            let wire = Wire()
            wire.configure(withNodes: microcontrollerNode.pins[0], node2: ledNode)
            ledNode.connection = wire
            microcontrollerNode.configurePin(for: 1, type: .digitalOutput)
            microcontrollerNode.pins[0].connection = wire
            self.addChild(ledNode)
        case "GreenLED":
            let ledNode = GreenLED(color: UIColor.clear, size: CGSize(width: 0.075, height: 0.075))
            ledNode.position = atPosition
            ledNode.setup()
            let wire = Wire()
            wire.configure(withNodes: microcontrollerNode.pins[0], node2: ledNode)
            ledNode.connection = wire
            microcontrollerNode.configurePin(for: 1, type: .digitalOutput)
            microcontrollerNode.pins[0].connection = wire
            self.addChild(ledNode)
        case "BlueLED":
            let ledNode = BlueLED(color: UIColor.clear, size: CGSize(width: 0.075, height: 0.075))
            ledNode.position = atPosition
            ledNode.setup()
            let wire = Wire()
            wire.configure(withNodes: microcontrollerNode.pins[0], node2: ledNode)
            ledNode.connection = wire
            microcontrollerNode.configurePin(for: 1, type: .digitalOutput)
            microcontrollerNode.pins[0].connection = wire
            self.addChild(ledNode)
        case "LightSensor":
            let sensor = LightSensor(color: UIColor.clear, size: CGSize(width: 0.075, height: 0.075))
            sensor.position = atPosition
            sensor.setup()
            let wire = Wire()
            wire.configure(withNodes: microcontrollerNode.pins[0], node2: sensor)
            sensor.connection = wire
            microcontrollerNode.configurePin(for: 1, type: .analogInput)
            microcontrollerNode.pins[0].connection = wire
            self.addChild(sensor)
        case "Speaker":
            let speaker = Speaker(color: UIColor.clear, size: CGSize(width: 0.075, height: 0.075))
            speaker.position = atPosition
            speaker.setup()
            let wire = Wire()
            wire.configure(withNodes: microcontrollerNode.pins[0], node2: speaker)
            speaker.connection = wire
            microcontrollerNode.configurePin(for: 1, type: .analogOutput)
            microcontrollerNode.pins[0].connection = wire
            self.addChild(speaker)
        default:
            break
        }
    }
    
    public override func didMove(to view: SKView) {
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
        microcontrollerNode.setupBase()
        microcontrollerNode.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(microcontrollerNode)
    }
    
}

// Handle dragging around moveable nodes
extension CircuitBuilderScene {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let position = touch.location(in: self)
        
        // Check for anchor for wire drag
//        let anchor = self.nodes(at: position).first { (node) -> Bool in
//            return node is Pin
//        }
//        if anchor != nil {
//            isMakingWire = true
//            currentWire = Wire()
//            currentWire?.anchorPoint = CGPoint(x: 0, y: 1)
//            currentWire!.position = position
//            addChild(currentWire!)
//            wireOrigin = position
//            wireOriginNode = anchor!.parent! as? SKSpriteNode
//            return
//        }
        
        // If not anchor, check for moving
        let touchedNode = self.nodes(at: position).first { (node) -> Bool in
            return node is Moveable
        }
        lastTouchedNode = touchedNode
        
        if lastTouchPosition == nil {
            lastTouchPosition = position
        }
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let position = touch.location(in: self)
        
        let anchor = self.nodes(at: position).first { (node) -> Bool in
            return node is Tappable
        }
//        if anchor != nil {
//            guard let originNode = wireOriginNode as? Component else {return}
//            guard let originPoint = wireOrigin else {return}
//            guard let current = currentWire else {return}
//            current.configure(withNodes: originNode, node2: anchor!.parent! as! SKSpriteNode)
//            originNode.setConnection(wire: current)
//            wires.append(current)
//            // Update graphics
//
//            return
//        }
        // Check for tap if its not an anchor
        guard let end = lastTouchPosition else {return}
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
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let positionInScene = touch.location(in: self)
        
        // Wire stuff
        if isMakingWire {
            // Update wire position
            guard let originNode = wireOriginNode else {return}
            
        }
        
        // Check pan if not wire
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
}

