//
//  SelectorCollectionViewCell.swift
//  SelectorCollectionViewCell
//
//  Created by Osman Solomon on 14/09/2021.
//

import UIKit

public class SelectorCollectionViewCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var label: UILabel!

    public func setUpView(isSelected: Bool, text: String) {
        let boxImage = UIImage(named: "box", in: .module, compatibleWith: nil)
        image.image = boxImage
        label.text = text
        switch isSelected {
        case true:
            image.image = image.image?.resized(to: CGSize(width: 104, height: 69))
            image.alpha = 1
            label.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight(rawValue: 600))
            label.textColor = UIColor(rgb: 0xff424242)
        case false:
            image.image = image.image?.resized(to: CGSize(width: 66, height: 43))
            image.alpha = 0.7
            label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 600))
            label.textColor = UIColor(rgb: 0xffa7a7a7)
        }
    }
}
