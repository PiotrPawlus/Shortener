//
//  LinksTableViewController.swift
//  Shortener
//
//  Created by Piotr Pawluś on 31/03/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit
import CoreData

class LinksTableViewController: UITableViewController, FetchLinkProtocol {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!

    var managedObjectContext: NSManagedObjectContext?
    
    var httpAddresses = [HTTPAddress]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Links"
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetch() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "HTTPAddress")
        
        do {
            let fetchResult = try managedObjectContext?.executeFetchRequest(fetchRequest)
            httpAddresses = fetchResult as! [HTTPAddress]
        } catch let err as NSError {
            print("Could not fetch \(err), \(err.userInfo)")
        }
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return httpAddresses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LinksCell") as! LinksCell

        let end = httpAddresses.count - indexPath.row - 1
        let addres = httpAddresses[end]
        cell.urlTextView!.text = addres.httpAddress
        cell.shortUrlTextView!.text = addres.shortHttpAddress

        return cell
    }
}
