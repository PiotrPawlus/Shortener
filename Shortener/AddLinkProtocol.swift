//
//  AddLinkProtocol.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit
import CoreData

public protocol AddLinkProtocol {
    var managedObjectContext: NSManagedObjectContext? { get }
    
    func pushLink(link: String)
}
