//
//  VerifyViewController.swift
//  OpenQuizz
//
//  Created by Kerlan PLUMASSEAU on 25/05/2022.
//  Copyright © 2022 OpenClassrooms. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var game: Game!
    var prevVC: ViewController!
    var isTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(named: game.currentQuestion.title)
    }
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        if isTapped {
            game.answerCurrentQuestion(with: true)
            dismiss(animated: true) {
                self.prevVC.showQuestionView()
            }
            return
        }
        isTapped = true
        let location = sender.location(in: image)
        print(location)
        guard let answer = game.currentQuestion.location else {
            game.answerCurrentQuestion(with: false)
            dismiss(animated: true) {
                self.prevVC.showQuestionView()
            }
            return
        }
        if (Int(location.x) >= answer.x) && (Int(location.x) <= (answer.x + answer.width)) && (Int(location.y) >= answer.y) && (Int(location.y) <= (answer.y + answer.height)) {
            game.answerCurrentQuestion(with: false)
            dismiss(animated: true) {
                self.prevVC.showQuestionView()
            }
        } else {
            skipButton.isHidden = false
            messageLabel.isHidden = false
            messageLabel.text = game.currentQuestion.message
            zoomRect(x: answer.x, y: answer.y, width: answer.width, height: answer.height)
        }
    }
    
    func zoomRect(x: Int, y: Int, width: Int, height: Int) {
        image.image = UIImage(cgImage: (image.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height)))!)
    }
    
    @IBAction func skip(_ sender: Any) {
        game.answerCurrentQuestion(with: true)
        dismiss(animated: true) {
            self.prevVC.showQuestionView()
        }
    }
}
