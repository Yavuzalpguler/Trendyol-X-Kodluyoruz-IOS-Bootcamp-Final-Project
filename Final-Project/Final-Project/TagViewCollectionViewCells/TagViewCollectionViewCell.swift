//
//  TagViewCollectionViewCell.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 3.06.2021.
//

import UIKit

class TagViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var platformName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
    }

    func configure(parentPlatform: ParentPlatform) {
        platformName.text = parentPlatform.platform?.name
    }
    
    
}
