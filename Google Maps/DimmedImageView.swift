//
//  DimmedImageView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/20/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class DimmedImageView: UIImageView {
    
    private let dimmerView = UIView(frame: CGRectZero)

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        dimmerView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        addSubview(dimmerView)
    }
    
    override func layoutSubviews() {
        dimmerView.frame = bounds
    }

}
