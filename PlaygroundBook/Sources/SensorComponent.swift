//
//  SensorComponent.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-14.
//

import UIKit

class SensorComponent: Component, Tappable {
    
    func handleTap() {
        setState(state: !getState())
    }
    
    private var state: Bool = false
    
    func setState(state: Bool) {
        self.state = state
    }
    
    func getState() -> Bool{
        return state
    }
    
}
