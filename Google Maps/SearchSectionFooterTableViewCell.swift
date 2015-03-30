//
//  SearchSectionFooterTableViewCell.swift
//  Google Maps
//
//  Created by Teddy Wyly on 2/5/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class SearchSectionFooterTableViewCell: RoundedSectionShadowTableViewCell {

    @IBOutlet weak var majorLabel: UILabel!
    
    override func setup() {
        super.setup()
        self.majorLabel.font = UIFont.applicationBoldFont(12)
    }

}
