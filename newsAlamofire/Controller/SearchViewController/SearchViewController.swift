//
//  RicercaVC.swift
//  newsAlamofire
//
//  Created by Massimiliano on 13/06/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchButton: UIButton!
    
    //MARK: - Properties
    
    private let viewModel = SearchViewModel()
    private var selected: Int = 0
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setup() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.white, forKey: "textColor")
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func searchButtonWasPressed(_ sender: Any) {
        let country = viewModel.getInitialOfCityNameAt(selected)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController
        //controller = NewsViewController(country: country)
        guard let controller = controller else { return }
       // let _ = controller.view
        controller.viewModel = NewsViewModel(country: country)
            self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getCityNameAtIndex(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = row
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let pickerLabel = (view as? UILabel) {
            label = pickerLabel
        } else {
            label.font = UIFont(name: "Avenir", size: 30)
            label.textAlignment = .center
        }
        label.text = viewModel.getCityNameAtIndex(row)
        label.textColor = UIColor.white
        return label
    }
}

