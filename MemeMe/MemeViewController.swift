//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Glenn Axworthy on 12/8/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    var memeToView: Int? = nil

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var memeView: MemeView!
    @IBOutlet weak var trashButon: UIBarButtonItem!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeView.imageView.image = (MemeData.array[memeToView!].meme)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func touchedEditButton(sender: UIBarButtonItem) {

        /*
            A modal segue cannot be performed from an embedded navigation controller
            unless it's the root controller. Use the segue to editor defined there
        */
        
        let controller = navigationController!.viewControllers[0] // root controller
        assert(controller as? SentMemesViewController != nil) // SentMemes -> Editor
        controller.performSegueWithIdentifier("EditorViewControllerSegue", sender: memeToView)

    }

    @IBAction func touchedTrashButton(sender: UIBarButtonItem) {
        MemeData.array.removeAtIndex(memeToView!)
        navigationController?.popViewControllerAnimated(true)
    }
}
