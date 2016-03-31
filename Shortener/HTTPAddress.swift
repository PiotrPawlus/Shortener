//
//  Shortener.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit
import CoreData


class HTTPAddress: NSManagedObject {

    @NSManaged var httpAddress: String
    @NSManaged var shortHttpAddress: String
    
}
