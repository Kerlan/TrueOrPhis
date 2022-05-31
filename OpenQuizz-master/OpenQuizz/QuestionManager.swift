//
//  QuestionManager.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 15/06/2017.
//  Copyright © 2017 OpenClassrooms. All rights reserved.
//

import UIKit

class QuestionManager {
    private let url = URL(string: "https://opentdb.com/api.php?amount=10&type=boolean")!

    static let shared = QuestionManager()
    private init() {}


    func get(level: String, completionHandler: @escaping ([Question]) -> ()) {
        if let path = Bundle.main.path(forResource: level, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                completionHandler(parse(data: data))
            } catch {
                completionHandler([Question]())
            }
        }
    }

    private func parse(data: Data?) -> [Question] {
        guard let data = data,
            let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []),
            let parsedJson = serializedJson as? [String: Any],
            let results = parsedJson["results"] as? [[String: Any]] else {
                return [Question]()
        }
        return getQuestionsFrom(parsedDatas: results)
    }

    private func getQuestionsFrom(parsedDatas: [[String: Any]]) -> [Question]{
        var retrievedQuestions = [Question]()

        for parsedData in parsedDatas {
            retrievedQuestions.append(getQuestionFrom(parsedData: parsedData))
        }

        return retrievedQuestions
    }

    private func getQuestionFrom(parsedData: [String: Any]) -> Question {
        if let title = parsedData["title"] as? String,
            let answer = parsedData["correct_answer"] as? String {
            if let location = parsedData["location"] as? [String: Int] {
                return Question(title: String(htmlEncodedString: title)!, isCorrect: (answer == "True"), location: Location(x: location["x"] ?? 0, y: location["y"] ?? 0, width: location["width"] ?? 0, height: location["height"] ?? 0), message: parsedData["message"] as? String)
            } else {
                return Question(title: String(htmlEncodedString: title)!, isCorrect: (answer == "True"))
            }
        }
        return Question()
    }
}


extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }
    
}
