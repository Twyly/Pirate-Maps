//
//  SideMenuHeaderView.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/20/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

class SideMenuHeaderView: UIView {
    
    func configureWithUser(user: User) {
        topDetailLabel.text = user.name
        bottomDetailLabel.text = user.email
        faceImageView.image = user.profileImage
        backgroundImageView.image = user.backgroundImage
    }

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var topDetailLabel: UILabel!
    @IBOutlet weak var bottomDetailLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        topDetailLabel.font = UIFont.applicationBoldFont(17)
        bottomDetailLabel.font = UIFont.applicationFont(17)
        topDetailLabel.textColor = UIColor.whiteColor()
        bottomDetailLabel.textColor = UIColor.whiteColor()
        faceImageView.layer.cornerRadius = faceImageView.frame.size.width / 2;
        faceImageView.clipsToBounds = true

    }
    


}
