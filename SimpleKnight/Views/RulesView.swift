//
//  RulesView.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 02.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class RulesView: UIView {
    
    private var textView: UITextView!

    override init(frame: CGRect) {
        textView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height))
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 18)
        
        self.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        textView = nil
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String) {
        textView.text = text
        
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame;
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height);
        textView.frame = newFrame;
        textView.center = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5);
    }
    
}
