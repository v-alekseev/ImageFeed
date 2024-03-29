//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 03.06.2023.
//

import Foundation

protocol NetworkRouting {
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask?
}

/// Отвечает за загрузку данных по URL
struct NetworkClient: NetworkRouting {
    
    public enum NetworkError: Error {
        case statusCodeError
        case reciveDataError
        case genericError(Error)
    }
    
    func fetchAndParse<T: Decodable>( for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        
        let task = self.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let responce = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(responce))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(Result.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
        return task
    }
    
    
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void)  -> URLSessionDataTask? {
        
        print("IMG URLRequest url  = \(String(describing: request.url))")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(Result.failure(NetworkError.genericError(error)))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(Result.failure(NetworkError.statusCodeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else {
                handler(Result.failure(NetworkError.reciveDataError))
                return
            }
            
            // пока оставим тут todo
            //print("IMG Data = \(String(decoding: data, as: UTF8.self))")
            
            handler(Result.success(data))
        }
        
        task.resume()
        return task
    }
}

