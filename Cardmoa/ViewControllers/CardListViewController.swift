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

    private struct UserDefaultsKey {
        static let Cards = "Cards"
    }


    var tableView: UITableView!

    var cards: [Card]!


    convenience override init() {
        self.init(nibName: nil, bundle: nil)
        self.title = __("Cardmoa")
        self.view.backgroundColor = UIColor.whiteColor()

        self.tableView = UITableView()
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)

        self.cards = []
        self.fetchCards()
    }


    // MARK: -

    func fetchCards() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let cards = userDefaults.objectForKey(UserDefaultsKey.Cards) as? [[String: AnyObject]] {
            self.cards = cards.map { Card(dictionary: $0) }
        }
        let card = Card()
        card.name = "Starbucks"
        card.memo = "예지꺼"
        self.cards.append(card)
        self.tableView.reloadData()
    }

    func saveCards() {
        var cards = self.cards.map { $0.dictionaryValue }
        NSUserDefaults.standardUserDefaults().setObject(cards, forKey: UserDefaultsKey.Cards)
        NSUserDefaults.standardUserDefaults().synchronize()
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

}

