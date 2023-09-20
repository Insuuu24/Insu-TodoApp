//
//  PetViewController.swift
//  TodoApp
//
//  Created by Insu on 2023/09/01.
//

import UIKit
import Then
import SnapKit

class PetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let catImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 150
        $0.clipsToBounds = true
        $0.image = UIImage(named: "placeholder")
    }
    
    private let viewModel = PetViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureUI()
        fetchRandomCatImage()
    }

    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "고앵이 사진보기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchRandomCatImage))
        
        let navigationBarAppearance = UINavigationBarAppearance().then {
            $0.configureWithDefaultBackground()
            $0.backgroundColor = .white
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(catImageView, activityIndicator)
        
        catImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
    }
    
    private func bindViewModel() {
        viewModel.fetchRandomCatImage { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.catImageView.image = image
                    self?.catImageView.snp.updateConstraints {
                        $0.width.height.equalTo(300)
                    }
                }
            case .failure(let error):
                print("오류로 인해 고양이 이미지를 불러오기 실패: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func fetchRandomCatImage() {
        catImageView.image = UIImage(named: "placeholder")
        activityIndicator.startAnimating()
        bindViewModel()
    }
}
