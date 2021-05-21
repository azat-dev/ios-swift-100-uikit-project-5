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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(startGame)
        )
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        for character in word {
            if let index = tempWord.firstIndex(of: character) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 || word == title {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        guard let sourceWord = title else {
            return
        }
        
        guard isPossible(word: lowerAnswer) else {
            showErrorAlert(
                title: "Word is impossible",
                message: "You can't spell that word from \(sourceWord)"
            )
            return
        }
        
        guard isOriginal(word: lowerAnswer) else {
            showErrorAlert(
                title:"Word used already",
                message: "The word has already been used"
            )
            return
        }
        
        guard isReal(word: lowerAnswer) else {
            showErrorAlert(
                title: "Word not recognised",
                message: "You can't just make them up, you know!"
            )
            return
        }
        
        usedWords.insert(lowerAnswer, at: 0)
        
        let index = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
    }
    
    @objc func promptForAnswer() {
        let alert = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alert] _ in
            guard let answer = alert?.textFields?[0].text else {
                return
            }
            
            self?.submit(answer)
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
    
    @objc func startGame() {
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

