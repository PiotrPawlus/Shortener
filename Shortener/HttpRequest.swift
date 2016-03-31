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
            url = "http://\(link.lowercaseString)"
        }
        if verifyURL(url) {
            return (url, getShortURL(url))
        } else {
            return nil
        }

    }
    
    private func getShortURL(link: String) -> String {

        return "SHORT URL"
    }
    
    private func verifyURL(link: String) -> Bool {
        let URLRegEx = "((http://)|(https://))?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [URLRegEx])
        let _ = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(link)
    }
}

