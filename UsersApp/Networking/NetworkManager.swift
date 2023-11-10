//
//  NetworkManager.swift
//  Prob
//
//  Created by Dar Dar on 04.10.2023.
//

import Foundation


class NetworkManager {
    let networError = NetworkError.self
    
    func getUser() async throws -> [User] {
        let endpoint = "https://randomuser.me/api/?results=100&seed=abc"
        
        guard let url = URL(string: endpoint) else {
            throw networError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
            throw networError.invalidReponse
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(UserListResponse.self, from: data)
            return result.results
        } catch {
            throw networError.invalidData
        }
    }
}
