//
//  ItemVC.swift
//  Bucket List crUD
//
//  Created by Mostafa Nafie on 14/12/21.
//

import UIKit

protocol ItemViewControllerDelegate {
    func itemViewController(_ controller: ItemVC,
                            didFinishAddingItem item: String)
    func itemViewController(_ controller: ItemVC,
                            didFinishEditingItem item: String,
                            at row: Int)
}

enum ItemMode {
    case add
    case edit(_ row: Int, _ item: String)

    var title: String {
        switch self {
        case .add: return "Add Item"
        case .edit: return "Edit Item"
        }
    }
}

class ItemVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!

    // MARK: - Variables
    var delegate: ItemViewControllerDelegate?
    var mode: ItemMode!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
        setupTextField()
        setupBarButtonItem()
    }
}

// MARK: - Private Methods
extension ItemVC {
    private func setupTitle() {
        title = mode.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }

    private func setupTextField() {
        switch mode {
        case .edit(_, let item):
            textField.text = item
        default:
            break
        }
    }

    @objc private func saveButtonTapped() {
        guard let item = textField.text, !item.isEmpty else { return }

        switch mode {
        case .edit(let row, _):
            delegate?.itemViewController(self, didFinishEditingItem: item, at: row)
        case .add:
            delegate?.itemViewController(self, didFinishAddingItem: item)
        default:
            break
        }

        navigationController?.popViewController(animated: true)
    }
}
