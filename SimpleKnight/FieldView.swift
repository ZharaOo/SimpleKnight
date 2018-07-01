//
//  FieldView.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

protocol FieldViewDelegate: class {
    func moveMade(score: Int)
}

internal class CellButton: UIButton {
    var occupied = false
    var score: Int = 0
    
    var location: CGPoint {
        return CGPoint(x: self.frame.minX / self.frame.width, y: self.frame.minY / self.frame.height)
    }
    
    func setScore() {
        if !occupied {
            self.setBackgroundImage(UIImage(), for: .normal)
            
            let probability = arc4random() % 100
            if probability < 5 {
                let s = Score.getRandomScore()
                self.setBackgroundImage(UIImage(named: "Score\(s.rawValue)Image"), for: .normal)
                score = 50 + s.rawValue
                
                return
            }
        }
        
        score = 50
    }
    
    static func indexOf(_ location: CGPoint) -> Int {
        return Int(location.x * 8 + location.y)
    }
}

class FieldView: UIView {
    
    internal var buttons = [CellButton]()
    var initialized = false
    var interactionAllowed = true
    var figure = Knight()
    
    override func layoutSubviews() {
        if !initialized {
            createButtons()
            initialized = true
        }
    }
    
    func createButtons() {
        let cellWidth = self.frame.width / 8
        let cellHeight = self.frame.width / 8
        
        for i in 0..<8 {
            for j in 0..<8 {
                let button = CellButton(frame: CGRect(x: CGFloat(i) * cellWidth, y: CGFloat(j) * cellHeight, width: cellWidth, height: cellHeight))
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
                buttons.append(button)
                self.addSubview(button)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let cellWidth = self.frame.width / 8
        let cellHeight = self.frame.height / 8
        
        for i in 0...8 {
            path.move(to: CGPoint(x: CGFloat(i) * cellWidth, y: 0.0))
            path.addLine(to: CGPoint(x: CGFloat(i) * cellWidth, y: self.frame.height))
            
            path.move(to: CGPoint(x: 0.0, y: CGFloat(i) * cellHeight))
            path.addLine(to: CGPoint(x: self.frame.width, y: CGFloat(i) * cellHeight))
        }
        
        UIColor.black.set()
        path.stroke()
        
        path.close()
    }
    
    func hideKnight() {
        interactionAllowed = false
        buttons[Int(figure.location.x * 8 + figure.location.y)].alpha = 0.0
    }
    
    @objc @IBAction internal func buttonPressed(_ sender: CellButton) {}
}
