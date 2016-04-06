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
    private weak var delegate: AddLinkViewController!

    init(delegate: AddLinkViewController) {
        self.delegate = delegate
    }

    func getURL(link: String) {
        var url: String

        if link.hasPrefix("http://") || link.hasPrefix("https://") {
            url = link.lowercaseString
        } else {
            url = "https://\(link.lowercaseString)"
        }

        if verifyURL(url) {
            getShortURL(url, completion: { (short) in
                dispatch_async(dispatch_get_main_queue(), {
                    guard let short = short else { return }
                    self.delegate?.pushLink(link, shortLink: short)
                })
            })
        } else {
            return
        }
    }

    private func getShortURL(link: String, completion: ((short: String?) -> Void)) {
        let key = ""
        let url = "https://www.googleapis.com/urlshortener/v1/url?key=\(key)"
        let params = ["longUrl": link]

        let manager = AFHTTPSessionManager(baseURL: NSURL(string: url)!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = JSONResponseSerializer()

        let dataTask = manager.POST(url,
                                    parameters: params,
                                    progress: nil,
                                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                                        if let responseObject = responseObject as? NSDictionary {
                                            let shortURL = responseObject["id"] as? String
                                            completion(short: shortURL)
                                        }
                                    },
                                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                                        if let data = error.userInfo["data"] as? NSDictionary {
                                            print(data)
                                            completion(short: nil)
                                        }
                                    })!
        dataTask.resume()
    }

    private func verifyURL(link: String) -> Bool {
        let urlRegEx = "((http://)|(https://))?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [urlRegEx])
        let _ = NSPredicate.predicateWithSubstitutionVariables(predicate)

        return predicate.evaluateWithObject(link)
    }

}

class JSONResponseSerializer: AFJSONResponseSerializer {

    override func responseObjectForResponse(response: NSURLResponse?, data: NSData?, error: NSErrorPointer) -> AnyObject? {
        let json = super.responseObjectForResponse(response, data: data, error: error)! as AnyObject
        if error.memory != nil {
            let errorValue = error.memory!
            let userInfo = errorValue.userInfo as NSDictionary
            guard let copy = userInfo.mutableCopy() as? NSMutableDictionary else { return nil }
            copy["data"] = json
            error.memory = NSError(domain: errorValue.domain, code: errorValue.code, userInfo: copy as [NSObject: AnyObject])
        }
        return json
    }

}
