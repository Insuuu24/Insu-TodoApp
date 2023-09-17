//
//  PetViewModel.swift
//  TodoApp
//
//  Created by Insu on 2023/09/17.
//

import UIKit

final class PetViewModel {
    
    //MARK: - Output
    
    var catImage: UIImage?
    var isLoading: Bool = false
    
    //MARK: - Input
    
    func fetchRandomCatImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        isLoading = true
        
        //MARK: - Logics
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.isLoading = false
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]],
                   let petImageUrlString = jsonArray.first?["url"] as? String,
                   let petImageUrl = URL(string: petImageUrlString) {
                    
                    URLSession.shared.dataTask(with: petImageUrl) { (data, response, error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        if let data = data, let image = UIImage(data: data) {
                            self.catImage = image
                            completion(.success(image))
                        }
                    }.resume()
                }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}

