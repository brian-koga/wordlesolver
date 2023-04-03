//
//  ViewController.swift
//  WordleSolver
//
//  Created by Brian Koga on 5/6/22.
//

import UIKit

class CustomButton : UIButton {
    var colors = [UIColor.white, UIColor.gray, UIColor.green, UIColor.yellow]
    var status: Int
    var value: Character
    
    required init?(coder aDecoder: NSCoder) {
        status = 0
        value = "-"
        
        super.init(coder: aDecoder)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0
        backgroundColor = colors[self.status]
        setTitle("", for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        
    }
    
}


class ViewController: UIViewController {
    
    
    var words: [String] = []
    var workingWords: [String: Double] = [:]
    var guessedWords: [String] = []
    
    var guess0: [CustomButton] = []
    var guess1: [CustomButton] = []
    var guess2: [CustomButton] = []
    var guess3: [CustomButton] = []
    var guess4: [CustomButton] = []
    var guess5: [CustomButton] = []
    
    var guesses: [[CustomButton]] = []
    
    var lettersCount: [[Character: Int]] = []
    var lettersFrequency: [[Character: Double]] = []
    
    var correctLetters: [Int: Character] = [:]
    var incorrectLetters: [Character] = []
    var presentLetters: [Int: Character] = [:]
    
    
    
    @IBOutlet weak var guess_0_0: CustomButton!
    @IBOutlet weak var guess_0_1: CustomButton!
    @IBOutlet weak var guess_0_2: CustomButton!
    @IBOutlet weak var guess_0_3: CustomButton!
    @IBOutlet weak var guess_0_4: CustomButton!
    @IBOutlet weak var guess_1_0: CustomButton!
    @IBOutlet weak var guess_1_1: CustomButton!
    @IBOutlet weak var guess_1_2: CustomButton!
    @IBOutlet weak var guess_1_3: CustomButton!
    @IBOutlet weak var guess_1_4: CustomButton!
    @IBOutlet weak var guess_2_0: CustomButton!
    @IBOutlet weak var guess_2_1: CustomButton!
    @IBOutlet weak var guess_2_2: CustomButton!
    @IBOutlet weak var guess_2_3: CustomButton!
    @IBOutlet weak var guess_2_4: CustomButton!
    @IBOutlet weak var guess_3_0: CustomButton!
    @IBOutlet weak var guess_3_1: CustomButton!
    @IBOutlet weak var guess_3_2: CustomButton!
    @IBOutlet weak var guess_3_3: CustomButton!
    @IBOutlet weak var guess_3_4: CustomButton!
    @IBOutlet weak var guess_4_0: CustomButton!
    @IBOutlet weak var guess_4_1: CustomButton!
    @IBOutlet weak var guess_4_2: CustomButton!
    @IBOutlet weak var guess_4_3: CustomButton!
    @IBOutlet weak var guess_4_4: CustomButton!
    @IBOutlet weak var guess_5_0: CustomButton!
    @IBOutlet weak var guess_5_1: CustomButton!
    @IBOutlet weak var guess_5_2: CustomButton!
    @IBOutlet weak var guess_5_3: CustomButton!
    @IBOutlet weak var guess_5_4: CustomButton!
    
    @IBOutlet weak var guessBox: UITextField!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var newGuessLabel: UILabel!
    @IBOutlet weak var guessView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeWordList()
        guess0 = [guess_0_0, guess_0_1, guess_0_2, guess_0_3, guess_0_4]
        guess1 = [guess_1_0, guess_1_1, guess_1_2, guess_1_3, guess_1_4]
        guess2 = [guess_2_0, guess_2_1, guess_2_2, guess_2_3, guess_2_4]
        guess3 = [guess_3_0, guess_3_1, guess_3_2, guess_3_3, guess_3_4]
        guess4 = [guess_4_0, guess_4_1, guess_4_2, guess_4_3, guess_4_4]
        guess5 = [guess_5_0, guess_5_1, guess_5_2, guess_5_3, guess_5_4]
        guesses = [guess0, guess1, guess2, guess3, guess4, guess5]
        
