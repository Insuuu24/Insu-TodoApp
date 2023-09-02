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
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - View Life Cycle
    
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
    
    @objc private func fetchRandomCatImage() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        catImageView.image = UIImage(named: "placeholder")
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("오류로 인해 고양이 이미지를 불러오기 실패: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]],
                   let petImageUrlString = jsonArray.first?["url"] as? String,
                   let petImageUrl = URL(string: petImageUrlString) {
                    
                    URLSession.shared.dataTask(with: petImageUrl) { (data, response, error) in
                        if let error = error {
                            print("오류로 인해 고양이 이미지를 불러오기 실패: ", error.localizedDescription)
                            return
                        }
                        
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.catImageView.image = image
                                self.catImageView.snp.updateConstraints {
                                    $0.width.height.equalTo(300)
                                }
                            }
                        }
                    }.resume()
                }
            } catch let jsonError {
                print("Failed to decode JSON with error: ", jsonError.localizedDescription)
            }
        }.resume()
    }
}
