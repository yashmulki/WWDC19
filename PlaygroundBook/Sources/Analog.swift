//
//  Analog.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-16.
//

import UIKit

public class Analog: Component {
    private var state = 0.0
    
    func setState(state: Double) {
        self.state = state
    }
    
    func getState() -> Double {
        return state
    }
}
