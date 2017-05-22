//
//  HttpRequest.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit

class HttpRequest {

    fileprivate let key = "AIzaSyBHpgQDAJLTHYk8ItTx5bPmlZGPERoy5cQ"
    fileprivate weak var delegate: AddLinkViewController!

    init(delegate: AddLinkViewController) {
        self.delegate = delegate
    }

    func getURL(_ link: String) {
        var url: String

        if link.hasPrefix("http://") || link.hasPrefix("https://") {
            url = link.lowercased()
        } else {
            url = "https://\(link.lowercased())"
        }

        if verifyURL(url) {
            getShortURL(url, completion: { (short) in
                DispatchQueue.main.async(execute: {
                    guard let short = short else { return }
                    self.delegate?.pushLink(link, shortLink: short)
                })
            })
        } else {
            return
        }
    }

    fileprivate func getShortURL(_ link: String, completion: @escaping ((_ short: String?) -> Void)) {
        let key = "AIzaSyCk-7xkckJaHIOMUtHohcF-fdVE9EA0Kns"
        let url = "https://www.googleapis.com/urlshortener/v1/url?key=\(key)"
        let params = ["longUrl": link]

        let manager = AFHTTPSessionManager(baseURL: URL(string: url)!)
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = JSONResponseSerializer()

        let dataTask = manager.post(url,
                                    parameters: params,
                                    progress: nil,
                                    success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
                                        if let responseObject = responseObject as? NSDictionary {
                                            let shortURL = responseObject["id"] as? String
                                            completion(shortURL)
                                        }
                                    } as! (URLSessionDataTask, Any?) -> Void,
                                    failure: { (task: URLSessionDataTask?, error: NSError) in
                                        if let data = error.userInfo["data"] as? NSDictionary {
                                            print(data)
                                            completion(nil)
                                        }
                                    } as! (URLSessionDataTask?, Error) -> Void)!
        dataTask.resume()
    }

    fileprivate func verifyURL(_ link: String) -> Bool {
        let urlRegEx = "((http://)|(https://))?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [urlRegEx])
        let _ = NSPredicate.withSubstitutionVariables(predicate)

        return predicate.evaluate(with: link)
    }

}

class JSONResponseSerializer: AFJSONResponseSerializer {

    override func responseObject(for response: URLResponse?, data: Data?, error: NSErrorPointer) -> AnyObject? {
        let json = super.responseObject(for: response, data: data, error: error)! as AnyObject
        if error?.pointee != nil {
            let errorValue = error?.pointee!
            let userInfo = errorValue?.userInfo as! NSDictionary
            guard let copy = userInfo.mutableCopy() as? NSMutableDictionary else { return nil }
            copy["data"] = json
            error?.pointee = NSError(domain: (errorValue?.domain)!, code: (errorValue?.code)!, userInfo: copy as! [AnyHashable: Any])
        }
        return json
    }

}
