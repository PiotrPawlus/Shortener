//
//  HttpRequest.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit

class HttpRequest {

    private let key = "AIzaSyD1WMV_kXlvt4tQSlv0KX3w8x6wlfZ8E_8"
    
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
//        let urlString: String = "https://to.ly/api.php?longurl=\(link)"

        
        let urlString: String = "https://www.googleapis.com/urlshortener/v1/url?key=\(key)"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        
        
        
        let manager = AFHTTPSessionManager()
        
        manager.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
        
        let parmas = [ "longURL" : link ]

        manager.POST(urlString, parameters: parmas, success: {
            (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            print(responseObject!["id"] as! String)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("Error while requesting shortened: \(error.localizedDescription)")
        }
        
        
//        let task = session.dataTaskWithURL(url!) {
//            (data: NSData?, response: NSURLResponse?, error: NSError?) in
//            
//            if error != nil {
//                print(error?.localizedDescription)
//            } else {
//                let responseString = NSString(data: data!, encoding: NSASCIIStringEncoding)
//                let response = responseString as! String
//                print(response)
//            }
//        }
//        task.resume()
        
        return "SHORT URL"
    }
    
    private func verifyURL(link: String) -> Bool {
        let URLRegEx = "((http://)|(https://))?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [URLRegEx])
        let _ = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(link)
    }
}

