//
//  ViewController.swift
//  Project5
//
//  Created by Azat Kaiumov on 21.05.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    func loadWords() {
        guard let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            return
        }
        
        guard let startWords = try? String(contentsOf: startWordsUrl) else {
            return
        }
        
        allWords = startWords.components(separatedBy: "\n")
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        print("Words were loaded \(allWords.count)")
    }
    
    func initNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
    }
    
    func submit(word: String) {
        
    }
    
    @objc func promptForAnswer() {
        let alert = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alert] _ in
            guard let word = alert?.textFields?[0].text else {
                return
            }
            
            self?.submit(word: word)
        }
        
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWords()
        initNavigationBar()
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
}

