//
//  CircuitBuilderViewController.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit
import SpriteKit

class CircuitBuilderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var items: [String] = ["Switch", "LightSensor"]
    private var images: [String] = ["Switch_On.png", "photoresistor.png"]
    private var configuration: [String:Bool] = [:];
    private var builderView: SKView = SKView()
    private var itemsCollection: UICollectionView!
    private var currentType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        // Set up spritekit scene
        builderView = SKView(frame: self.view.frame)
        let scene = CircuitBuilderScene(configuration: configuration)
        builderView.presentScene(scene)
        self.view.addSubview(builderView)
        
        // Add components row and configure - kinda works right now
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        itemsCollection = UICollectionView(frame: CGRect(x: view.frame.minX + 20, y: view.frame.maxY - 220, width: view.frame.width/2 - 40, height: 140), collectionViewLayout: layout)
        itemsCollection.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: "component")
        itemsCollection.dataSource = self
        itemsCollection.delegate = self
        itemsCollection.dragDelegate = self
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = itemsCollection.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        itemsCollection.backgroundView = UIView(frame: itemsCollection.bounds)
        itemsCollection.backgroundView?.backgroundColor = UIColor.clear
        itemsCollection.backgroundView?.addSubview(blurEffectView)
        itemsCollection.layer.cornerRadius = 10.0
        itemsCollection.layer.borderWidth = 0.5
        itemsCollection.layer.borderColor = UIColor.black.cgColor
        itemsCollection.clipsToBounds = true
        itemsCollection.backgroundColor = UIColor.clear
        view.addSubview(itemsCollection)
        
        // Set up drop interaction
        let dropInteraction = UIDropInteraction(delegate: self)
        builderView.addInteraction(dropInteraction)
        
        // Set up gesture recognizer - to do
        
    }
    
}

// Handle items row
extension CircuitBuilderViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "component", for: indexPath) as! ComponentCollectionViewCell
        cell.setup(name: items[indexPath.row], image: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 130)
    }

}

// Handle drag and drop
extension CircuitBuilderViewController: UICollectionViewDragDelegate, UIDropInteractionDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        currentType = items[indexPath.row]
        return [item]
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = UIColor.clear
        return parameters
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: self.view)
        let operation: UIDropOperation
        if builderView.frame.contains(dropLocation) {
            operation = .copy
        } else {
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let current = currentType else {return}
        let dropLocation = session.location(in: builderView)
        guard let scene = builderView.scene as? CircuitBuilderScene else {return}
        scene.addComponent(atPosition: scene.convertPoint(fromView: dropLocation), ofType: current)
        currentType = nil
    }
    
    
}