        // add an entry for each letter for each spot
        for i in 0...4{
            lettersCount.append([:])
            lettersFrequency.append([:])
            let startingValue = Int(("A" as UnicodeScalar).value) // 65
            for j in 0 ..< 26 {
                lettersCount[i][Character(UnicodeScalar(j + startingValue)!)] = 0
                lettersFrequency[i][Character(UnicodeScalar(j + startingValue)!)] = 0.0
            }
        }
        
        feedbackLabel.textColor = UIColor.white
    }

    // cycles through the colors as the buttons are pressed if the value is an actual letter
    @IBAction func changeColor(_ sender: CustomButton) {
        if(sender.value != "-") {
            sender.status += 1
            sender.setTitleColor(UIColor.black, for: .normal)
            if (sender.status == 4) {
                sender.status = 1
                //sender.setTitleColor(UIColor.white, for: .normal)
            }
            sender.backgroundColor = sender.colors[sender.status]
        }
        
    }
    
    
    @IBAction func GuessBox(_ sender: UIButton) {
        var validWord = true
        let nextGuess = guessBox.text
        var invalidErr = "Not in List"
        if(nextGuess?.count != 5) {
            // not right size
            validWord = false
            invalidErr = "Wrong Size"
        }
        
        // check dictionary
        var present = false
        for word in words {
            if (word == nextGuess) {
                present = true
                break
            }
        }
        if(!present) {
            // word entered not in dictionary
            validWord = false
        }
        
        if(guessedWords.count > 5) {
            // has to be < 6, because if there is 5 it can take this one more
            validWord = false
            invalidErr = "Too Many Guesses"
        }
        
        // try to add to the guessed word list
        if(validWord) {
            feedbackLabel.text = nextGuess?.uppercased()
            feedbackLabel.textColor = UIColor.white
            guessedWords.append(nextGuess!.uppercased())
            updateGuessDisplay()
        } else {
            feedbackLabel.textColor = UIColor.black
            feedbackLabel.text = invalidErr
        }
    }
    
    
    @IBAction func resetGuesses(_ sender: Any) {
        var i = 0
        while (i < guessedWords.count) {
            for space in guesses[i] {
                space.status = 0
                space.value = "-"
                space.setTitleColor(UIColor.white, for: .normal)
                space.setTitle("", for: .normal)
                space.backgroundColor = space.colors[space.status]
            }
            i = i + 1
        }
        guessedWords = []
        workingWords = [:]
        correctLetters = [:]
        incorrectLetters = []
        presentLetters = [:]
        newGuessLabel.text = ""
        guessView.setNeedsDisplay()
    }
    
    
    @IBAction func getGuessPressed(_ sender: Any) {
        newGuessLabel.text = getGuess()
    }
    
    // @ Game Methods
    
    func initializeWordList() {
        // Determine the file name
        //let filename = "wordList.txt"
        let filename = Bundle.main.path(forResource: "wordList", ofType: "txt")

        // Read the contents of the specified file
        let data = try! String(contentsOfFile: filename!)

        // Split the file into separate lines
        words = data.components(separatedBy: "\n")
        
        words.remove(at: words.count - 1)

        
        //print ("word count = \(words.count)")
        
        //print(words[0]);
        //print(words[words.count-1])
    }
    
    // inputs: a word that is in the guessedWords list, a row of customButtons which is the next empty row
    // enters one letter in each box in the correct one base on index
    func populateGuessDisplay(word: String, row: [CustomButton] ) {
        var i = 0
        while(i < word.count) {
            let x = word[word.index(word.startIndex, offsetBy: i)]
            row[i].setTitle(String(x), for: .normal)
            row[i].value = x
            // change the text color to black
            row[i].setTitleColor(UIColor.black, for: .normal)
            i = i + 1
        }
    }
    
    // goes through the guessed words list and calls populateGuessDisplay func with the cooresponding
    // word and row of buttons
    func updateGuessDisplay() {
        var i = 0
        while (i < guessedWords.count) {
            populateGuessDisplay(word: guessedWords[i], row: guesses[i])
            i = i + 1
        }
        guessView.setNeedsDisplay()
    }
    
    func countLetters(wordsToExamine: [String]) {
        for word in wordsToExamine{
            for i in 0..<word.count{
                let x = word[word.index(word.startIndex, offsetBy: i)]
                lettersCount[i][x]! += 1
            }
        }
    }
    
