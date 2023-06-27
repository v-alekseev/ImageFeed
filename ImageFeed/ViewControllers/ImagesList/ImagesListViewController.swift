//
//  ViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 28.04.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private var imageListService = ImagesListService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
                print("IMG NotificationCenter event. \(self.imageListService.photos)")
            }
        
        imageListService.fetchPhotosNextPage()
        
    }
    
//    private func loadPhotos() {
//        imageListService.fetchPhotosNextPage() {[weak self]  ( result: Result<String, Error>) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let str):
//                print("IMG success str = \(str)")
//            case .failure(let error):
//                print("IMG error = \(error)")
//            }
//        }
//    }
    
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
            let destinationViewController = segue.destination as! SingleImageViewController // 2
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            //_ = destinationViewController.view // CRASH FIXED !?4
            destinationViewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    
    // устанавливаем высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("IMGrow indexPath = \(indexPath.row) imageListService.photos.count = \(imageListService.photos.count))")
        if (indexPath.row + 1 == imageListService.photos.count) {
            print("IMGrow get new page")
            imageListService.fetchPhotosNextPage()
        }
        
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return ImagesListCell.defaultHeight
        }
        
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        // todo что лучше использовать tableView.bounds.width или tableView.visibleSize.width
        let k = (tableView.bounds.width - imageInsets.left - imageInsets.right)/image.size.width
        
        return CGFloat(image.size.height*k + imageInsets.top + imageInsets.bottom )
        
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    // Устанавливам колличество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    // Создаем ячейу
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.imageCellList.image = image
        cell.labelDate.text = dateFormatter.string(from: Date())
        cell.likeButton.imageView?.image  = indexPath.row % 2 == 0 ? UIImage(named: ImagesListCell.favoritsActive) : UIImage(named: ImagesListCell.favoritsNoactive)
        
    }
    
}


