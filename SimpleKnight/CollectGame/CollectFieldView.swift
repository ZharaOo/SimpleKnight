//
//  CollectFieldView.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class CollectFieldView: FieldView {
    weak var delegate: FieldViewDelegate!
    
    var enemies = [CGPoint]()
    var collectPoint = CGPoint(x: 0, y: 0)
    
    override func awakeFromNib() {
        figure = Knight(location: CGPoint(x: 0, y: 0))
        buttons[CellButton.indexOf(figure.location)].occupied = true
        setCollectPointAndEnemies()
    }
    
    override func buttonPressed(_ sender: CellButton) {
        if figure.canMakeMove(to: sender.location) {
            buttons[CellButton.indexOf(figure.location)].occupied = false
            buttons[CellButton.indexOf(figure.location)].setBackgroundImage(UIImage(), for: .normal)
            figure.move(to: sender.location)
            buttons[CellButton.indexOf(figure.location)].setBackgroundImage(UIImage(named: "KnightImage"), for: .normal)
            buttons[CellButton.indexOf(figure.location)].occupied = true
            
            if sender.occupied {
                if sender.location == collectPoint {
                    delegate.moveMade(score: 200)
                    
                    setCollectPointAndEnemies()
                    buttons.forEach() { $0.setScore() }
                }
                else if enemies.contains(sender.location) {
                    delegate.moveMade(score: -200)
                }
            }
            else {
                sender.occupied = true
                delegate.moveMade(score: sender.score - 50)
            }
        }
    }
    
    func setCollectPointAndEnemies() {
        clearCellsImages()
        generateCollectPoint(figureLocation: figure.location)
        generateEnemies(figureLocarion: figure.location, collectPointLocation: collectPoint)
    }
    
    func generateCollectPoint(figureLocation: CGPoint) {
        var collectPoint = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
        while collectPoint ==  figureLocation {
            collectPoint = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
        }
        
        self.collectPoint = collectPoint
        buttons[CellButton.indexOf(self.collectPoint)].setBackgroundImage(UIImage(named: "EnemyImage"), for: .normal)
        buttons[CellButton.indexOf(self.collectPoint)].occupied = true
    }
    
    func generateEnemies(figureLocarion: CGPoint, collectPointLocation: CGPoint) {
        var hEnemies = [CGPoint]()
        
        let numberOfEnemies = 1 + arc4random() % 8
        
        for _ in 0...numberOfEnemies {
            var enemyLocation = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
            while enemyLocation == figureLocarion || enemyLocation == collectPointLocation || hEnemies.contains(enemyLocation) {
                enemyLocation = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
            }
            
            hEnemies.append(enemyLocation)
        }
        
        self.enemies = hEnemies
        self.enemies.forEach() { enemy in
            buttons[CellButton.indexOf(enemy)].setBackgroundImage(UIImage(named: "EnemyImage"), for: .normal)
            buttons[CellButton.indexOf(enemy)].occupied = true
        }
    }
    
    func clearCellsImages() {
        enemies.forEach() { enemy in
            buttons[CellButton.indexOf(enemy)].setBackgroundImage(UIImage(), for: .normal)
            buttons[CellButton.indexOf(enemy)].occupied = false
        }
        
        buttons[CellButton.indexOf(collectPoint)].setBackgroundImage(UIImage(), for: .normal)
        buttons[CellButton.indexOf(collectPoint)].occupied = false
    }
}