    func readGuesses() {
        var i = 0
        while i < guessedWords.count {
            var j = 0
            while j < guesses[i].count {
                let x = guesses[i][j]
                // not pressent
                if x.status == 1 {
                    // make sure the letter is not in the list
                    if !incorrectLetters.contains(x.value) {
                        incorrectLetters.append(x.value)
                    }
                }
                // correct
                if x.status == 2 {
                    // make sure entry is not in the list
                    if !correctLetters.values.contains(x.value) {
                        correctLetters[j] = x.value
                    }
                }
                // present
                if x.status == 3 {
                    if !presentLetters.values.contains(x.value) {
                        presentLetters[j] = x.value
                    }
                }
                j += 1
            }
            i += 1
        }
    }
    
    // function reads words from words into working words, only if they do not contain letters from
    // the incorrect list, do contain letters from the present list, and have the correct letter
    // in the correct spot from the correct list
    func getGuess() -> String {
        workingWords = [:]
        // do the reading and examining
        for word in words {
            let u = word.uppercased()
            workingWords[u] = 0.0
        }
        
        readGuesses()
        //print("incorrect : ")
        for x in incorrectLetters {
            print(x)
        }
        
        for word in workingWords.keys {
            // easier to check the present part of present list here
            // removing the specific one we know it isn't in comes later
            for x in presentLetters.values {
                if !word.contains(x) {
                    workingWords.removeValue(forKey: word)
                    continue
                }
            }
            
            var i = 0
            outerLoop: while i < word.count {
                // if any letter in the incorrect list is found, remove from working words
                incorrectLoop: for x in incorrectLetters {
                    //print("in incorrect, checking " + String(x))
                    if x == word[word.index(word.startIndex, offsetBy: i)] {
                        // the letters are fine if they are in the right place
                        // problem comes from the possibility of duplicates
                            if correctLetters[i] == x {
                                continue incorrectLoop
                            }
                        workingWords.removeValue(forKey: word)
                        //if(word == "DELVE") {
                        //    print("removing " + word + " in incorrect while checking " + String(x))
                       // }
                        break outerLoop
                    }
                }
                // if right index of the correct list and letter does not match, remove from working words
                if correctLetters[i] != nil && correctLetters[i] != word[word.index(word.startIndex, offsetBy: i)] {
                    workingWords.removeValue(forKey: word)
                    //if(word == "DELVE") {
                     //   print("removing " + word + " in correct")
                    //}
                    break outerLoop
                }
                
                // if same index as the present list, remove if match
                if presentLetters[i] != nil && presentLetters[i] == word[word.index(word.startIndex, offsetBy: i)] {
                    workingWords.removeValue(forKey: word)
                    //if(word == "DELVE") {
                    //    print("removing " + word + " in correct")
                    //}
                    break outerLoop
                }
                i += 1
            }
        }
        
        // empty letters count and letters frequency
        for i in 0...4{
            let startingValue = Int(("a" as UnicodeScalar).value) // 65
            for j in 0 ..< 26 {
                lettersCount[i][Character(UnicodeScalar(j + startingValue)!)] = 0
                lettersFrequency[i][Character(UnicodeScalar(j + startingValue)!)] = 0.0
            }
        }
        
        // count letters and calculate frequency
        countLetters(wordsToExamine: Array(workingWords.keys))
        for i in 0..<5{
            for x in lettersCount[i].keys {
                lettersFrequency[i][x] = Double(lettersCount[i][x]!) / Double(words.count)
            }
        }
        
        // calculate and save word score
        for word in workingWords.keys{
            var score = 0.0
            for i in 0..<word.count{
                score += lettersFrequency[i][word[word.index(word.startIndex, offsetBy: i)]]!
            }
            workingWords[word] = score
        }
        
        //sort the working words
        let sortedWorkingWords = workingWords.sorted {
            return $0.value > $1.value
        }
        //print(sortedWorkingWords)
        
        
        if sortedWorkingWords.isEmpty {
            return("ERROR: No words left")
        } else {
            return (sortedWorkingWords[0].key.uppercased())
        }
    }
    
    
}

