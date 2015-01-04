//
//  CardDetailViewController.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController {

    var imageView: UIImageView!

    var card: Card!


    convenience init(card: Card) {
        self.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.blackColor()
        self.title = card.name
        self.card = card

        self.imageView = UIImageView()
        self.imageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.view.addSubview(self.imageView)

        self.loadImage()
    }

    func loadImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            if let image = UIImage(contentsOfFile: self.card.imagePath) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = image
                })
            } else {
                // TODO: Error loading image from disk
            }
        })
    }

}
