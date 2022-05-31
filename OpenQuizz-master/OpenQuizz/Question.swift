//
//  Question.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 30/06/2017.
//  Copyright © 2017 OpenClassrooms. All rights reserved.
//

import Foundation

struct Location {
    var x: Int
    var y: Int
    var width: Int
    var height: Int
}

struct Question {
    var title = ""
    var isCorrect = false
    var location: Location?
    var message: String?
}
