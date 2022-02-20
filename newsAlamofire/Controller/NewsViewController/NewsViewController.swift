//
//  ViewController.swift
//  newsAlamofire
//
//  Created by Massimiliano on 11/06/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
import SafariServices
import Lottie

class NewsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTitleLbl: UILabel!
    @IBOutlet weak var lottieContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties
    var viewModel: NewsViewModel?
    var loadingView = AnimationView()
    var cityName: String = ""
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTablleView()
        performAnimation()
        
        viewModel?.performRequest { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.cityTitleLbl.text = self.cityName
                    self.stopAnimationAndReload()
                }
            case .failure(let error):
                print("----> Error \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Actions
    
    private func setupTablleView() {
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "newsCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let leftButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.leftBarButtonItem = leftButton
    }

    private func performAnimation() {
        guard let animation = Animation.named("news") else { return }
        loadingView.frame = animation.bounds
        loadingView.animation = animation
        loadingView.contentMode = .scaleAspectFill
        lottieContainer.addSubview(loadingView)
        loadingView.backgroundBehavior = .pauseAndRestore
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: lottieContainer.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: lottieContainer.bottomAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: lottieContainer.trailingAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: lottieContainer.leadingAnchor).isActive = true
        self.loadingView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
    }
    
    private func stopAnimationAndReload() {
        tableView.reloadData()
        loadingView.stop()
        containerView.isHidden = true
    }

    
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
//        newManager?.nomeCittà = nil
//        newManager?.inizialeCittà = nil
//        mainCoordinator?.cancelTapped(self)
    }
    
    func showSafariVC(url : String) {
        guard let url = URL(string : url) else { return }
        
        UIApplication.shared.open(url)
        //    let safariVC = SFSafariViewController(url: url)
        //    present(safariVC, animated: true)
    }
    
}

//MARK: - TableViewDelegate
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel?.newsMO?.articles.count ?? 0 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        
        guard let news = viewModel?.newsMO?.articles[indexPath.row] else { return UITableViewCell() }
        
        cell.configureWith(news)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let auth_url = viewModel?.retriveAuthorAndURLAt(indexPath) else { return }
        
        let alertController = UIAlertController(title: "Attention!", message: "News from: \(auth_url.auth)\n Do you want open: \(auth_url.url)?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showSafariVC(url: auth_url.url)
        })
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
