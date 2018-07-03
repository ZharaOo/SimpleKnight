//
//  FinishView.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 01.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

protocol FinishViewDelegate: class {
    func goToMainMenu()
}

class FinishView: UIView {
    @IBOutlet weak var scoreLabel: UILabel!
    
    weak var delegate: FinishViewDelegate!
    
    class func instanceFromNib(score: Int, bestScore: Int) -> FinishView {
        let fv = UINib(nibName: "FinishView", bundle: nil).instantiate(withOwner: nil, options:nil)[0] as! FinishView
        fv.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        fv.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        
        fv.scoreLabel.text = "Score: \(score) \n\nBest: \(bestScore)"
        fv.scoreLabel.layer.masksToBounds = true
        fv.scoreLabel.layer.cornerRadius = 30.0
        fv.scoreLabel.adjustsFontSizeToFitWidth = true
        return fv
    }
    
    @IBAction func mainMenu(_ sender: Any) {
        delegate.goToMainMenu()
    }
}
