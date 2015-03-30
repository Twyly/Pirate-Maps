//
//  RoundedSectionShadowTableViewCell.swift
//  Google Maps
//
//  Created by Teddy Wyly on 1/29/15.
//  Copyright (c) 2015 Teddy Wyly. All rights reserved.
//

import UIKit

protocol RoundedSectionTableViewCellDelegate: class {
    func touchUpRecognizedOnCell(view: RoundedSectionShadowTableViewCell)
}

class RoundedSectionShadowTableViewCell: UITableViewCell, BubbleTouchViewDelegate {
    
    @IBOutlet weak var bubbleView: BubbleTouchView!
    @IBOutlet weak var shadowView: ShadowView!
    
    var isFirstRow: Bool = false
    var isLastRow: Bool = false
    
    weak var delegate: RoundedSectionTableViewCellDelegate?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shouldRasterize = true;
        bubbleView.clipsToBounds = true
        bubbleView.delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
        roundCorners()
    }
    
    func prepareShadowsAndCorners(tableView: UITableView, path: NSIndexPath) {
        isFirstRow = path.row == 0
        isLastRow = path.row == tableView.numberOfRowsInSection(path.section) - 1
    }
    
    
    private func applyShadow() {
        if isFirstRow && isLastRow {
            shadowView.excludeEdges = .None
        } else if isFirstRow {
            shadowView.excludeEdges = .Bottom
        } else if isLastRow {
            shadowView.excludeEdges = .Top
        } else {
            shadowView.excludeEdges = .Top | .Bottom
        }
    }
    
    private func roundCorners() {
        let cornerRadius: CGFloat = 1
        if isFirstRow && isLastRow {
            bubbleView.layer.cornerRadius = cornerRadius
        } else if isFirstRow {
            bubbleView.layer.cornerRadius = cornerRadius
        } else if isLastRow {
            bubbleView.layer.cornerRadius = cornerRadius
        } else {
            bubbleView.layer.cornerRadius = 0
        }
    }
    

    //MARK: - BubbleTouchViewDelegate
    func touchUpRecognizedOnBubbleView(view: BubbleTouchView) {
        delegate?.touchUpRecognizedOnCell(self)
    }

}
