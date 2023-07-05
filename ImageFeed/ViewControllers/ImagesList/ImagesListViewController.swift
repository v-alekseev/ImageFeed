//
//  ViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 28.04.2023.
//

import UIKit
import Kingfisher



protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}



final class ImagesListViewController: UIViewController {
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    private var imageListService = ImagesListService()
    
    private var currentImageListSize: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        // это регистрации ячейки программно
        // tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidImageListChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                print("IMG NotificationCenter array Photos updated. Count =  \(self.imageListService.photos.count)")
                self.updateTableViewAnimated()
            }
        
        imageListService.fetchPhotosNextPage()
        
    }
    
    private func updateTableViewAnimated() {
        
        let addRows = imageListService.photos.count - currentImageListSize
        if addRows <= 0 { return }
        
        var indexs: [IndexPath] = []
        // TODO переделать на map
        for item in currentImageListSize..<imageListService.photos.count {
            indexs.append(IndexPath(row: item, section: 0))
        }
        
        
        currentImageListSize = imageListService.photos.count
        tableView.insertRows(at: indexs, with: .automatic)
        
        
    }
    
    
    // это нужно для белого шрифта в статус бар
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let destinationViewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            destinationViewController.imageUrl = imageListService.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    
    // устанавливаем высоту ячейки // Asks the delegate for the height to use for a row in a specified location.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(imageListService.photos.count > 0){
            return calculateCellHeight(size: imageListService.photos[indexPath.row].size)
        }
        else {
            return ImagesListCell.defaultHeight
        }
    }
    
    
    private func calculateCellHeight(image: UIImage?) -> CGFloat{
        guard let image = image else { return ImagesListCell.defaultHeight}
        
        return calculateCellHeight(size:  image.size)
    }
    
    private func calculateCellHeight(size: CGSize) -> CGFloat{
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let k = (tableView.bounds.width - imageInsets.left - imageInsets.right)/size.width
        
        return CGFloat(size.height*k + imageInsets.top + imageInsets.bottom )
    }
    
    
    //Tells the delegate the table view is about to draw a cell for a particular row.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIBlockingProgressHUD.dismiss()

        if (indexPath.row + 1 == imageListService.photos.count) {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    // Устанавливам колличество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentImageListSize
    }
    
    // Создаем ячейу
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("IMG tableView/cellForRowAt create cell (\(indexPath.row))")
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("IMG tableView/cellForRowAt  create cell (\(indexPath.row)) return new cell ")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        //TODO нужна проверка на выход за пределы массива
        let url = imageListService.photos[indexPath.row].thumbImageURL
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.imageCellList.kf.indicatorType = .activity
        cell.imageCellList.kf.setImage(with: url, placeholder: UIImage(named: "Stub"))  { [weak self]  result in
            // `result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                print("IMG imageCellList.kf.setImage reloadRows(\(indexPath.row))")
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
            case .failure(let error):
                print(error) // The error happens
            }
        }
        
        cell.labelDate.text = dateFormatter.string(from: imageListService.photos[indexPath.row].createdAt ?? Date())
        updateLikeButton(cell: cell, photo: imageListService.photos[indexPath.row])
    }
    
    private func updateLikeButton(cell: ImagesListCell, photo: Photo) {
        cell.likeButton.imageView?.image  = photo.isLiked ? UIImage(named: ImagesListCell.favoritsActive) : UIImage(named: ImagesListCell.favoritsNoactive)
    }

    
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        // TODO Это сособе без сохранения indexPath в ячейке. Мне он не нравиться
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        let photo = imageListService.photos[indexPath.row]
        
        guard let indexPath = cell.indexPath else { return }
        let photo = imageListService.photos[indexPath.row]
       
        print("IMG ImagesListViewController|buttomPressed row = \(String(describing: index)) id = \(photo.id) liked = \(photo.isLiked)")
        
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !(photo.isLiked)) {  [weak self, indexPath, weak cell ] result in
            guard let self = self,
                  let cell = cell else { return }
            
            switch result {
            case .success(_):
                UIBlockingProgressHUD.dismiss()
                self.updateLikeButton(cell: cell, photo: self.imageListService.photos[indexPath.row])
                break
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("IMG Error = \(error)")
                break
            }
        }
    }
}

