//
//  HttpRequest.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit

class HttpRequest {

    private let key = "AIzaSyBHpgQDAJLTHYk8ItTx5bPmlZGPERoy5cQ"
    
    init() { }

    func getURL(link: String) -> (URL: String, shortURL: String)? {
        var url: String
        
        if link.hasPrefix("http://") || link.hasPrefix("https://") {
            url = link.lowercaseString
        } else {
            url = "https://\(link.lowercaseString)"
        }
        if verifyURL(url) {
            guard let shortURL = getShortURL(url) else { return nil }
            return (url, shortURL)
        } else {
            return nil
        }

    }
    
    private func getShortURL(link: String) -> String? {
        
        let URLString: String = "https://www.googleapis.com/urlshortener/v1/url?key=\(key)"


        
        let URL = URLString.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        let manager = AFHTTPSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let params = ["longURL" : "http://whoishiring.io"]
        
        let requestSerailizer = AFJSONRequestSerializer()
        requestSerailizer.requestWithMethod("POST", URLString: URLString, parameters: params, error: nil)
        requestSerailizer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(requestSerailizer)
        
        manager.requestSerializer  = requestSerailizer
        manager.POST("/url?key={\(key)}",
                     parameters: params,
                     progress: nil,
                     success: { (operation: NSURLSessionDataTask, responseObject: AnyObject?) in
                        if let responseObject = responseObject as? NSDictionary {
                            print(responseObject["id"] as! String)
                        }
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) in
                print("Error while requesting: \(error.localizedDescription)")
        })

        
        
        return "SHORT URL"
    }
    
    private func verifyURL(link: String) -> Bool {
        let URLRegEx = "((http://)|(https://))?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [URLRegEx])
        let _ = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(link)
    }
}

