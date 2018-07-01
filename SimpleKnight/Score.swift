//
//  Score.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import Foundation

enum Score: Int {
    typealias RawValue = Int
    
    case Fifty = 50
    case OneHundred = 100
    case OneHundredFifty = 150
    case OneHundredSeventy = 170
    case TwoHundred = 200
    
    static func getRandomScore() -> Score {
        let r = arc4random() % 5
        
        switch r {
        case 0: return .Fifty
        case 1: return .OneHundred
        case 2: return .OneHundredFifty
        case 3: return .OneHundredSeventy
        default: return .TwoHundred
        }
    }
}
