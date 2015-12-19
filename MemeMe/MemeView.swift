//
//  MemeView.swift
//  MemeMe
//
//  Created by Glenn Axworthy on 12/15/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit

class MemeView: UIView {

    /*
        Class to wrap an unconstrained image view inside of a constrained superview.
        Modifying the image of a constrained image view up to and including controller's
        viewDidLoad method has been observed to disturb the layout of the scene either
        immediately or upon device rotation. In these cases a toolbar at the botton of
        the scene will disappear partially or entirely. This has been confirmed in
        small single scene test apps with simple layout constraints set by IB.

        No references to this problem have feen found but placing the image view back
        into this enclosing view and allowing IB to add constraints will demonstrate
        the problem. My prior submission was rejected because of this ocurring within
        the meme detail scene when it was rotated to landscape. I don't have any more
        time to investigate and this it is a perfectly good solution and/or alternative
        implementaton demostrating programmatic layout.
    */

    var imageView: UIImageView! = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds // no auto-layout
    }
}
