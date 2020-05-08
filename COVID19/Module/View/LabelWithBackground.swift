//
//  LabelWithBackground.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-05.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import UIKit
import EasyPeasy

class LabelWithBackground: UIView {
    
    var textColor: UIColor = .black {
        didSet {
            label.textColor = self.textColor
        }
    }
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView(){
        self.layer.cornerRadius = 9
        label.textAlignment = .right
        label.sizeToFit()
        self.addSubview(label)
        label.easy.layout(Top(), Bottom(), Left(8), Right(8))
    }
}
