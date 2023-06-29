//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 01.05.2023.
//

import Foundation
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    static let favoritsActive = "favorits_active"
    static let favoritsNoactive = "favorits_noactive"
    static let defaultHeight = CGFloat(300)
    
    var row: Int?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCellList: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    
    override func prepareForReuse() {
         super.prepareForReuse()
        print("IMG prepareForReuse() (\(row))")
         // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        imageCellList.kf.cancelDownloadTask()
     }


}
