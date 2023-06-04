//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Vitaly Alekseev on 03.06.2023.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

/// Отвечает за загрузку данных по URL
struct NetworkClient: NetworkRouting {

    private enum NetworkError: Error {
        case codeError
        case reciveDataError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        // непосредственно запрос к API IMDB
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверяем, пришла ли ошибка
            if let error = error {
                print("!!! error = !!!")
                handler(Result.failure(error))
                return
            }
            
            let response1 = response as? HTTPURLResponse
            let rs = response1?.statusCode
            print("\(#function)(\(#line)) statusCode = \(String(describing: rs))")
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                print("!!! Status = \(response.statusCode)")
                handler(Result.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else {
                handler(Result.failure(NetworkError.reciveDataError))
                return
            }
            
            let str = String(decoding: data, as: UTF8.self)
            print("Data = \(str)")
            
            handler(Result.success(data))
        }
        
        task.resume()
    }
}

