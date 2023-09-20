//
//  CollectionReusableView.swift
//  TodoApp
//
//  Created by Insu on 2023/09/18.
//

import UIKit
import Then
import SnapKit

final class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    private let usernameLabel = UILabel().then {
        $0.text = "in_suuu___"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "insuEmoji.jpg")
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
    }
    
    private lazy var postsLabel = UILabel().then {
        $0.attributedText = attributedStatText(value: 0, label: "post")
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var followersLabel = UILabel().then {
        $0.attributedText = attributedStatText(value: 0, label: "follower")
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var followingLabel = UILabel().then {
        $0.attributedText = attributedStatText(value: 0, label: "following")
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    private let bioLabel = UILabel().then {
        $0.text = ""
        $0.numberOfLines = 0
    }
    
    private lazy var gitHubButton = UIButton().then {
        $0.setTitle("Insu's GitHub", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.setTitleColor(Constant.appColor, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(openGithub), for: .touchUpInside)
    }
    
    private let followButton = UIButton().then {
        $0.setTitle("Follow", for: .normal)
        $0.backgroundColor = Constant.appColor
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let followingButton = UIButton().then {
        $0.setTitle("Following", for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    private let moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.cgColor
    }

    private let buttonsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 8
    }

    private let borderView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
    }
    
    private lazy var gridButton = UIButton().then {
        let gridBtn = UIImage(systemName: "squareshape.split.3x3")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch)
        $0.setImage(gridBtn, for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(gridBtnTapped), for: .touchUpInside)
    }
    
    private lazy var listButton = UIButton().then {
        let listBtn = UIImage(systemName: "list.bullet")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch)
        $0.setImage(listBtn, for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(listBtnTapped), for: .touchUpInside)
    }
    
    private lazy var newButton = UIButton().then {
        let newBtn = UIImage(systemName: "plus.rectangle")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch)
        $0.setImage(newBtn, for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(newBtnTapped), for: .touchUpInside)
    }
    
    private let buttonsContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    private let barColor = UIView().then {
        $0.backgroundColor = Constant.appColor
    }

    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupBioLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubviews(usernameLabel, profileImageView, bioLabel, gitHubButton, stackView, buttonsStackView, borderView, buttonsContainer, barColor)
        stackView.addArrangedSubviews(postsLabel, followersLabel, followingLabel)
        buttonsStackView.addArrangedSubviews(followButton, followingButton, moreButton)
        buttonsContainer.addArrangedSubviews(gridButton, listButton, newButton)

        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.centerX.equalTo(self)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(14)
            $0.leading.equalTo(self).offset(16)
            $0.width.height.equalTo(80)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(30)
            $0.trailing.equalTo(self).offset(-30)
        }
        
        bioLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.equalTo(self).offset(16)
            $0.trailing.equalTo(self).offset(-16)
        }
        
        gitHubButton.snp.makeConstraints {
            $0.top.equalTo(bioLabel.snp.bottom).offset(2)
            $0.leading.equalTo(self).offset(16)
            $0.trailing.equalTo(self).offset(-16)
            $0.height.equalTo(20)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(gitHubButton.snp.bottom).offset(14)
            $0.leading.equalTo(self).offset(16)
            $0.trailing.equalTo(self).offset(-16)
            $0.height.equalTo(30)
        }

        followButton.snp.makeConstraints {
            $0.width.equalTo(followingButton)
        }

        moreButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(buttonsStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(0.5)
        }
        
        buttonsContainer.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(10)
            $0.leading.equalTo(self).offset(16)
            $0.trailing.equalTo(self).offset(-16)
            $0.height.equalTo(30)
        }
        
        barColor.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.leading.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
        }
    }
    
    private func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    private func setupBioLabel() {
        let bioText = NSMutableAttributedString(string: "인수인수\n", attributes: [.font: UIFont.systemFont(ofSize: 16)])
        bioText.append(NSAttributedString(string: "iOS Developer 🍎", attributes: [.font: UIFont.systemFont(ofSize: 16)]))
        bioLabel.attributedText = bioText
    }
    
    // MARK: - Actions
    
    @objc func openGithub() {
        guard let githubUrl = URL(string: "https://github.com/Insuuu24") else {
            return
        }
        UIApplication.shared.open(githubUrl)
    }
    
    @objc func gridBtnTapped() {
        print("gridButtonTapped")
    }

    @objc func listBtnTapped() {
        print("listButtonTapped")
    }

    @objc func newBtnTapped() {
        print("newButtonTapped")
    }
}
