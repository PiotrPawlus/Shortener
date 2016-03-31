//
//  HttpRequest.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit

class HttpRequest {
    
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
        let postEndPoint: String = "https://to.ly/api.php?longurl=\(link)"
        let url = NSURL(string: postEndPoint)!
        
        print(url)

        let request: NSURLRequest = NSURLRequest(URL: url)
        var response: NSURLResponse?
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        
            
            print("-------------RESPONSE------------")
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse)
            }
    
            let responseString = NSString(data: data, encoding: NSASCIIStringEncoding)
            print(responseString)
            
            let res = responseString as! String
            print("-------------res------------")
            print(res)
        } catch let err as NSError {
            print("Error \(err), \(err.userInfo)")
        }
        

        
        return "SHORT URL"
    }
    
    private func verifyURL(link: String) -> Bool {
        let URLRegEx = "((http://)|(https://))?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [URLRegEx])
        let _ = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(link)
    }
}

