//
//  CatFactTableViewController.swift
//  CatFacts
//
//  Created by Devin Singh on 1/23/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class CatFactTableViewController: UITableViewController {
    
    private var currentPage = 0
    
    var catFacts: [CatFact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFacts()
    }
    
    // MARK: - Private methods
    
    private func presentPostAlert() {
        let alert = UIAlertController(title: "Cat Fact", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type your cat fact"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            // Get Textfields
            guard let detailTextField = alert.textFields?[0],
            // Get First + Last names
            let details = detailTextField.text,
            
                !details.isEmpty else { return }
            // Send Data to personController
            CatFactController.postCatFact(details: details) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let catFact):
                        print(catFact)
                        self.catFacts.append(catFact)
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                    }
                }
            }
        }
        alert.addAction(saveAction)
        
        present(alert, animated: true)
        
    
    }
    
    private func fetchFacts() {
        currentPage += 1
        CatFactController.fetchCatFacts(page: 1) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let facts):
                    self.catFacts += facts
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presentPostAlert()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catFacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catfactCell", for: indexPath)
        
        if indexPath.row == catFacts.count - 1 {
            fetchFacts()
        }
        
        cell.textLabel?.text = catFacts[indexPath.row].details

        return cell
    }

}
