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
        isLoading = true
        
        fetchImageUrl { result in
            switch result {
            case .success(let imageUrl):
                self.downloadImage(from: imageUrl, completion: completion)
            case .failure(let error):
                self.isLoading = false
                completion(.failure(error))
            }
        }
    }
    
    private func fetchImageUrl(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
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
                
                completion(.success(petImageUrl))
                
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    private func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
            self.isLoading = false
            switch result {
            case .success(let value):
                self.catImage = value.image
                completion(.success(value.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
