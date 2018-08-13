//
//  RulesViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 03.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Rules"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
