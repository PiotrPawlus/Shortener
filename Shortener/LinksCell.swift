//
//  LinksCell.swift
//  Shortener
//
//  Created by Piotr Pawluś on 02/04/16.
//  Copyright © 2016 Piotr Pawluś. All rights reserved.
//

import UIKit

class LinksCell: UITableViewCell {

    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var shortUrlTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        urlTextView.editable = false
        shortUrlTextView.editable = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
