//
//  CardDetailViewController.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController {

    var loadingIndicator: UIActivityIndicatorView!
    var imageView: UIImageView!

    var navigationBarHiddenTimer: NSTimer?

    var card: Card!


    convenience init(card: Card) {
        self.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.blackColor()
        self.title = card.name
        self.card = card

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backgroundDidTap"))

        self.loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        self.loadingIndicator.center = CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds))
        self.loadingIndicator.startAnimating()
        self.view.addSubview(self.loadingIndicator)

        self.imageView = UIImageView(frame: self.view.bounds)
        self.imageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.imageView.contentMode = .ScaleAspectFit
        self.view.addSubview(self.imageView)

        self.card.fetchImage(
            success: {
                self.loadingIndicator.stopAnimating()
                self.imageView.image = self.card.image
            },
            failure: {
                self.loadingIndicator.stopAnimating()
            }
        )
    }

    override func viewDidAppear(animated: Bool) {
        self.startNavigationBarHiddenTimer()
    }

    func startNavigationBarHiddenTimer() {
        self.stopNavigationBarHiddenTimer()
        self.navigationBarHiddenTimer = NSTimer(
            timeInterval: 0.5,
            target: self,
            selector: "hideNavigationBar",
            userInfo: nil,
            repeats: false
        )
        NSRunLoop.currentRunLoop().addTimer(self.navigationBarHiddenTimer!, forMode: NSRunLoopCommonModes)
    }

    func stopNavigationBarHiddenTimer() {
        if let timer = self.navigationBarHiddenTimer {
            timer.invalidate()
            self.navigationBarHiddenTimer = nil
        }
    }

    func hideNavigationBar() {
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }

    func backgroundDidTap() {
        self.stopNavigationBarHiddenTimer()
        let hidden = self.navigationController!.navigationBarHidden
        self.navigationController!.setNavigationBarHidden(!hidden, animated: true)
    }

}
