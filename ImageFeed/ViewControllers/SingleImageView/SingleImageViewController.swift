//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 16.05.2023.
//

import Foundation
import UIKit
import Kingfisher
import ProgressHUD


final class SingleImageViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: URL?

    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: imageView.image!)
        }
    }
    
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        let items = [image]
        let sharing = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(sharing, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 7.25
        
        downloadImage()
    }
    
    private func downloadImage() {
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl)  { [weak self]  result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.rescaleAndCenterImageInScrollView(image: self.imageView.image!)
            case .failure(let error):
                print(error) // The error happens
                self.showErrorAlert()
            }
        }
    }
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Попробовать ещё раз?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.downloadImage()
        })
        alert.addAction(UIAlertAction(title: "Не надо", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale =  min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
        // это не дает свернуть в точку картинку
        //scrollView.minimumZoomScale = min(hScale, vScale)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    // Это центрирует картинку при мастабировании мышкой. Оставим пока тут
    //    func scrollViewDidZoom(_ :UIScrollView) {
    //
    //        let visibleRectSize = scrollView.bounds.size
    //        let newContentSize = scrollView.contentSize
    //        let x = (newContentSize.width - visibleRectSize.width) / 2
    //        let y = (newContentSize.height - visibleRectSize.height) / 2
    //
    //        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    //
    //    }
    //
    
    // Это центрирует картинку при скролинге мышкой. Оставим пока тут
    //    func scrollViewDidScroll(_ :UIScrollView) {
    //
    //        let visibleRectSize = scrollView.bounds.size
    //        let newContentSize = scrollView.contentSize
    //        let x = (newContentSize.width - visibleRectSize.width) / 2
    //        let y = (newContentSize.height - visibleRectSize.height) / 2
    //
    //        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    //    }
    
}
