//
//  Knight.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class Knight: NSObject {
    private(set) var location: CGPoint!
    
    override init() {}
    
    init(location: CGPoint) {
        self.location = location
    }
    
    func canMakeMove(to location:CGPoint) -> Bool {
        if self.location == nil {
            return true
        }
        
        let l = CGPoint(x: fabs(self.location.x - location.x), y: fabs(self.location.y - location.y))
        
        if (l.x == 2 && l.y == 1) || (l.x == 1 && l.y == 2) {
            return true
        }
        
        return false
    }
    
    func move(to location: CGPoint) {
        self.location = location
    }
}
