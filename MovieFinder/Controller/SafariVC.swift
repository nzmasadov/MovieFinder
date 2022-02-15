//
//  SafariVC.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 04.02.22.
//

import UIKit

class SafariVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let scroolView = UIScrollView(frame: CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: view.frame.size.height - 20))
        scroolView.backgroundColor = .yellow
        view.addSubview(scroolView)
        
        let topButton = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        topButton.backgroundColor = .blue
        scroolView.addSubview(topButton)
        
        let bottomButton = UIButton(frame: CGRect(x: 50, y: 2000, width: 100, height: 100))
        bottomButton.backgroundColor = .blue
        scroolView.addSubview(bottomButton)
        
        scroolView.contentSize = CGSize(width: view.frame.size.width - 30, height: 2200)
                        
    }

}
