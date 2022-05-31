//
//  Game.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 13/06/2017.
//  Copyright © 2017 OpenClassrooms. All rights reserved.
//

import Foundation


class Game {
    var score = 0
    var level = 1
    var state: State = .ongoing

    enum State {
        case ongoing, over, win
    }

    private var questions = [Question]()
    private var currentIndex = 0

    var currentQuestion: Question {
        return questions[currentIndex]
    }

    func refresh() {
        score = 0
        currentIndex = 0
        state = .over

        QuestionManager.shared.get(level: String(level)) { (questions) in
            self.questions = questions
            self.state = .ongoing
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }

    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        if score == questions.count {
            state = .win
            level += 1
            refresh()
        } else {
            state = .over
        }
    }
}
