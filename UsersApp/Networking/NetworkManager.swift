import Foundation

class NetworkManager {
    let networkError = NetworkError.self
    
    func getUser(endpointResult: Int, endpointSeed: String) async throws -> [User] {
        var urlComponents = URLComponents(string: "https://randomuser.me/api/")
        urlComponents?.queryItems = [
            URLQueryItem(name: "results", value: "\(endpointResult)"),
            URLQueryItem(name: "seed", value: endpointSeed)
        ]
        
        guard endpointResult >= 1 else {
            throw networkError.invalidParameter
        }

        guard let url = urlComponents?.url else {
            throw networkError.invalidUrl
        }
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60

        let session = URLSession(configuration: config)
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw networkError.invalidResponse
            }

            let decoder = JSONDecoder()
            let result = try decoder.decode(UserListResponse.self, from: data)
            return result.results
        } catch {
            throw networkError.invalidData
        }
    }
}
