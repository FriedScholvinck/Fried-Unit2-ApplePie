//
//  ViewController.swift
//  Apple Pie
//
//  Created by Fried on 08/11/2018.
//  Copyright © 2018 Fried. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // list of words to play in that order and amount of apples on tree
    let allWords = ["buccaneer", "swift", "glorious", "incandescant", "bug", "program"]
    var listOfWords: [String] = []
    var incorrectMovesAllowed = 7
    
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    // create outlets
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var startAgainButton: UIButton!
    
    
    // call newRound when view loads again
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // apply design to buttons and label
        for button in letterButtons {
            button.applyDesign()
        }
        scoreLabel.applyDesign()
        startAgainButton.applyDesign()
        
        // start again only when no words left
        startAgainButton.isHidden = true
        
        // copy words to usable variable
        listOfWords = allWords
        
        newRound()
    }

    var currentGame: Game!
    
    func newRound() {
        
        // get next word in list and create game
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            
            // set letters available
            enableLetterButtons(true)
            updateUI()
        } else {
            
            // give option to start again
            enableLetterButtons(false)
            startAgainButton.isHidden = false
        }
    }
    
    // update interface
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        
        // update labels and image
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins)     Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    // when letter is tapped
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        // make sure letter cannot be tapped again
        sender.isEnabled = false
        sender.backgroundColor = UIColor.lightGray
        
        // get button value and send it to game
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateUI()
        updateGameState()
    }
    
    // update values within game instance
    func updateGameState() {
            if currentGame.incorrectMovesRemaining == 0 {
                totalLosses += 1
            } else if currentGame.word == currentGame.formattedWord {
                totalWins += 1
            } else {
                updateUI()
        }
    }
    
    // enable or disable all letters for new word
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
            if enable {
                button.backgroundColor = UIColor.darkGray
            }
            else {
                button.backgroundColor = UIColor.lightGray
            }
        }
    
    }
    
    // reset values and load view again, eventually calling newRound() on original list
    @IBAction func startAgainButtonTapped(_ sender: UIButton) {
        incorrectMovesAllowed = 7
        totalWins = 0
        totalLosses = 0
        
        viewDidLoad()
    }
}

// create button design
extension UIButton {
    func applyDesign() {
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
    }
}

// create label design
extension UILabel {
    func applyDesign() {
        self.backgroundColor = UIColor.darkGray
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.textColor = UIColor.white
    }
}
