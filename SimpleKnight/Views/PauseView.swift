//
//  PauseView.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 03.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class PauseButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.setTitleColor(.white, for: .normal)
    }
}

protocol PauseViewDelegate: FinishViewDelegate {
    func resumeGame()
    func playAgainGame()
}

class PauseView: UIView {
    weak var delegate: PauseViewDelegate!
    
    class func instanceFromNib(score: Int, bestScore: Int) -> PauseView {
        let fv = UINib(nibName: "PauseView", bundle: nil).instantiate(withOwner: nil, options:nil)[0] as! PauseView
        fv.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        fv.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        fv.alpha = 0.0
        return fv
    }
    
    func show() {
        UIView.animate(withDuration: 0.5, animations: { self.alpha = 1 })
    }

    func remove() {
        UIView.animate(withDuration: 0.5, animations: { self.alpha = 0.0 }, completion: { completion in self.removeFromSuperview() })
    }
    
    @IBAction func resume(_ sender: Any) {
        delegate.resumeGame()
        self.remove()
    }
    
    @IBAction func playAgain(_ sender: Any) {
        delegate.playAgainGame()
        self.remove()
    }
    
    @IBAction func mainMenu(_ sender: Any) {
        delegate.goToMainMenu()
    }
}
