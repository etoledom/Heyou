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
        "Normal alert"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear")
    }

    func onShowAlertPress(indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            let alertController = HYAlertController()
            alertController.elements = [
                .title("Title"),
                .subTitle("A Subtitle"),
                .image(named: "house"),
                .description("A long description text goes here.")
            ]

            let mainAction = HYAlertAction(title: "First main", style: .main)
            let normalAction = HYAlertAction(title: "Normal button", style: .default)
            let secondMainAction = HYAlertAction(title: "Second main", style: .main)

            alertController.addAction(mainAction)
            alertController.addAction(normalAction)
            alertController.addAction(secondMainAction)

            alertController.showOnViewController(self)
        case 1:
            let alertController = HYAlertController()
            alertController.elements = [
                .image(named: "house"),
                .title("Title"),
                .description("Description text")
            ]
            let mainAction = HYAlertAction(title: "First main", style: .main)

            let normalAction = HYAlertAction(title: "Normal button", style: .default) { (_) in
                print("HELLO WORLD!")
            }
            alertController.addAction(mainAction)
            alertController.addAction(normalAction)

            alertController.showOnViewController(self)

        case 2:
            let alertController = UIAlertController(title: "Normal alert", message: "Borring normal alert", preferredStyle: .alert)

            let action01 = UIAlertAction(title: "Default", style: .default)
            let action02 = UIAlertAction(title: "Destructive", style: .destructive)
            let action03 = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(action01)
            alertController.addAction(action02)
            alertController.addAction(action03)

            present(alertController, animated: true, completion: nil)

        default: break
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onShowAlertPress(indexPath: indexPath)
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
