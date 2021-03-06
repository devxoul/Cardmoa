//
//  ViewController.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class CardListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private struct CellIdentifier {
        static let Default = "Default"
    }


    var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    var tableView: UITableView!

    var cards: [Card]!


    convenience override init() {
        self.init(nibName: nil, bundle: nil)
        self.title = __("card_list")
        self.view.backgroundColor = UIColor.whiteColor()

        self.editButton = UIBarButtonItem(
            barButtonSystemItem: .Edit,
            target: self,
            action: "editButtonDidPress"
        )
        self.doneButton = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "editButtonDidPress"
        )
        self.navigationItem.leftBarButtonItem = self.editButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: "addButtonDidPress"
        )

        self.tableView = UITableView()
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelectionDuringEditing = true
        self.view.addSubview(self.tableView)

        self.cards = Card.fetchAll()
        self.tableView.reloadData()

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "cardDidSave:",
            name: CardDidSaveNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "cardDidDelete:",
            name: CardDidDeleteNotification,
            object: nil
        )
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateEditButtonHidden()
        if self.tableView.editing {
            self.setTableViewEditing(false, animated: false)
        }
    }


    // MARK: - UITableView

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Default) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellIdentifier.Default)
        }
        let card = self.cards[indexPath.row]
        cell!.textLabel?.text = card.name
        cell!.detailTextLabel?.text = card.memo
        cell!.detailTextLabel?.textColor = UIColor.darkGrayColor()
        cell!.accessoryType = .DisclosureIndicator
        cell!.editingAccessoryType = .DisclosureIndicator
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let card = self.cards[indexPath.row]

        if !tableView.editing {
            let detailView = CardDetailViewController(card: card)
            self.navigationController?.pushViewController(detailView, animated: true)
        } else {
            let editorView = CardEditorViewController(card: card)
            let navigationController = UINavigationController(rootViewController: editorView)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView,
                   commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        let card = self.cards[indexPath.row]
        card.deleteImage()
        self.cards.removeAtIndex(indexPath.row)
        Card.save(self.cards)
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
        self.updateEditButtonHidden()
    }

    func setTableViewEditing(editing: Bool, animated: Bool) {
        if editing {
            self.navigationItem.leftBarButtonItem = self.doneButton
        } else {
            self.navigationItem.leftBarButtonItem = self.editButton
        }
        self.tableView.setEditing(editing, animated: animated)
    }


    // MARK: - Navigation Item

    func updateEditButtonHidden() {
        if self.cards.count == 0 {
            self.navigationItem.leftBarButtonItem = nil
        } else if self.tableView.editing {
            self.navigationItem.leftBarButtonItem = self.doneButton
        } else {
            self.navigationItem.leftBarButtonItem = self.editButton
        }
    }

    func editButtonDidPress() {
        let editing = self.tableView.editing
        self.setTableViewEditing(!editing, animated: true)
    }

    func addButtonDidPress() {
        let editorView = CardEditorViewController()
        let navigationController = UINavigationController(rootViewController: editorView)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }


    // MARK: - Notification

    func cardDidSave(notification: NSNotification) {
        let card = notification.object as Card
        if !contains(self.cards, card) {
            self.cards.append(card)
        }
        Card.sort(&self.cards)
        Card.save(self.cards)
        self.tableView.reloadData()
        self.updateEditButtonHidden()
    }

    func cardDidDelete(notification: NSNotification) {

    }

}

