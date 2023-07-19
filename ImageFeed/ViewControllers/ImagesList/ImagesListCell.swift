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
    
    public var indexPath: IndexPath?
    
    
    weak var delegate: ImagesListCellDelegate?
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCellList: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    
    override func prepareForReuse() {
         super.prepareForReuse()

         // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        imageCellList.kf.cancelDownloadTask()
     }

    @IBAction func likeButtonPressed(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
}
