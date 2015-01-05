//
//  CardEditorViewController.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class CardEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditableCellDelegate,
    CardImageCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private enum Section: Int {
        case Info, Image
    }

    private struct CellIdentifier {
        static let Info = "Info"
        static let Image = "Image"
    }


    var tableView: UITableView!

    var card: Card?
    var name: String?
    var memo: String?
    var image: UIImage?
    var loadingImage: Bool = false


    convenience override init() {
        self.init(nibName: nil, bundle: nil)
        self.title = __("New Card")

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: "cancelButtonDidPress"
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Save,
            target: self,
            action: "saveButtonDidPress"
        )
        self.navigationItem.rightBarButtonItem!.enabled = false

        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(EditableCell.self, forCellReuseIdentifier: CellIdentifier.Info)
        self.tableView.registerClass(CardImageCell.self, forCellReuseIdentifier: CellIdentifier.Image)
        self.view.addSubview(self.tableView)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }

    convenience init(card: Card) {
        self.init()
        self.title = __("Edit Card")
        self.card = card
        self.name = card.name
        self.name = card.memo

        if let image = card.image {
            self.image = image
        } else {
            self.loadingImage = true
            card.fetchImage(
                success: {
                    self.loadingImage = false
                    self.image = card.image
                    // TODO: Update tableview without dismiss keyboard
                },
                failure: {
                    self.loadingImage = false
                    card.image = nil
                    // TODO: Update tableview without dismiss keyboard
                }
            )
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    // MARK: - UITableView

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Info: return 2
        case .Image: return 1
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .Info: return __("Card info")
        case .Image: return __("Card image")
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section)! {
        case .Info: return 44
        case .Image:
            if let image = self.image {
                return image.size.height * CGRectGetWidth(self.tableView.bounds) / image.size.width
            } else {
                return 44
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .Info:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Info) as EditableCell
            cell.delegate = self
            if indexPath.row == 0 {
                cell.textField.placeholder = __("Name")
                cell.textField.text = self.name
            } else {
                cell.textField.placeholder = __("Memo") + " (" + __("Optional") + ")"
                cell.textField.text = self.memo
            }
            return cell

        case .Image:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Image) as CardImageCell
            cell.delegate = self
            cell.loading = self.loadingImage
            if !self.loadingImage {
                if let image = self.image {
                    cell.cardImage = image
                } else if let image = self.card?.image {
                    cell.cardImage = image
                } else {
                    cell.cardImage = nil
                }
            }
            return cell
        }
    }


    // MARK: - Keyboard Notification

    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue

        UIView.animateWithDuration(
            animationDuration,
            animations: {
                self.tableView.contentInset.bottom = CGRectGetHeight(keyboardFrame)
                self.tableView.scrollIndicatorInsets.bottom = self.tableView.contentInset.bottom
            },
            completion: nil
        )
    }

    func keyboardWillHide(notification: NSNotification) {
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue

        UIView.animateWithDuration(
            animationDuration,
            animations: {
                self.tableView.contentInset.bottom = 0
                self.tableView.scrollIndicatorInsets.bottom = self.tableView.contentInset.bottom
            },
            completion: nil
        )
    }


    // MARK: - CardImageCellDelegate

    func cardImageCellDidTap(cell: CardImageCell) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }


    // MARK: - UIImagePickerDelegate

    func imagePickerController(picker: UIImagePickerController!,
                               didFinishPickingImage image: UIImage!,
                               editingInfo: [NSObject : AnyObject]!) {
        self.image = image
        self.tableView.reloadSections(NSIndexSet(index: Section.Image.rawValue), withRowAnimation: .None)
        self.updateSaveButtonEnabled()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - EditableCellDelegate

    func editableCellTextDidChange(cell: EditableCell) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if indexPath.row == 0 {
                self.name = cell.textField.text
            } else {
                self.memo = cell.textField.text
            }
            self.updateSaveButtonEnabled()
        }
    }


    // MARK: - Navigation Item

    func updateSaveButtonEnabled() {
        let enabled = (self.name != nil && !self.name!.isEmpty && self.image != nil)
        self.navigationItem.rightBarButtonItem?.enabled = enabled
    }

    func cancelButtonDidPress() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func saveButtonDidPress() {
        updateSaveButtonEnabled()
        if self.navigationItem.rightBarButtonItem?.enabled == false {
            return
        }

        var card: Card! = self.card
        if card == nil {
            card = Card()
        }

        card.name = self.name!
        card.memo = self.memo!
        card.image = self.image!
        card.saveImage()
        NSNotificationCenter.defaultCenter().postNotificationName(CardDidSaveNotification, object: card)

        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
