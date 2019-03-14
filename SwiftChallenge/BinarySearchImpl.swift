//
//  BinarySearchImpl.swift
//  SwiftChallenge
//
//  Created by Manolo Fernandez on 4/11/18.
//  Copyright © 2018 InMoment, Inc. All rights reserved.
//

import Foundation

class BinarySearchImpl : BinarySearch {
    
    private let uiDelegate: SearchUserInterfaceDelegate
    private let robot : Robot
    
    init (uiDelegate : SearchUserInterfaceDelegate, robot : Robot){
        self.uiDelegate = uiDelegate
        self.robot = robot
    }
    
    func findWordWithRobot(wordToFind: String) {
        robot.jumpToFirstPage()
        let left = robot.currentPageIndex
        robot.jumpToLastPage()
        let right = robot.currentPageIndex
        robot.jumpToFirstPage()
        
        findDefinitionBinarySearchInDictionary(left: left, right: right, word: wordToFind)
        
        robot.jumpToFirstTerm()
        let up = robot.currentTermIndex
        let down = robot.getPageSize(position: robot.currentPageIndex)
        return findDefinitionBinarySearchInPage(up: up, down: down, word: wordToFind)
    }
    
    private func findDefinitionBinarySearchInDictionary(left: Int, right: Int, word: String) {
        if (right >= left) {
            let mid = left + (right - left) / 2
            
            robot.jumpToSpecificPage(position: mid)
            robot.jumpToFirstTerm()
            
            if (word >= robot.currentTerm!.lowercased()) {
                robot.jumpToLastTerm()
                if (word <= robot.currentTerm!.lowercased()) {
                    return
                }
            }
            if (word < robot.currentTerm!.lowercased()) {
                findDefinitionBinarySearchInDictionary(left: left, right: mid - 1, word: word)
            }
            if (word > robot.currentTerm!.lowercased()) {
                findDefinitionBinarySearchInDictionary(left: mid + 1, right: right, word: word)
            }
        }else{
            uiDelegate.showWordNotFound()
        }
    }
    
    private func findDefinitionBinarySearchInPage(up: Int, down: Int, word: String) {
        if (down >= up && robot.hasMoreTerms) {
            let mid = up + (down - up) / 2
            
            robot.jumpToSpecificTerm(position: mid)
            
            if (word == robot.currentTerm!.lowercased()) {
                uiDelegate.showDefinition(robot.currentTermDefinition)
            }
            if (word < robot.currentTerm!.lowercased()) {
                return findDefinitionBinarySearchInPage(up: up, down: mid - 1, word: word)
            }
            if (word > robot.currentTerm!.lowercased()) {
                return findDefinitionBinarySearchInPage(up: mid + 1, down: down, word: word)
            }
        }else{
            uiDelegate.showWordNotFound()
        }
    }
}
