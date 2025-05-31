//
//  APICaller.swift
//  Netflix clone
//
//  Created by AMAN K.A on 08/09/23.
//




//1


//import Foundation
//
//struct Constants {
//    static let API_KEY = "bf04a50e515134e477a2f5e4ecde95c1"
//    static let baseURL = "https://api.themoviedb.org/3"
//    
//    static let YoutubeAPI_KEY = "AIzaSyCA6stkH1UK9NL1WRH9oLM0VB93gSF2DfQ"
//    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
//}
//
//enum APIError: Error {
//    case failedtogetData
//    case invalidURL
//    case noData
//    case networkError(String)
//}
//
//class APICaller {
//    static let shared = APICaller()
//    
//    private let urlSession: URLSession
//    
//    private init() {
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 30
//        config.timeoutIntervalForResource = 60
//        config.waitsForConnectivity = true
//        config.allowsCellularAccess = true
//        
//        // Add headers
//        config.httpAdditionalHeaders = [
//            "User-Agent": "Netflix-Clone-iOS/1.0",
//            "Accept": "application/json",
//            "Content-Type": "application/json"
//        ]
//        
//        self.urlSession = URLSession(configuration: config)
//    }
//    
//    private func performRequest<T: Codable>(
//        url: URL,
//        responseType: T.Type,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) {
//        print("🔗 Making request to: \(url.absoluteString)")
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        let task = urlSession.dataTask(with: request) { data, response, error in
//            // Check for network errors
//            if let error = error {
//                print("❌ Network error: \(error.localizedDescription)")
//                completion(.failure(APIError.networkError(error.localizedDescription)))
//                return
//            }
//            
//            // Check HTTP response
//            if let httpResponse = response as? HTTPURLResponse {
//                print("📡 HTTP Status: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode != 200 {
//                    let errorMsg = "HTTP Error: \(httpResponse.statusCode)"
//                    print("❌ \(errorMsg)")
//                    completion(.failure(APIError.networkError(errorMsg)))
//                    return
//                }
//            }
//            
//            // Check for data
//            guard let data = data else {
//                print("❌ No data received")
//                completion(.failure(APIError.noData))
//                return
//            }
//            
//            print("✅ Received data: \(data.count) bytes")
//            
//            // Try to decode
//            do {
//                let results = try JSONDecoder().decode(responseType, from: data)
//                print("✅ Successfully decoded response")
//                completion(.success(results))
//            } catch {
//                print("❌ Decoding error: \(error)")
//                // Print raw data for debugging
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("📄 Raw response: \(jsonString.prefix(500))")
//                }
//                completion(.failure(APIError.failedtogetData))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        let urlString = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.API_KEY)"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        performRequest(url: url, responseType: TrendingTitleResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
//        let urlString = "\(Constants.baseURL)/trending/tv/day?api_key=\(Constants.API_KEY)"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        performRequest(url: url, responseType: TrendingTitleResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        let urlString = "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        performRequest(url: url, responseType: TrendingTitleResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
//        let urlString = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        performRequest(url: url, responseType: TrendingTitleResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
//        let urlString = "\(Constants.baseURL)/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        performRequest(url: url, responseType: TrendingTitleResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
//        let urlString = "\(Constants.baseURL)/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        performRequest(url: url, responseType: TrendingTitleResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        let urlString = "\(Constants.baseURL)/search/movie?api_key=\(Constants.API_KEY)&query=\(encodedQuery)"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        performRequest(url: url, responseType: TrendingTitleResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        let urlString = "\(Constants.YoutubeBaseURL)q=\(encodedQuery)&key=\(Constants.YoutubeAPI_KEY)"
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        
//        print("🎥 YouTube request: \(url.absoluteString)")
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        let task = urlSession.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ YouTube API error: \(error.localizedDescription)")
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//            
//            do {
//                let results = try JSONDecoder().decode(YoutubeSearchResponce.self, from: data)
//                guard !results.items.isEmpty else {
//                    completion(.failure(APIError.noData))
//                    return
//                }
//                completion(.success(results.items[0]))
//            } catch {
//                print("❌ YouTube decoding error: \(error)")
//                completion(.failure(error))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    // Test connection method
//    func testConnection() {
//        let testURL = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.API_KEY)"
//        guard let url = URL(string: testURL) else {
//            print("❌ Invalid test URL")
//            return
//        }
//        
//        print("🧪 Testing connection to: \(url.absoluteString)")
//        
//        let task = urlSession.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("❌ Test connection failed: \(error.localizedDescription)")
//            } else if let httpResponse = response as? HTTPURLResponse {
//                print("✅ Test connection successful: \(httpResponse.statusCode)")
//                if let data = data {
//                    print("📊 Received \(data.count) bytes")
//                }
//            }
//        }
//        task.resume()
//    }
//}




//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 08/12/2021.
//

import Foundation


struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()
    
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedTogetData))
            }

        }
        task.resume()
    }
    
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedTogetData))
            }

        }
        task.resume()
    }
    
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedTogetData))
            }

        }
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                

            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
}




