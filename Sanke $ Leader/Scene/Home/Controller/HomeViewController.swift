//
//  HomeViewController.swift
//  Sanke $ Leader
//
//  Created by Arish Khan on 17/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var player1View: UIView!
    @IBOutlet weak var player2View: UIView!
    @IBOutlet weak var diceButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dot0View: UIView!
    @IBOutlet weak var dot1View: UIView!
    @IBOutlet weak var dot2View: UIView!
    @IBOutlet weak var dot3View: UIView!
    @IBOutlet weak var dot4View: UIView!
    @IBOutlet weak var dot5View: UIView!
    @IBOutlet weak var dot6View: UIView!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    
    private var player1Name: String = "Player 1"
    private var player2Name: String = "Player 2"
    private var player1Position: Int = 0
    private var player2Position: Int = 0
    private let player1Color: UIColor = .systemGreen
    private let player2Color: UIColor = .systemRed
    private static let screenWidth = UIScreen.main.bounds.size.width
    private lazy var cellWidth = (HomeViewController.screenWidth - 10) / 10
    private var currentPlayer: Int = 1
    private let totalPlayer: Int = 2
    private let jumpInfo: [Int:Int] = [4:25, 8:29, 13:46, 20:21, 27:5, 33:49, 40:3, 42:63, 43:18, 50:69, 54:31, 62:81, 66:45, 67:86, 70:71, 74:92, 76:58, 80:61, 89:53, 95:84, 99:41]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDice(number: 6)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alertWithTextField(title: "Enter Player1 Name?", placeholder: "Player Name") {[weak self] value in
            self?.player1Name = value.uppercased()
            DispatchQueue.main.async {
                self?.player1Label.text = self?.player1Name
                self?.alertWithTextField(title: "Enter Player2 Name?", placeholder: "Player Name") {[weak self] value2 in
                    self?.player2Name = value2.uppercased()
                    self?.player2Label.text = self?.player2Name
                }
            }
        }
        
    }
    
    @IBAction func diceButtonAction() {
        let randomInt = Int.random(in: 1..<7)
        setDice(number: randomInt)
        
        if getCurrentPlayerPosition() == 0 && randomInt != 1 {
            
        } else if getCurrentPlayerPosition() == 0 && randomInt == 1 {
            setCurrentPlayerPosition(number: randomInt)
        } else if getCurrentPlayerPosition() != 0 {
            let playerPosition = getCurrentPlayerPosition() + randomInt
            setCurrentPlayerPosition(number: playerPosition)
            if playerPosition == 100 {
                let vc = UIAlertController(title: "WINNER", message: winnerName() + " Congratulation", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    self?.player1Position = 0
                    self?.player2Position = 0
                    self?.tableView.reloadData()
                }
                vc.addAction(action)
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
        setCurrentPlayer()
        setPlayerBoderWidth(selectedView: (currentPlayer == 1) ? player1View : player2View)
        
        tableView.reloadData()
    }
    
}

private extension HomeViewController {
    
    func winnerName() -> String {
        if currentPlayer == 1 {
            return player1Name
        } else {
            return player2Name
        }
    }
    
    // show current player.
    func getCurrentPlayerPosition() -> Int {
        if currentPlayer == 1 {
            return player1Position
        }else {
            return player2Position
        }
        
    }
    
    func setCurrentPlayerPosition(number: Int) {
        guard number < 101 else {
            return
        }
        
        var number = number
        
        if jumpInfo.keys.contains(number), let value = jumpInfo[number] {
            number = value
        }
        
        if currentPlayer == 1 {
            player1Position = number
        } else {
            player2Position = number
        }
      
    }
    
    func setCurrentPlayer() {
        currentPlayer += 1
        if currentPlayer > totalPlayer {
            currentPlayer = 1
        }
    }
    
    func setPlayerBoderWidth(selectedView: UIView) {
        player1View.borderWidth = 0
        player2View.borderWidth = 0
        selectedView.borderWidth = 5
    }
    
    func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        self.present(alert, animated: true)
    }
    
    func updateRowColor(cell: HomeTableViewCell, playerPosition: Int, color: UIColor, currentRow: Int) {
        
        let playerRow = (playerPosition - 1) / 10
        
        let oppositeRow = 9 - playerRow
        if currentRow == oppositeRow {
            var tag = playerPosition - (playerRow * 10)
            if isOddRow(row: currentRow) == false {
                tag = 11 - tag
            }
            let selectionView = cell.stackView.viewWithTag(tag)
            selectionView?.backgroundColor = color
            selectionView?.borderWidth = 5
            selectionView?.cornerRadius = cellWidth / 2
            
            if player1Position == player2Position {
                selectionView?.borderWidth = 10
                selectionView?.borderColor = player1Color
                
                
            }
        }
    }
    
    func resetAll(cell: HomeTableViewCell) {
        for tag in 1..<11 {
            let selectionView = cell.stackView.viewWithTag(tag)
            selectionView?.backgroundColor = .clear
            selectionView?.borderWidth = 0
            selectionView?.cornerRadius = 0
            selectionView?.borderColor = .white
        }
    }
    
    func isOddRow(row: Int) -> Bool {
        let result = row.isMultiple(of: 2)
        debugPrint("current row \(row)")
        debugPrint(!result)
        return !result
    }
    
    func setDice(number: Int) {
        dot0View.isHidden = true
        dot1View.isHidden = true
        dot2View.isHidden = true
        dot3View.isHidden = true
        dot4View.isHidden = true
        dot5View.isHidden = true
        dot6View.isHidden = true
        
        if number == 1 {
            dot0View.isHidden = false
        } else if number == 2 {
            dot1View.isHidden = false
            dot6View.isHidden = false
        } else if number == 3 {
            dot1View.isHidden = false
            dot0View.isHidden = false
            dot6View.isHidden = false
        } else if number == 4 {
            dot1View.isHidden = false
            dot3View.isHidden = false
            dot4View.isHidden = false
            dot6View.isHidden = false
        } else if number == 5 {
            dot1View.isHidden = false
            dot3View.isHidden = false
            dot0View.isHidden = false
            dot4View.isHidden = false
            dot6View.isHidden = false
        } else if number == 6 {
            dot1View.isHidden = false
            dot2View.isHidden = false
            dot3View.isHidden = false
            dot4View.isHidden = false
            dot5View.isHidden = false
            dot6View.isHidden = false
        }
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCellIdentifier", for: indexPath) as? HomeTableViewCell else {                                  //provide cell
            return UITableViewCell()
        }
        resetAll(cell: cell)
        
        if player1Position != 0 {
            updateRowColor(cell: cell, playerPosition: player1Position, color: player1Color, currentRow: indexPath.row)
        }
        if player2Position != 0 {
            updateRowColor(cell: cell, playerPosition: player2Position, color: player2Color, currentRow: indexPath.row)
        }
        
        return cell
    }
    
}
