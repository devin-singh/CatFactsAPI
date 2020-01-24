//
//  CatFactController.swift
//  CatFacts
//
//  Created by Devin Singh on 1/23/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

class CatFactController {
    
    static private let baseURL = URL(string: "http://www.catfact.info/api/v1/facts.json")
    
    static func fetchCatFacts(page: Int, completion: @escaping (Result <[CatFact], NetworkError>) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        
        // Puts URL in components format
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        // Creates query
        let pageQuery = URLQueryItem(name: "page", value: "\(page)")
        let perPageQuery = URLQueryItem(name: "per_page", value: ":per_page")
        // Adds query to components
        components?.queryItems = [pageQuery, perPageQuery]
        // Gets new url from components
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        // 2 - Contact server
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle errors from the server
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            // 4 - Check for json data
            guard let data = data else { return completion(.failure(.noDataFound))}
            
            
            do {
                let topLevelGetObj = try JSONDecoder().decode(TopLevelGETObject.self, from: data)
                return completion(.success(topLevelGetObj.facts))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func postCatFact(details: String, completion: @escaping (Result <CatFact, NetworkError>) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        // 2 - Encode JSON
        // Prepare POST Request
        
        let post = TopLevelPOSTObject(fact: .init(id: nil, details: details))
        // 3 - Create request
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        let data = try? JSONEncoder().encode(post)
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
//        do {
//
//        } catch {
//            print(error, error.localizedDescription)
//            completion(.failure(.thrownError(error)))
//        }
        
        // 4 - Contact server
        URLSession.shared.dataTask(with: request) { (data, _, error) in
             // 5 - Handle errors from the server
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noDataFound))}
        
            do {
                // 6 - Check for/decode data
                let response = try JSONDecoder().decode(CatFact.self,from: data)
              // TODO
                completion(.success(response))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
