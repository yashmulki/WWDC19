//
//  CircuitBuilderViewController.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit
import PlaygroundSupport
import SpriteKit
import AVFoundation

var audioPlaybackTime = 0.0

@objc(Book_Sources_CircuitBuilderViewController)
public class CircuitBuilderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PlaygroundLiveViewSafeAreaContainer {
    
    public var items: [String] = ["Switch", "Red LED", "Green LED", "Blue LED", "Light Sensor", "Speaker", "Air Probe"]
    public var images: [String] = ["Switch_On.png", "REDLed.png", "GreenLED.png", "BlueLED.png", "LightSensor.png", "Speaker.png", "SmokeDetector.png"]
    public var configuration: [String:Bool] = [:];
    public var builderView: SKView = SKView()
    public var builderScene: CircuitBuilderScene?
    public var itemsCollection: UICollectionView!
    public var currentType: String?
    var audioPlayer = AVAudioPlayer()
    private var type = ""
    
    func configure(type: String) {
        self.type = type
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        // Set up spritekit scene
        builderView = SKView(frame: self.view.frame)
        builderScene = CircuitBuilderScene(configuration: configuration)
        builderView.presentScene(builderScene)
        self.view.addSubview(builderView)
        
        // Add components row and configure - kinda works right now
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        itemsCollection = UICollectionView(frame: CGRect(x: view.frame.minX + 20, y: view.frame.maxY - 250, width: view.frame.width/2 - 40, height: 140), collectionViewLayout: layout)
        itemsCollection.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: "component")
        itemsCollection.dataSource = self
        itemsCollection.delegate = self
        itemsCollection.dragDelegate = self
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = itemsCollection.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        itemsCollection.backgroundView = UIView(frame: itemsCollection.bounds)
        itemsCollection.backgroundView?.backgroundColor = UIColor.clear
        itemsCollection.backgroundView?.addSubview(blurEffectView)
        itemsCollection.layer.cornerRadius = 10.0
        itemsCollection.layer.borderWidth = 0.1
        itemsCollection.layer.borderColor = UIColor.gray.cgColor
        itemsCollection.clipsToBounds = true
        itemsCollection.backgroundColor = UIColor.clear
        itemsCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        view.addSubview(itemsCollection)
        
        // Set up drop interaction
        let dropInteraction = UIDropInteraction(delegate: self)
        builderView.addInteraction(dropInteraction)
        
        // Set up audio player
        let backgroundMusicPath = URL(fileURLWithPath: Bundle.main.path(forResource: "backgroundmusic", ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicPath)
        } catch  {
            print("error")
        }
        
        audioPlayer.volume = 0.2
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        let label = UILabel(frame: CGRect(x: view.frame.minX + 20, y: view.frame.maxY - 300, width: 60, height: 44))
        let label2 = UILabel(frame: CGRect(x: view.frame.minX + view.frame.width/8 + 110, y: view.frame.maxY - 300, width: 60, height: 44))
        let slider = UISlider(frame: CGRect(x: view.frame.minX + 80, y: view.frame.maxY - 300, width: view.frame.width/8, height: 44))
        let slider2 = UISlider(frame: CGRect(x: view.frame.minX + 170 + view.frame.width/8, y: view.frame.maxY - 300, width: view.frame.width/8, height: 44))
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider2.minimumValue = 0.0
        slider2.maximumValue = 1.0
        
        if (type == "Light") {
            label.text = "Light"
            slider.addTarget(self, action: #selector(CircuitBuilderViewController.lightChanged(sender:)), for: .valueChanged)
            view.addSubview(label)
            view.addSubview(slider)
        } else if (type == "Smoke") {
            label.text = "Smog"
            slider.addTarget(self, action: #selector(CircuitBuilderViewController.smokeChanged(sender:)), for: .valueChanged)
            view.addSubview(slider)
            view.addSubview(label)
        } else if (type == "Sandbox") {
            label.text = "Light"
            label2.text = "Smog"
            slider.addTarget(self, action: #selector(CircuitBuilderViewController.lightChanged(sender:)), for: .valueChanged)
            slider2.addTarget(self, action: #selector(CircuitBuilderViewController.smokeChanged(sender:)), for: .valueChanged)
            view.addSubview(label)
            view.addSubview(label2)
            view.addSubview(slider)
            view.addSubview(slider2)
        }
        
    }
    
    @objc func smokeChanged(sender: UISlider) {
        smokeIntensity = Double(sender.value)
        smokeOverlay.alpha = CGFloat(sender.value/2)
    }
    
    @objc func lightChanged(sender: UISlider) {
        lightIntensity = Double(sender.value)
    }
    
}



// Handle items row
extension CircuitBuilderViewController {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "component", for: indexPath) as! ComponentCollectionViewCell
        cell.setup(name: items[indexPath.row], image: images[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 130)

    }

}

// Handle drag and drop
extension CircuitBuilderViewController: UICollectionViewDragDelegate, UIDropInteractionDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        currentType = items[indexPath.row]
        return [item]
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = UIColor.clear
        return parameters
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: self.view)
        let operation: UIDropOperation
        if builderView.frame.contains(dropLocation) {
            operation = .copy
        } else {
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let current = currentType else {return}
        let dropLocation = session.location(in: builderView)
        guard let scene = builderView.scene as? CircuitBuilderScene else {return}
        scene.addComponent(atPosition: scene.convertPoint(fromView: dropLocation), ofType: current)
        currentType = nil
    }
    
    
}

extension CircuitBuilderViewController: PlaygroundLiveViewMessageHandler {
    
    public func receive(_ message: PlaygroundValue) {
        guard let scene = builderScene else {return}
        let controller = scene.microcontrollerNode

        // Process and handle messages
        if case let .dictionary(text) = message {
            if case let .string(type) = text["Type"]! {
                var pin = 0
                if case let .integer(currentPin) = text["Pin"]! {
                    pin = currentPin
                }
                if type == "Configure" {
                    if case let .string(pintype) = text["PinType"]! {
                        let type = PinType(rawValue: pintype)!
                        controller.configurePin(for: pin, type: type)
                    }
                } else if type == "WriteBool" {
                    if case let .boolean(data) = text["Data"]! {
                        controller.writeBool(to: pin, value: data)
                    }
                } else if type == "ReadBool" {
                   // Send pin value
                    self.send(.dictionary(["Pin" : .integer(pin), "Value" : .boolean(controller.readBool(from: pin))]))
                } else if type == "WriteDouble" {
                    if case let .floatingPoint(data) = text["Data"]! {
                        controller.writeDouble(to: pin, value: data)
                    }
                } else {
                    self.send(.dictionary(["Pin" : .integer(pin), "Value" : .floatingPoint(controller.readDouble(from: pin))]))
                }
            }
        }
        
        
    }
}


class MessageHandler: PlaygroundRemoteLiveViewProxyDelegate {
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundSupport.PlaygroundRemoteLiveViewProxy) {
        fatalError()
    }
    
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundSupport.PlaygroundRemoteLiveViewProxy, received message: PlaygroundSupport.PlaygroundValue) {
        
    }
}
