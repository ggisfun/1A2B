//
//  ViewController.swift
//  1A2B
//
//  Created by Adam Chen on 2024/8/16.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var guessLabels: [UILabel]!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var numberImageViews: [UIImageView]!
    @IBOutlet var recordLabels: [UILabel]!
    @IBOutlet var hintLabels: [UILabel]!
    @IBOutlet weak var remainChanceLabel: UILabel!
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    
    var numberArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var answerArray = [String]()
    var guessArray = [String]()
    var guessIndex = 0
    var chanceTimes = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cleanRecord()
        createAnswer()
        cleanGuessData()
        changeButtonState(state: true)
        remainChanceLabel.text = String(chanceTimes)
    }
    
    //點選數字
    @IBAction func numberButtonClicked(_ sender: UIButton) {
        if guessArray.count >= 4 {
            return
        }
        
        let index = sender.tag
        numberButtons[index].isEnabled = false
        guessArray.append(String(index))
        buttonImageChange(index: index)
        
        for (i, guessNumber) in guessArray.enumerated(){
            guessLabels[i].text = guessNumber
        }
    }
    
    //確認送出
    @IBAction func enter(_ sender: Any) {
        if guessArray.count != 4 {
            alertMessage(code:2)
            return
        }
        
        var indexA = 0
        var indexB = 0
        for i in 0...3{
            if guessArray[i] == answerArray[i] {
                indexA += 1
            }else if answerArray.contains(guessArray[i]){
                indexB += 1
            }
        }

        recordLabels[guessIndex].text = guessArray.joined()
        hintLabels[guessIndex].text = "\(indexA)A\(indexB)B"
        guessIndex += 1
        cleanGuessData()
        changeButtonState(state: true)
        remainChanceLabel.text = String(chanceTimes - guessIndex)
        
        if indexA == 4{
            alertMessage(code:0)
            endGame()
        }else if guessIndex == 10 {
            alertMessage(code:1)
            endGame()
        }
    }
    
    //回上一步
    @IBAction func backspace(_ sender: Any) {
        if guessArray.count <= 0 {
            return
        }
        
        let tagNum = Int(guessArray.last!)
        numberButtons[tagNum!].isEnabled = true
        buttonImageChange(index: tagNum!)
        guessArray.removeLast()
        guessLabels[guessArray.count].text = ""
    }
    
    //重置遊戲
    @IBAction func reset(_ sender: Any) {
        enterButton.isEnabled = true
        backspaceButton.isEnabled = true
        cleanRecord()
        cleanGuessData()
        createAnswer()
        changeButtonState(state: true)
        guessIndex = 0
        remainChanceLabel.text = String(chanceTimes)
    }
    
    //創建答案
    func createAnswer(){
        let randomArray = numberArray.shuffled()
        answerArray.removeAll()
        for i in 0...3{
            answerArray.append(randomArray[i])
        }
        print(answerArray.joined())
    }
    
    //切換按鈕圖案
    func buttonImageChange(index: Int){
        if numberButtons[index].isEnabled == true{
            numberImageViews[index].image = UIImage(named: "0\(index)")
        }else{
            numberImageViews[index].image = UIImage(named: "0\(index)B")
        }
    }
    
    //改變Button狀態
    func changeButtonState(state: Bool){
        for i in 0...9{
            numberButtons[i].isEnabled = state
            buttonImageChange(index: i)
        }
    }
    
    //結束遊戲
    func endGame(){
        enterButton.isEnabled = false
        backspaceButton.isEnabled = false
        changeButtonState(state: false)
    }
    
    //清除紀錄
    func cleanRecord(){
        for i in 0...9{
            recordLabels[i].text = ""
            hintLabels[i].text = ""
        }
    }
    
    //清除猜測數據
    func cleanGuessData(){
        guessArray.removeAll()
        guessLabels[0].text = ""
        guessLabels[1].text = ""
        guessLabels[2].text = ""
        guessLabels[3].text = ""
    }
    
    //彈窗內容
    func alertMessage(code: Int){
        var titleText = ""
        var messageText = ""
        switch code {
        case 0:
            titleText = "猜對囉！"
            messageText = "再玩一次吧"
        case 1:
            titleText = "遊戲結束!\n正確答案是\(answerArray.joined())"
            messageText = "再玩一次吧"
        case 2:
            titleText = "請選擇4個數字"
            messageText = ""
        default:
            return
        }
        let controller = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        controller.addAction(okAction)
        present(controller, animated: true)
    }
    
}

