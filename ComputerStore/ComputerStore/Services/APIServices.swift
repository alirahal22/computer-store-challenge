//
//  APIServices.swift
//  ComputerStore
//
//  Created by Ali Rahal on 5/31/19.
//  Copyright © 2019 Ali Rahal. All rights reserved.
//

import Foundation
import SwiftyJSON


class APIServices {
    public static let shared = APIServices()
    
    //Never use this method with searchString!=nil and filters!=nil
    public func fetchComputers(fromPage: Int, searchString: String?, filters: [String: Any]?,completion: @escaping([Computer]?, Error?) -> ()) {
        var urlString = "http://127.0.0.1:3000/computers"
        if let searchString = searchString {
            urlString = urlString + "/search/\(searchString)/page/\(fromPage)"
        }
        else if filters != nil {
            urlString = urlString + "/search/filter/page/\(fromPage)"
        } else {
            urlString = urlString + "/page/\(fromPage)"
        }
        
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        
        
        //insert post data to body if there are any filters
        if let filters = filters {
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let requestBody = createFiltersJSON(from: filters).rawString()!
            request.httpBody = requestBody.data(using: .utf8)
        }
        
        //send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let computers = try JSONDecoder().decode([Computer].self, from: data)
                DispatchQueue.main.async {
                    completion(computers, nil)
                }
            } catch let jsonErr {
                completion(nil, jsonErr)
                print("Failed to decode: \(jsonErr)")
            }
        }
        task.resume()
        
    }
    
    public func createComputer(from computer: Computer, completion: @escaping(Error?) -> ()) {
        
        let urlString = "http://127.0.0.1:3000/computers"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createComputerJSON(from: computer).rawString()?.data(using: .utf8)
        
        //send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error)")
                completion(error)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    public func updateComputer(computer: Computer, completion: @escaping(Error?) -> ()) {
        
        let urlString = "http://127.0.0.1:3000/computers/" + computer._id!
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createUpdateComputerJSON(for: computer).rawString()?.data(using: .utf8)
        
        //send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error)")
                completion(error)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    public func deleteComputer(computerId: String, completion: @escaping(Error?) -> ()) {
        
        let urlString = "http://127.0.0.1:3000/computers/" + computerId
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        //send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error)")
                completion(error)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    public func fetchStrings(from route: String,completion: @escaping([String]?, Error?) -> ()) {
        let urlString = "http://127.0.0.1:3000/computers/" + route
        
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        //send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let array = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    completion(array, nil)
                }
            } catch let jsonErr {
                completion(nil, jsonErr)
                print("Failed to decode: \(jsonErr)")
            }
        }
        task.resume()
        
    }
    
    
    //MARK: - Helpers
    func createFiltersJSON(from filters: [String : Any]) -> JSON{
        var f = [[String : Any]]()
        for (key, value) in filters {
            f.append(["propName": key, "value": value])
        }
        return JSON(f)
    }
    
    func createComputerJSON(from computer: Computer!) -> JSON {
        let computerDictionary: [String : Any] = [
            "name": computer.name!,
            "price": computer.price!,
            "modelNumber": computer.modelNumber!,
            "cpu": computer.cpu!,
            "rams": computer.rams!,
            "brand": computer.brand!
        ]
        return JSON(computerDictionary)
    }
    
    func createUpdateComputerJSON(for computer: Computer) -> JSON {
        let computerDictionary: [String : Any] = [
            "name": computer.name!,
            "price": computer.price!,
            "modelNumber": computer.modelNumber!,
            "cpu": computer.cpu!,
            "rams": computer.rams!,
            "brand": computer.brand!
        ]
        return createFiltersJSON(from: computerDictionary)
    }
    
}
