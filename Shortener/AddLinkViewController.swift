//
//  AddLinkViewController.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit
import CoreData

class AddLinkViewController: UIViewController, AddLinkProtocol {
    
    var managedObjectContext: NSManagedObjectContext?
    var httpRequest: HttpRequest!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shorten link"
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func addLink(sender: AnyObject) {
        guard let link = linkTextField.text else { return }
        
        httpRequest = HttpRequest(delegate: self)
        httpRequest.getURL(link)
        
    }

    func pushLink(link: String, shortLink: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("HTTPAddress", inManagedObjectContext: managedObjectContext!)!
        let address = HTTPAddress(entity: entity, insertIntoManagedObjectContext: managedObjectContext!)
        
        address.httpAddress = link
        address.shortHttpAddress = shortLink
        do {
            try managedObjectContext?.save()
        } catch let err as NSError {
            print("Could not save \(err), \(err.userInfo)")
        }
    }

}
