//
//  ViewController.swift
//  Heyou
//
//  Created by E. Toledo on 9/6/16.
//  Copyright © 2016 eToledo. All rights reserved.
//

import UIKit
import Heyou

class ViewController: UITableViewController {

    let examples: [String] = [
        "First",
        "Second",
        "Simple",
        "Buttons section",
        "Long system alert",
        "Normal alert"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    func onShowAlertPressed(indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            showExample_00()
        case 1:
            showExample_01()
        case 2:
            showExample_02()
        case 3:
            showExample_03()
        case 4:
            showLongDefault()
        default:
            showDefault()
        }
    }

    //MARK: - Examples

    func showExample_00() {
        let alertController = Heyou(elements: [
            Heyou.ScrollableSection(sections: [
                Heyou.Section(elements: [
                    Heyou.Image(image: UIImage(named: "alert")!),
                    Heyou.Body(text: "Some text behind the button"),
                    ]),
                Heyou.Section(elements: [
                    Heyou.Title(text: "Title"),
                    Heyou.Body(text: "A long description text goes here."),
                    ]),

                Heyou.Section(elements: [
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Button", style: .default),
                    Heyou.Button(text: "Cancel", style: .cancel)
                ])
            ])
        ])

        alertController.show(onViewController: self)
    }

    func showExample_01() {
        let alertController = Heyou(elements: [
            Heyou.Section(elements: [
                Heyou.Image(image: UIImage(named: "alert")!),
                Heyou.Title(text: "Title"),
                Heyou.Body(text: "Description text"),
                Heyou.Button(text: "OK")
            ])
        ])

        alertController.show(onViewController: self)
    }

    func showExample_02() {
        let alertController = Heyou(elements: [
            Heyou.Section(elements: [
                Heyou.Title(text: "Title"),
                Heyou.Body(text: "Description text"),
//                Heyou.Button(text: "OK"),
//                Heyou.Button(text: "Cancel", style: .cancel)
            ])
        ])

        alertController.show(onViewController: self)
    }

    func showExample_03() {
        let alertController = Heyou(elements: [
            Heyou.Section(elements: [
                Heyou.Title(text: "Title"),
                Heyou.Body(text: "Description text")
            ]),
            Heyou.ButtonsSection(buttons: [
                Heyou.Button(text: "Default", style: .default),
                Heyou.Button(text: "Destructive", style: .destructive),
                Heyou.Button(text: "Cancel", style: .cancel)
            ])
        ])

        alertController.show(onViewController: self)
    }

    func showLongDefault() {
        let alertController = UIAlertController(title: "Normal alert", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", preferredStyle: .alert)

        let action01 = UIAlertAction(title: "Default", style: .default)
        let action02 = UIAlertAction(title: "Destructive", style: .destructive)
        let action03 = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(action01)
        alertController.addAction(action02)
        alertController.addAction(action03)

        present(alertController, animated: true, completion: nil)
    }

    func showDefault() {
        let alertController = UIAlertController(title: "Normal alert", message: "Borring normal alert", preferredStyle: .alert)

        let action01 = UIAlertAction(title: "Default", style: .default)
        let action02 = UIAlertAction(title: "Destructive", style: .destructive)
        let action03 = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(action01)
        alertController.addAction(action02)
        alertController.addAction(action03)

        present(alertController, animated: true, completion: nil)
    }

    //MARK: - Table view

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onShowAlertPressed(indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = examples[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Examples"
    }
}
