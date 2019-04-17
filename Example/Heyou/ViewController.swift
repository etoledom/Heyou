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
        default:
            showDefault()
        }
    }

    //MARK: - Examples

    func showExample_00() {
        let mainButton = Heyou.Button.init(text: "Main", style: .main) { [weak self] (button) in
            self?.onPressButton(button)
        }

        let alertController = Heyou(elements: [
            Heyou.Section(elements: [
                mainButton,
                Heyou.Body(text: "Some text behind the button"),
            ]),
            Heyou.Section(elements: [
                Heyou.Title(text: "Title"),
                Heyou.Body(text: "A long description text goes here."),
                Heyou.Button(text: "Secondary", style: Heyou.ButtonStyle.normal),
            ]),
            Heyou.Section(elements: [
                Heyou.Image(image: UIImage(named: "alert")!),
                Heyou.Body(text: "Some text behind the button"),
            ])
        ])

        alertController.show(onViewController: self)
    }

    @objc func onPressButton(_ button: Heyou.Button) {
        print("Pressed button with text: \(button.text)")
    }

    func showExample_01() {
        let alertController = Heyou(elements: [
            Heyou.Section(elements: [
                Heyou.Image(image: UIImage(named: "alert")!),
                Heyou.Title(text: "Title"),
                Heyou.Body(text: "Description text"),
                Heyou.Button(text: "OK", style: .normal)
            ])
        ])

        alertController.show(onViewController: self)
    }

    func showExample_02() {
        let alertController = Heyou(elements: [
            Heyou.Section(elements: [
                Heyou.Title(text: "Title"),
                Heyou.Body(text: "Description text"),
                Heyou.Button(text: "OK", style: .normal),
                Heyou.Button(text: "Cancel", style: .normal)
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
            Heyou.Section(elements: [
                Heyou.ButtonsSection(buttons: [
                    Heyou.Button(text: "Default", style: .normal),
                    Heyou.Button(text: "Destructive", style: .normal),
                    Heyou.Button(text: "Cancel", style: .normal)
                    ])
                ])
            ])

        alertController.show(onViewController: self)
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
