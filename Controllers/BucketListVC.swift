//
//  BucketListVC.swift
//  Bucket List crUD
//
//

import UIKit

class BucketListVC: UITableViewController {

    // MARK: - Variables
    private var items = ["Live in Mecca", "Go to Cairo"]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
        setupBarButtonItem()
    }

}

// MARK: - UITableView DataSource
extension BucketListVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

// MARK: - UITableView Delegate
extension BucketListVC {
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let row = indexPath.row
        let item = items[row]
        editButtonTapped(at: row, with: item)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - ItemViewController Delegate
extension BucketListVC: ItemViewControllerDelegate {
    func itemViewController(_ controller: ItemVC, didFinishAddingItem item: String) {
        items.append(item)
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }


    func itemViewController(_ controller: ItemVC, didFinishEditingItem item: String, at row: Int) {
        items[row] = item
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Private Methods
extension BucketListVC {
    private func setupTitle() {
        title = "Bucket List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }

    @objc private func addButtonTapped() {
        let identifier = String(describing: ItemVC.self)
        let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) as! ItemVC
        viewController.mode = .add
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func editButtonTapped(at row: Int, with item: String) {
        let identifier = String(describing: ItemVC.self)
        let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) as! ItemVC
        viewController.mode = .edit(row, item)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
