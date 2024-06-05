//
//  APIService.swift
//  iOS Concurrency
//
//  Created by Jayanth Ambaldhage on 01/06/24.
//

import Foundation

struct APIService {
    let urlString: String
    
    func getJSON<T: Decodable>(dateDecodingStrategy:JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invaildURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                throw APIError.invalidResponseStatus
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
            
        } catch {
            throw APIError.dataTastError(error.localizedDescription)
        }
        
    }
    
    
    
    func getJSON<T: Decodable>(dateDecodingStrategy:JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                               completion: @escaping (Result<T,APIError>) -> Void) {
        
        guard let url = URL(string: urlString)
        else {
            completion(.failure(.invaildURL))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                completion(.failure(.invalidResponseStatus))
                return }
            
            guard error == nil
            else {
                completion(.failure(.dataTastError(error!.localizedDescription)))
                return}
            
            guard let data = data
            else {
                completion(.failure(.corruptData))
                return}
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }
        
        .resume()
    }
}

enum APIError: Error, LocalizedError {
    case invaildURL
    case invalidResponseStatus
    case dataTastError(String)
    case corruptData
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invaildURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response.", comment: "")
        case .dataTastError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupted", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
