//
//  UICollectionViewCell+Extension.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 27.05.2021.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
