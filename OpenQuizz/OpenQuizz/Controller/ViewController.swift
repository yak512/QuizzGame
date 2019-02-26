//
//  ViewController.swift
//  OpenQuizz
//
//  Created by BOUHADEB Yacoub on 17/12/2018.
//  Copyright © 2018 BOUHADEB Yacoub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    
    
    @IBOutlet weak var NewGameButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var questionView: QuestionView!
    
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionLoaded), name: name, object: nil)
        
        startNewGame()
        
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionVeiw(_:)))
        questionView.addGestureRecognizer(panGestureRecogniser)
    }
    
    @objc func questionLoaded() {
        activityIndicator.isHidden = true
        NewGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
    }

   @IBAction func didTapNewGameButton() {
        startNewGame()
    }

   private func startNewGame() {
    activityIndicator.isHidden = false
    NewGameButton.isHidden = true
    questionView.title = "Loading"
    questionView.style = .standard
    scoreLabel.text = "0 / 10"
    
    game.refresh()
    }
    private func transformQuestionVeiw(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
    let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
    let screenWidt = UIScreen.main.bounds.width
    
    let translationPercent = translation.x/(screenWidt / 2)
    let rotationAngle = (CGFloat.pi / 6) * translationPercent
        
    let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
    let transform = translationTransform.concatenating(rotationTransform)
    questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break;
        }
        
        scoreLabel.text = "\(game.score) / 10"
        
        
        
        let screenWidt = UIScreen.main.bounds.width
        
        let translationTransoform: CGAffineTransform
        if questionView.style == .correct {
            translationTransoform = CGAffineTransform(translationX: screenWidt, y: 0)
        } else {
            translationTransoform = CGAffineTransform(translationX: -screenWidt, y: 0)
        }

        
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransoform
        }) { (success) in
        if success {
            self.showQuestionView()
            }
        }
    }
    
    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard
        questionView.title = game.currentQuestion.title
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "GAME OVER !"
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {self.questionView.transform = .identity}, completion: nil)
        
    }
    @objc func dragQuestionVeiw(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionVeiw(gesture: sender)
            case .cancelled,.ended:
                answerQuestion()
            default:
                break;
            }
        }
    }
    
}

