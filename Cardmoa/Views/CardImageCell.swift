//
//  CardImageCell.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class CardImageCell: UITableViewCell {

    var loading: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }

    var cardImage: UIImage? {
        didSet {
            self.setNeedsLayout()
        }
    }

    weak var delegate: CardImageCellDelegate?

    var loadingIndicator: UIActivityIndicatorView!
    var addButton: UIButton!
    var cardImageView: UIImageView!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None

        self.loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.contentView.addSubview(self.loadingIndicator)

        self.addButton = UIButton.buttonWithType(.System) as UIButton
        self.addButton.frame = self.bounds
        self.addButton.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.addButton.setTitle(__("add_image"), forState: .Normal)
        self.addButton.addTarget(self, action: "performDelegateTap", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(self.addButton)

        self.cardImageView = UIImageView(frame: self.bounds)
        self.cardImageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.cardImageView.userInteractionEnabled = true
        self.cardImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "performDelegateTap"))
        self.contentView.addSubview(self.cardImageView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.loading {
            // loading indicator
            self.loadingIndicator.center = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds))
            self.loadingIndicator.hidden = false
            self.loadingIndicator.startAnimating()
            self.addButton.hidden = true
            self.cardImageView.hidden = true
        } else if let image = self.cardImage {
            // image
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.addButton.hidden = true
            self.cardImageView.hidden = false
            self.cardImageView.image = image
        } else {
            // add button
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.addButton.hidden = false
            self.cardImageView.hidden = true
        }
    }

    func performDelegateTap() {
        self.delegate?.cardImageCellDidTap?(self)
    }

}

@objc protocol CardImageCellDelegate: NSObjectProtocol {
    optional func cardImageCellDidTap(cell: CardImageCell)
}
