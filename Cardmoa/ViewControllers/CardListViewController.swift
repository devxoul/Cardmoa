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


    var tableView: UITableView!

    var cards: [Card]!


    convenience override init() {
        self.init(nibName: nil, bundle: nil)
        self.title = __("Cardmoa")
        self.view.backgroundColor = UIColor.whiteColor()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Edit,
            target: self,
            action: "editButtonDidPress"
        )
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
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let card = self.cards[indexPath.row]
        let detailView = CardDetailViewController(card: card)
        self.navigationController?.pushViewController(detailView, animated: true)
    }


    // MARK: - Navigation Item

    func editButtonDidPress() {

    }

    func addButtonDidPress() {
        let editorView = CardEditorViewController()
        let navigationController = UINavigationController(rootViewController: editorView)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }


    // MARK: - Notification

    func cardDidSave(notification: NSNotification) {
        let card = notification.object as Card
        self.cards.append(card)
        Card.sort(&self.cards)
        Card.save(self.cards)
    }

    func cardDidDelete(notification: NSNotification) {

    }

}

