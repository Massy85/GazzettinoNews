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

class NewsViewController: UIViewController, MainCoordinated, NewsManagerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTitleLbl: UILabel!
    @IBOutlet weak var lottieContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties
    var mainCoordinator: MainCoordinator?
    var newManager: NewsManager?
    var getNewsFromJSON: GetNewsFromJSON?
    var dataSource: NewsDataSource?
//    private var loadingView = AnimationView()
    
    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
            //    let animation = Animation.named("news")
               // setupAnimation(for: animation!)
                containerView.isHidden = false
            case .setupUI:
                //loadingView.stop()
                containerView.isHidden = true
            }
        }
    }
    
    //MARK: - Lifecycle
    
    convenience init(city: String) {
        self.init(nibName: nil, bundle: nil)
        print("-----> \(city)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = .loading

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let leftButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.leftBarButtonItem = leftButton
        
        
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "newsCell")
        tableView.delegate = self
        
        getNewsFromJSON = GetNewsFromJSON()
        getNewsFromJSON?.delegate = self
        getNewsFromJSON?.retriveNewsFromServer((newManager?.inizialeCittà)!)
        cityTitleLbl.text = newManager?.nomeCittà
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
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
        newManager?.nomeCittà = nil
        newManager?.inizialeCittà = nil
        mainCoordinator?.cancelTapped(self)
    }
    
    func showSafariVC(url : String) {
        guard let url = URL(string : url) else { return }
        
        UIApplication.shared.open(url)
        //    let safariVC = SFSafariViewController(url: url)
        //    present(safariVC, animated: true)
    }
    
}

//MARK: - TableViewDelegate
extension NewsViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        300
//        
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let auth = dataSource?.getAuthor(at: indexPath), let url = dataSource?.getURL(at: indexPath) else { return }
        
        let alertController = UIAlertController(title: "Attention!", message: "News from: \(auth)\n Do you want open: \(url)?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.showSafariVC(url: url)
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - FetchedNewDidSuccessfullyDelegate

extension NewsViewController: FetchedNewDidSuccessfullyDelegate {
    func retriveNews(_ news: [News]) {
        dataSource = NewsDataSource(news: news)
        tableView.dataSource = dataSource
        state = .setupUI
        tableView.reloadData()
    }
    
    func retriveNewsDidFail(_ error: String) {
        debugPrint(error)
        let controller = UIAlertController(title: "Attention !!!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
               let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] (action) in
                   guard let self = self else { return }
            
                self.mainCoordinator?.cancelTapped(self)
               }
               
               controller.addAction(action)
               self.present(controller, animated: true, completion: nil)
    }
}

//MARK: - State

extension NewsViewController {
    enum State {
        case loading
        case setupUI
    }
}
