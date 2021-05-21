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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWords()
    }
}

