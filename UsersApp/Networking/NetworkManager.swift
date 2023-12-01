//
//  NetworkManager.swift
//  Prob
//
//  Created by Dar Dar on 04.10.2023.
//

import Foundation


class NetworkManager {
    let networError = NetworkError.self
    
    func getUser(endpointResult: Int, endpointSeed: String) async throws -> [User] {
        
        var urlComponents = URLComponents(string: "https://randomuser.me/api/")
        urlComponents?.queryItems = [
            URLQueryItem(name: "results", value: "\(endpointResult)"),
            URLQueryItem(name: "seed", value: endpointSeed)
        ]
        
        guard endpointResult >= 1 else {
            throw networError.invalidParameter
        }

        guard let url = urlComponents?.url else {
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
