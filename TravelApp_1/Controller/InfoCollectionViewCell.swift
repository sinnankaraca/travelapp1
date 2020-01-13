//
//  InfoCollectionViewCell.swift
//  TravelApp_1
//
//  Created by Sinan MacBook on 12.12.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    
    override func awakeFromNib() {
        infoImage.layer.cornerRadius = 15
        infoImage.clipsToBounds = true
    }
    
    
}
