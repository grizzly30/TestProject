//
//  LoadingViewController.swift
//  TestProject
//
//  Created by Mihailo Jovanovic on 20.6.21..
//

import UIKit

class LoadingViewController: UIViewController {
    var loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
    }
}
