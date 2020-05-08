//
//  CountryListCell2.swift
//  COVID19
//
//  Created by Fei Su on 2020-04-06.
//  Copyright © 2020 Fei Su. All rights reserved.
//

import UIKit

class CountryListCell2: UITableViewCell {

    @IBOutlet weak var numberView: LabelWithBackground!
    @IBOutlet weak var keyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
    }
    
    func populateContent(row: Int, number: Int, title: String){
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:number))
        numberView.text = formattedNumber ?? "\(number)"
        
        self.keyLabel.text = title
        
        switch row {
        case 0:
            numberView.backgroundColor = #colorLiteral(red: 0.1654336332, green: 0.1654336332, blue: 0.1654336332, alpha: 1)
            numberView.textColor = UIColor.white
        case 1:
            numberView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            numberView.textColor = UIColor.darkText
        case 2:
            numberView.backgroundColor = #colorLiteral(red: 0.7764362374, green: 0, blue: 0.01001887653, alpha: 1)
            numberView.textColor = UIColor.white
        case 3:
            numberView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            numberView.textColor = UIColor.white
        default:
            break
        }
    }
}
