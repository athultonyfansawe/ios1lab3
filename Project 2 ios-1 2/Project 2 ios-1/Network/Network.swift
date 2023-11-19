//
//  Network.swift
//  Project 2 ios-1
//
//  Created by Andrew Ananda on 17/11/2023.
//

import Foundation
import CoreLocation



protocol WeatherNetworkProtocol {
    func response(_ weatherResponse: WeatherResponse)
    func errorResponse(_ error: Errors)
    func loadingStatus(_ isLoading: Bool)
}


class Network {
    
    var delegate: WeatherNetworkProtocol?
    
    func fetchWeather(query: String) {
        let urlString = "?q=\(query)"
        delegate?.loadingStatus(true)
        fetchData(url: urlString, params: nil) { (response: Result<WeatherResponse, Errors>) in
            
            switch response {
            case .success(let data):
                print("Response:- \(data)")
                self.delegate?.response(data)
                self.delegate?.loadingStatus(false)
            case .failure(let error):
                self.delegate?.errorResponse(error)
                self.delegate?.loadingStatus(false)
            }
        }
    }
    
    func fetchWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let urlString="?q=\(latitude),\(longitude)"
        delegate?.loadingStatus(true)
        fetchData(url: urlString, params: nil) { (response: Result<WeatherResponse, Errors>) in
            
            switch response {
            case .success(let data):
                print("Response:- \(data)")
                self.delegate?.response(data)
                self.delegate?.loadingStatus(false)
            case .failure(let error):
                self.delegate?.errorResponse(error)
                self.delegate?.loadingStatus(false)
            }
        }
        
       }
    
    
    
    
    func fetchData<T: Codable>(url: String, params:[String: Any]?, completion: @escaping (Result<T, Errors>) -> Void) {
            
        guard let endpoint = "\(K.api.baseUrl)current.json\(url)&key=\(K.api.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            print("Endpoint:- \(endpoint)")
        
        
        guard let url = URL(string: endpoint) else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            //network call finished
            print("Network call complete")
            
            guard error == nil else {
                completion(.failure(Errors.apiError("Error occurred")))
                return
            }
            
            guard let data = data else {
                completion(.failure(Errors.apiError("Error occurred")))
                return
            }
            if let weatherResponse = self.parseJson(data: data) {
                completion(.success(weatherResponse as! T))
            }
            
        }
        
        dataTask.resume()
        
        }
    
    private func parseJson(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        var weather: WeatherResponse?
        do {
            weather = try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            print("Error decoding")
        }
        
        return weather
    }
        
        
    
}

public enum Errors : Error {
    case emptyResponse(String)
    case custom(Int, String)
    case apiError(String)
    
    func get() -> String {
        switch self {
        case .apiError(let error):
            return error
        case .emptyResponse(let error):
            return error
        case .custom(_, let error):
            return error
        }
    }
}
