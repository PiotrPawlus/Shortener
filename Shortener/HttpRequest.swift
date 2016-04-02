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
    
        let url = "https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyD4dnoHm33xMafgjIxqtVTIWdKrWj1ilnw"
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: url)!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = JSONResponseSerializer()
        
        let params = ["longUrl" : "http://whoishiring.io"]
        
        manager.POST(url,
                     parameters: params,
                     progress: nil,
                     success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                        let response = task.response as! NSHTTPURLResponse
                        print(response.statusCode)
                        print("success")
                     },
                     failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        print("Error: \(error.localizedDescription)")
                        if let data = error.userInfo["data"] as? NSDictionary {
                            print(data)
                        }
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



class JSONResponseSerializer: AFJSONResponseSerializer
{
    override func responseObjectForResponse(response: NSURLResponse?, data: NSData?, error: NSErrorPointer) -> AnyObject? {
        let json = super.responseObjectForResponse(response, data: data, error: error)! as AnyObject
        

        if ((error.memory) != nil) {
            let errorValue = error.memory!
            let userInfo = errorValue.userInfo as NSDictionary
            let copy = userInfo.mutableCopy() as! NSMutableDictionary
            
            copy["data"] = json
            error.memory = NSError(domain: errorValue.domain, code: errorValue.code, userInfo: copy as [NSObject : AnyObject])
        }
        
        return json
    }
}

