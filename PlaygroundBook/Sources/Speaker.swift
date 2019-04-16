//
//  Speaker.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-16.
//

import UIKit
import SpriteKit
import AVFoundation

public class Speaker: Analog, Actuating {
    private let switchOffImage = UIImage(named: "Speaker.png")
    private var audioPlayer = AVAudioPlayer()
    
    func recieveInstruction(instruction: Double) {
        setState(state: instruction)
    }
    
    func recieveInstruction(instruction: Bool) {
        print("Bool instruction sent to analog component - Speaker")
    }
    
    func setup() {
        
        // Start alarm sound
        let backgroundMusicPath = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm", ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicPath)
        } catch  {
            print("error")
        }
        
        audioPlayer.volume = 0.0
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        self.texture = SKTexture(image: switchOffImage!)
        anchor = Anchor(color: UIColor.clear, size: CGSize(width: 0.035, height: 0.045))
        anchor?.name = "Anchor"
        anchor?.position = CGPoint(x: 0, y: 0.03)
        anchor?.setup(sprite: self)
        addChild(anchor!)
    }
    
    override func setState(state: Double) {
        audioPlayer.volume = Float(state)
        super.setState(state: state)
    }
    
    
}
