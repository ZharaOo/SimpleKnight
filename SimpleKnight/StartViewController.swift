//
//  ViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitleColor(.black, for: .normal)
    }
}

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

