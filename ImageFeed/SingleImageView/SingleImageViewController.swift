//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 16.05.2023.
//

import Foundation
import UIKit


final class SingleImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: imageView.image!)
        }
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        
        let items = [image]
        let sharing = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(sharing, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 7.25
    
        rescaleAndCenterImageInScrollView(image: imageView.image!)
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
