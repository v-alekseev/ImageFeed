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
    
    private enum NetworkError: Error {
        case codeError
        case reciveDataError
    }
    
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void)  -> URLSessionDataTask? {

        print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
        
        print("IMG \request.allHTTPHeaderFields = \(request.allHTTPHeaderFields)")
        print("IMG \request.debugDescription = \(request.debugDescription)")
        print("IMG \request.debugDescription = \(request.url)")
   
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("IMG \(#file)-\(#function)(\(#line)) isMainThread = \(Thread.isMainThread)")
            
       
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(Result.failure(error))
                return
            }
            
           
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                
                print("IMG statusCode = \(response.statusCode)")
                handler(Result.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else {
                handler(Result.failure(NetworkError.reciveDataError))
                return
            }
            
            // пока оставим тут todo
            print("IMG Data = \(String(decoding: data, as: UTF8.self))")
            
            handler(Result.success(data))
        }
        
        task.resume()
        return task
    }
}

