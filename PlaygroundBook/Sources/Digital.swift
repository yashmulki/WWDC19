//
//  Digital.swift
//  Book_Sources
//
//  Created by Yashvardhan Mulki on 2019-03-16.
//

import UIKit

public class Digital: Component {
    private var state = false
    
    func setState(state: Bool) {
        self.state = state
    }
    
    func getState() -> Bool {
        return state
    }
    
}
