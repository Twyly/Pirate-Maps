//
//  SearchResultTableViewCell.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/22/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: RoundedSectionShadowTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    
    var leftSeperatorInset: CGFloat = 0
    let seperatorView = UIView(frame: CGRectZero)

    override func layoutSubviews() {
        super.layoutSubviews()
        configureSeperator()
    }
    
    override func setup() {
        super.setup()
        iconImageView.contentMode = .ScaleAspectFit
        seperatorView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        bubbleView.addSubview(seperatorView)
    }
    
    func configureSeperator() {
        leftSeperatorInset = majorLabel.frame.origin.x
        var frame = isLastRow ? CGRectZero : CGRectMake(leftSeperatorInset, bubbleView.bounds.size.height-1, bubbleView.bounds.size.width - leftSeperatorInset, 1)
        seperatorView.frame = frame
        seperatorView.hidden = isLastRow
    }

}
