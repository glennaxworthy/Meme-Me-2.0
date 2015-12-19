//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Glenn Axworthy on 12/6/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
    UITableViewDataSource, UITableViewDelegate {

    enum ViewType { case Table, Collection }

    var thumbnailCache: [Int : UIImage] = [:] // cached thumbnails
    var thumbnailSize: CGSize = CGSizeZero
    var viewType: ViewType = .Table

    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var collectionButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        selectViewType(viewType)

        let gesture = UISwipeGestureRecognizer(target: self, action: "onSwipeLeft:")
        gesture.direction = .Left
        tableView.addGestureRecognizer(gesture)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // four square thumbnails per column with fudge factor
        thumbnailSize.width = view.bounds.size.width / 4 - 10
        thumbnailSize.height = view.bounds.size.width / 4 - 10
        thumbnailCache.removeAll()

        clearButton.enabled = MemeData.array.count > 0
        collectionView.reloadData()
        tableView.reloadData()
    }

    func createThumbnail(row: Int, meme: UIImage) -> UIImage {
        
        func imageWithImage(image: UIImage, scaledToSize: CGSize) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0.0) // scale points to device pixels
            image.drawInRect(CGRectMake(0, 0, scaledToSize.width, scaledToSize.height))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage
        }
        
        var thumbnail = thumbnailCache[row]
        if thumbnail == nil {
            thumbnail = imageWithImage(meme, scaledToSize: thumbnailSize)
            thumbnailCache[row] = thumbnail
        }
        
        return thumbnail!
    }

    func onSwipeLeft(gesture: UISwipeGestureRecognizer) {
        // bad idea but requested - conflicts with cell selection
        let point = gesture.locationInView(view)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if let row = indexPath?.row {
            MemeData.array.removeAtIndex(row)
            tableView.reloadData()
            clearButton.enabled = MemeData.array.count > 0
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "EditorViewControllerSegue" {
            let controller = segue.destinationViewController as! EditorViewController
            controller.memeToEdit = sender as? Int
        } else if segue.identifier == "MemeViewControllerSegue" {
            let controller = segue.destinationViewController as! MemeViewController
            controller.memeToView = sender as? Int
        }
    }

    func selectViewType(viewType: ViewType) {
        switch viewType {
            
        case .Collection:
            collectionView.hidden = false
            collectionButton.tintColor = view.tintColor
            tableView.hidden = true
            tableButton.tintColor = UIColor.grayColor()
            collectionView.reloadData()

        case .Table:
            collectionView.hidden = true
            collectionButton.tintColor = UIColor.grayColor()
            tableView.hidden = false
            tableButton.tintColor = view.tintColor
            tableView.reloadData()
        }

        self.viewType = viewType
    }

    @IBAction func touchedAddButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("EditorViewControllerSegue", sender: nil)
    }

    @IBAction func touchedClearButton(sender: UIBarButtonItem) {
        MemeData.array.removeAll()
        thumbnailCache.removeAll()
        collectionView.reloadData()
        tableView.reloadData()
        clearButton.enabled = false
    }

    @IBAction func touchedCollectionButton(sender: UIBarButtonItem) {
        selectViewType(.Collection)
    }

    @IBAction func touchedTableButton(sender: UIBarButtonItem) {
        selectViewType(.Table)
    }

    // UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeData.array.count // always section 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemesCollectionViewCell", forIndexPath: indexPath)

        // add image programmatically to avoid subclassing cell - note that contentView.bounds
        // doesn't match the requested item size - use size of thumbnail for frame instead
        let meme = MemeData.array[indexPath.row].meme
        let thumbnail = createThumbnail(indexPath.row, meme: meme)
        let thumbnailFrame = CGRectMake(0, 0, thumbnail.size.width, thumbnail.size.height)
        let thumbnailView = UIImageView(frame: thumbnailFrame)
        cell.contentView.addSubview(thumbnailView)
        thumbnailView.image = thumbnail

        return cell
    }

    // UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        performSegueWithIdentifier("MemeViewControllerSegue", sender: indexPath.row as Int?)
        return false; // don't select cell
    }

    // UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let thumbnail = createThumbnail(indexPath.row, meme: MemeData.array[indexPath.row].meme)
        return thumbnail.size // size may vary
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4) // let FlowLayout determine borders
    }

    // UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "SentMemesTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        let data = MemeData.array[indexPath.row]
        cell!.textLabel!.text = data.top + "..." + data.bottom
        cell!.imageView!.image = createThumbnail(indexPath.row, meme: data.meme)
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeData.array.count
    }

    // UITableViewDelegate

    func tableView(tableView: UITableView, heightForRowAtIndexPath: NSIndexPath) -> CGFloat {
        return thumbnailSize.height + 2
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        performSegueWithIdentifier("MemeViewControllerSegue", sender: indexPath.row as Int?)
        return nil // don't select cell
    }
}
