//
//  ProfileViewController.swift
//  Stonks
//
//  Created by Иван Лизогуб on 20.07.2021.
//  
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    
	private let output: ProfileViewOutput
    
    private let profileImageView = UIImageView(image: UIImage(named: "Profile"))
    private let usernameLabel = UILabel()
    
    private let exitButton = UIButton(type: .system)

    // MARK: - Lifecycle
    
    init(output: ProfileViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = Constants.backgroundColor
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        setup()
        setupConstraints()
        output.getUsername()
	}
    
    private func setup() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        setupButton()
    }
    
    private func setupButton() {
        view.addSubview(exitButton)
        exitButton.setTitle("Выйти", for: .normal)
        exitButton.setTitleColor(.red, for: .normal)
        exitButton.addTarget(self, action: #selector(onTapExitButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        [exitButton,
         profileImageView,
         usernameLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            profileImageView.widthAnchor.constraint(equalToConstant: 230),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            usernameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            exitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            exitButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    @objc
    private func onTapExitButton() {
//         Алерт ломает констраинты, является давним багом эпла пруфы:
//        https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
        let alertController = UIAlertController(title: nil, message: Constants.alertMessage, preferredStyle: .actionSheet)
        let exitAction = UIAlertAction(title: "Выйти", style: .destructive, handler: exit)
        alertController.addAction(exitAction)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func exit(action: UIAlertAction) {
        output.onTapLogOut()
    }
}

// MARK: - ProfileViewInput

extension ProfileViewController: ProfileViewInput {
    func updateUsername(_ username: String) {
        usernameLabel.text = username
    }
    
}

// MARK: - Nested Types

private extension ProfileViewController {
    enum Constants {
        static let backgroundColor = UIColor.white
        static let alertMessage = "Вы уверены, что хотите выйти?"
    }
}
