//
//  NetworkManager.swift
//  Prob
//
//  Created by Dar Dar on 04.10.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetch(completion: @escaping ([User]) -> ()){
        let url = "https://randomuser.me/api/?results=100&seed=abc"
        let task = URLSession.shared.dataTask(with: URL(string: url)!,
                                   completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("somethig went wrong")
                return
            }
            
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
                completion(result!.results)
            } catch {
                print("failed to convert \(error)")
            }
            
            guard result != nil else {
                return
            }

        })
        task.resume()
    }
}
