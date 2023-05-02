//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 01.05.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCellList: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    
//    override func layoutSubviews() {
//          super.layoutSubviews()
//          //set the values for top,left,bottom,right margins
//          let margins = UIEdgeInsets(top: -5, left: 0, bottom: -5, right: 0)
//          contentView.frame = contentView.frame.inset(by: margins)
//    }

}
