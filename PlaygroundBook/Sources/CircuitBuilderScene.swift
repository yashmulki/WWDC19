//
//  CircuitBuilderScene.swift
//  PlaygroundBook
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//


import UIKit
import SpriteKit
import AVFoundation

var smokeOverlay = SKSpriteNode()

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
    private var binNode = SKSpriteNode()

    // Wires
    var currentLine: Wire?
    var lines:[Wire] = []
    var lineDownPoint: CGPoint?
    var startNode: SKSpriteNode?
    var isBuildingWire: Bool = false
    
    // Sound and Haptics
    private var audioPlayer = AVAudioPlayer()
    
    convenience init(configuration: [String: Bool]) {
        self.init()
    }
    
    func addComponent(atPosition: CGPoint, ofType: String) {
        switch ofType {
        case "Switch":
            let switchNode = Switch(color: UIColor.clear, size: CGSize(width: 0.09, height: 0.09))
            switchNode.position = atPosition
            switchNode.setup()
            self.addChild(switchNode)
        case "Red LED":
            let ledNode = RedLED(color: UIColor.clear, size: CGSize(width: 0.09, height: 0.125))
            ledNode.position = atPosition
            ledNode.setup()
            self.addChild(ledNode)
        case "Green LED":
            let ledNode = GreenLED(color: UIColor.clear, size: CGSize(width: 0.09, height: 0.125))
            ledNode.position = atPosition
            ledNode.setup()
            self.addChild(ledNode)
        case "Blue LED":
            let ledNode = BlueLED(color: UIColor.clear, size: CGSize(width: 0.09, height: 0.125))
            ledNode.position = atPosition
            ledNode.setup()
            self.addChild(ledNode)
        case "Light Sensor":
            let sensor = LightSensor(color: UIColor.clear, size: CGSize(width: 0.09, height: 0.125))
            sensor.position = atPosition
            sensor.setup()
            self.addChild(sensor)
        case "Speaker":
            let speaker = Speaker(color: UIColor.clear, size: CGSize(width: 0.1, height: 0.15))
            speaker.position = atPosition
            speaker.setup()
            self.addChild(speaker)
        case "Air Probe":
            let detector = SmokeDetector(color: UIColor.clear, size: CGSize(width: 0.09, height: 0.125))
            detector.position = atPosition
            detector.setup()
            self.addChild(detector)
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
        let backgroundTexture = SKTexture(imageNamed: "Background.png")
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
        
        // Add bin to dispose of components
        binNode = SKSpriteNode(texture: SKTexture(imageNamed: "Bin.png"), size: CGSize(width: 0.156, height: 0.265))
        binNode.position = CGPoint(x: 0.1, y: 0.825)
        binNode.name = "Bin"
        self.addChild(binNode)
        
        // Set up audio player
        let backgroundMusicPath = URL(fileURLWithPath: Bundle.main.path(forResource: "click", ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicPath)
        } catch  {
            print("error")
        }
        
        audioPlayer.volume = 1.0
        audioPlayer.numberOfLoops = 1

        // Add smoke overlay
        smokeOverlay = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: 0.5, height: 1.0))
        smokeOverlay.alpha = 0.0
        smokeOverlay.position = CGPoint(x: 0.25, y: 0.5)
        self.addChild(smokeOverlay)
    }
    
}

// Handle dragging around moveable nodes
extension CircuitBuilderScene {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let position = touch.location(in: self)
        
        let anchor = self.nodes(at: position).first { (node) -> Bool in
            return node is Anchor || node is Pin
        }
        
        if anchor != nil {
            startNode = anchor as? SKSpriteNode
            currentLine = Wire(color: UIColor.lightGray, size: CGSize(width: 0.002, height: 0.01))
            currentLine?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            currentLine?.position = position
            lineDownPoint = position
            addChild(currentLine!)
            audioPlayer.prepareToPlay()
            isBuildingWire = true
            return
        }
        
        
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
        
        if isBuildingWire {
            guard let current = currentLine else {return}
            guard let start = startNode else {return}
            guard let location = touches.first?.location(in: self) else {return}
            let node = self.nodes(at: location).first { (node) -> Bool in
                return node is Anchor || node is Pin
            }
            if node != nil && node != start {
                if !((node is Anchor && start is Anchor) || node is Pin && start is Pin) {
                    if start is Pin {
                        let spriteParent = (node as! Anchor).spriteParent!
                        current.configure(withNodes: start, node2: spriteParent)
                        guard let pin = start as? Pin else {return}
                        guard let anchor = node as? Anchor else {return}
                        pin.setConnection(wire: current)
                        anchor.spriteParent?.setConnection(wire: current)
                    } else {
                        let spriteParent = (start as! Anchor).spriteParent!
                        current.configure(withNodes: spriteParent, node2: node as! SKSpriteNode)
                        guard let pin = node as? Pin else {return}
                        guard let anchor = start as? Anchor else {return}
                        pin.setConnection(wire: current)
                        anchor.spriteParent?.setConnection(wire: current)
                    }
                    audioPlayer.play()
                    lines.append(current)
                } else {
                    current.removeFromParent()
                }
            } else {
                current.removeFromParent()
            }
            currentLine = nil
            lineDownPoint = nil
            isBuildingWire = false
            return
        }
        
        // Check for bin
        let binNode = nodes(at: position).first { (node) -> Bool in
            return node.name == "Bin"
        }
        let otherNode = nodes(at: position).first { (node) -> Bool in
            return node is Component
        }
        
        if binNode != nil {
            if let node = otherNode as? Component {
                node.setConnection(wire: Wire())
                node.removeFromParent()
            }
        }
        
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
        
        if isBuildingWire {
            guard let current = currentLine else {return}
            guard let newLocation = touches.first?.location(in: self) else {return}
            guard let origin = lineDownPoint else {return}
            let distance = hypot(newLocation.x - origin.x, newLocation.y - origin.y)
            let vector = CGVector(dx: newLocation.x - origin.x, dy: newLocation.y - origin.y)
            let straight = CGVector(dx:0, dy: 1)
            let angle = atan2(vector.dy, vector.dx) - atan2(straight.dy, straight.dx)
            current.zRotation = angle
            current.size.height = distance
            current.position = origin
            return
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
        
        if lastTouched is Component {
            let last = lastTouched as! Component
            last.moveConnections()
        }
        
    }

    func calcDistance(first: CGPoint, second: CGPoint) -> Float {
        return hypotf(Float(second.x - first.x), Float(second.y - first.y));
    }

    
}
