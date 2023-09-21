//
//  PetViewModel.swift
//  TodoApp
//
//  Created by Insu on 2023/09/17.
//

import UIKit
import Kingfisher

final class PetViewModel {
    
    // MARK: - Output
    
    var catImage: UIImage?
    var isLoading: Bool = false
    
    // MARK: - Input
    
    func fetchRandomCatImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        isLoading = true
        
        // MARK: - Logics
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            self.isLoading = false
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]],
                      let petImageUrlString = jsonArray.first?["url"] as? String,
                      let petImageUrl = URL(string: petImageUrlString)
                else {
                    return
                }
                
                KingfisherManager.shared.retrieveImage(with: petImageUrl, options: nil, progressBlock: nil, completionHandler: { result in
                    switch result {
                    case .success(let value):
                        self.catImage = value.image
                        completion(.success(value.image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
                
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}
