//
//  LoadingViewController.swift
//  Project 2 ios-1
//
//  Created by Andrew Ananda on 17/11/2023.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    

    init() {
        super.init(nibName: "LoadingViewController", bundle: Bundle.main)
    }
    
    @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    func show() {
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    func dismissLoading() {
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }
    }

}
