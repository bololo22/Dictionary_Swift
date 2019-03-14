//
//  SearchImpl.swift
//  SwiftChallenge
//
//  Created by Manolo Fernandez on 4/11/18.
//  Copyright © 2018 InMoment, Inc. All rights reserved.
//

import Foundation

class SearchImpl : Search {
    
    private let uiDelegate: SearchUserInterfaceDelegate
    private let robot : Robot
    
    init (uiDelegate : SearchUserInterfaceDelegate, robot : Robot){
        self.uiDelegate = uiDelegate
        self.robot = robot
    }
    
    func findWordWithRobot(wordToFind: String) {
        robot.jumpToFirstPage()
        robot.jumpToFirstTerm()
        
        while (robot.hasMorePages || robot.hasMoreTerms) {
            if (wordToFind >= robot.currentTerm!.lowercased()) {
                robot.jumpToLastTerm()
                if (wordToFind < robot.currentTerm!.lowercased()) {
                    robot.jumpToFirstTerm()
                    findDefinitionInPage(wordToFind: wordToFind)
                }
                if (wordToFind == robot.currentTerm!.lowercased()) {
                    uiDelegate.showDefinition(robot.currentTermDefinition)
                    return
                } else {
                    robot.moveToNextPage()
                    robot.jumpToFirstTerm()
                }
            } else {
                uiDelegate.showWordNotFound()
                return
            }
        }
    }

    private func findDefinitionInPage(wordToFind: String) {
        while (robot.hasMoreTerms) {
            if (wordToFind > robot.currentTerm!.lowercased()) {
                robot.moveToNextTerm()
            } else if (wordToFind < robot.currentTerm!.lowercased()) {
                uiDelegate.showWordNotFound()
                return
            } else {
                uiDelegate.showDefinition(robot.currentTermDefinition)
                return
            }
        }
    }
}
