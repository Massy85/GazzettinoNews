//
//  NewsTableViewCell.swift
//  newsAlamofire
//
//  Created by Massimiliano Bonafede on 11/09/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit
//import Lottie

class NewsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var lottieContainer: UIView!
    
    //private var loadingView = AnimationView()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.bounds = self.contentView.bounds
//        let animation = Animation.named("news")
//        setupAnimation(for: animation!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    func setupAnimation(for animation: Animation) {
//        loadingView.frame = animation.bounds
//        loadingView.animation = animation
//        loadingView.contentMode = .scaleAspectFill
//        lottieContainer.addSubview(loadingView)
//        loadingView.backgroundBehavior = .pauseAndRestore
//        loadingView.translatesAutoresizingMaskIntoConstraints = false
//        loadingView.topAnchor.constraint(equalTo: lottieContainer.topAnchor).isActive = true
//        loadingView.bottomAnchor.constraint(equalTo: lottieContainer.bottomAnchor).isActive = true
//        loadingView.trailingAnchor.constraint(equalTo: lottieContainer.trailingAnchor).isActive = true
//        loadingView.leadingAnchor.constraint(equalTo: lottieContainer.leadingAnchor).isActive = true
//        self.loadingView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
//    }
    
    func downloadFromURL(url : URL, contentMode mode : UIView.ContentMode = .scaleAspectFit){
        contentMode = mode
        URLSession.shared.dataTask(with: url) { [weak self]
            (data, response, error) in
            
            guard let self = self else { return }
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mineType = response?.mimeType, mineType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() { () -> Void in
                self.newsImage.image = image
                //self.loadingView.stop()
            }
        }.resume()
    }
    
    func downloadedFrom(link : String, contentMode mode : UIView.ContentMode = .scaleAspectFit){
        
        guard let url = URL(string: link) else { return }
        downloadFromURL(url: url, contentMode: mode)
    }
    
}

