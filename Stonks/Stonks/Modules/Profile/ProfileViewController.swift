//
//  ProfileViewController.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class ProfileViewController: UIViewController {
	private let output: ProfileViewOutput

    init(output: ProfileViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .green
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension ProfileViewController: ProfileViewInput {
}
