//
//  ViewController.swift
//  newsAlamofire
//
//  Created by Massimiliano on 11/06/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON
import SafariServices
//import Lottie

class NewsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTitleLbl: UILabel!
    @IBOutlet weak var lottieContainer: UIView! {
        didSet {
            lottieContainer.isHidden = true
        }
    }
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.isHidden = true
        }
    }
    
    //MARK: - Properties
    var viewModel: NewsViewModel?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //state = .loading
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "newsCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        
        viewModel?.performRequest({ result in
            switch result {
            case .success(let newsMO):
                DispatchQueue.main.async {
                    //cityTitleLbl.text = newManager?.nomeCittà
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("error")
            }
        })

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let leftButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - Actions

  //  func setupAnimation(for animation: Animation) {
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
 //   }

    
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        300
//        
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.newsMO?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell()}
        
        guard let news = viewModel?.newsMO?.articles[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureWith(news)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let auth_url = viewModel?.retriveAuthorAndURLAt(indexPath) else { return }
        
        let alertController = UIAlertController(title: "Attention!", message: "News from: \(auth_url.auth)\n Do you want open: \(auth_url.url)?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.showSafariVC(url: auth_url.url)
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


extension NewsTableViewCell {
    func configureWith(_ article: ArticleMO) {
        self.titleLable.text = article.title
        self.authorLabel.text = article.author
        self.urlLabel.text = article.url
        self.downloadedFrom(link: article.urlToImage!)
    }
}

class NewsViewModel {
    
    private let client: Client
    private(set) var newsMO: NewsMO?
    private var error: Error?
    
    init(country: String) {
        client = Client(country: country)
    }
    
    func performRequest(_ completion: @escaping((Result) -> Void)) {
        client.performRequest { data in
            if let data = data {
                ClientAdapter(data: data).parseResponse { result in
                    switch result {
                    case .success(let newsMO):
                        self.newsMO = newsMO
                    case .failure(let error):
                        self.error = error
                    }
                    completion(result)
                }
            } else {
                completion(.failure(.genericError))
            }
        }
    }
    
    func retriveAuthorAndURLAt(_ indexPath: IndexPath) -> (auth: String, url: String) {
        let auth = newsMO?.articles[indexPath.row].author ?? "Unknown"
        let url = newsMO?.articles[indexPath.row].url ?? ""
        return (auth, url)
    }
}
