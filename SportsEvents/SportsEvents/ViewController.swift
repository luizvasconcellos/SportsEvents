//
//  ViewController.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 11/10/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let viewModel = SportsEventsViewModel()
        view.backgroundColor = .green
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

