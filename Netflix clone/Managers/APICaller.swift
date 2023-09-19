//
//  APICaller.swift
//  Netflix clone
//
//  Created by AMAN K.A on 08/09/23.
//

import Foundation


struct Constants {
    
static let API_KEY = "f0aac029caf68505db71db3aafc24dc5"
    static let baseURL = "https://api.themoviedb.org/"
    
    static let YoutubeAPI_KEY = "AIzaSyCA6stkH1UK9NL1WRH9oLM0VB93gSF2DfQ"
     
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedtogetData
}

class APICaller {
    static let shared = APICaller()
    
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
           
            guard let data = data, error == nil  else {
                return
                
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch{
                completion(.failure(APIError.failedtogetData))
            }
        }
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedtogetData))
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
guard let url = URL(string:"\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let  data = data, error==nil  else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedtogetData))
            }

}
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void){
guard let url = URL(string:"\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let  data = data, error==nil  else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedtogetData))
            }

}
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void){
guard let url = URL(string:"\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let  data = data, error==nil  else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedtogetData))
            }

         }
        task.resume()
    }
    
    
    func getDiacoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        
        //https://api.themoviedb.org/3/discover/movie?api_key=<<api_key>>&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate
        
        
        
        guard let url = URL(string:"\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else{return}
                
                let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                    guard let  data = data, error==nil  else {
                        return
                    }
                    
                    do{
                        let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                        completion(.success(results.results))
                    } catch{
                        completion(.failure(APIError.failedtogetData))
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
                    guard let  data = data, error==nil  else {
                        return
                    }
                    
                    do{
                        let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                        completion(.success(results.results))
                    } catch{
                        completion(.failure(APIError.failedtogetData))
                    }

                 }
                task.resume()

    }
    
    func  getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}

        guard  let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else
      {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let  data = data, error == nil  else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponce.self, from: data)

                completion(.success(results.items[0]))
            } catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }

         }
        task.resume()
    }
    
}



// "https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1"



