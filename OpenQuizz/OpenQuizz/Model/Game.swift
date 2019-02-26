//
//  Game.swift
//  OpenQuizz
//
//  Created by BOUHADEB Yacoub on 18/12/2018.
//  Copyright © 2018 BOUHADEB Yacoub. All rights reserved.
//

import Foundation

class Game {
    var score = 0
    var questions = [Question]()
    
    enum State {
        case ongoing, over
    }
    
    var state: State = .ongoing
    
    private var currentIndex = 0
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }
    
    func answerCurrentQuestion(with answer: Bool) {
        if (answer == questions[currentIndex].isCorrect) {
            score += 1
        }
        if questions.count == currentIndex + 1 {
            state = .over
        } else {
            currentIndex += 1
        }
    }
    
    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }
    
}
 
