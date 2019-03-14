//
//  RobotImpl.swift
//  SwiftChallenge
//
//  Created by Kyler Jensen on 4/10/18.
//  Copyright © 2018 InMoment, Inc. All rights reserved.
//

import Foundation

class RobotImpl: Robot {
    
    private let uiDelegate: RobotUserInterfaceDelegate
    
    private var pagesExamined: Int = 0
    private var termsExamined: Int = 0
    
    private lazy var loadedDictionary: [String:String] = {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "Dictionary", ofType: "plist") else { return [:] }
        guard let dict: Dictionary<String, String> = NSDictionary(contentsOfFile: path) as? [String:String] else { return [:] }
        return dict
    }()
    
    private lazy var dictionary: [[(term: String, definition: String)]] = {
        uiDelegate.updateBusyText("Loading the dictionary into the Robot. This should only take a few seconds.")
        return self.loadedDictionary
            .mapValues { $0.trimmingCharacters(in: .whitespaces) }
            .map { (term: $0, definition: $1) }
            .sorted { $0.term < $1.term }
            .chunked(size: 100)
    }()
    
    init(uiDelegate: RobotUserInterfaceDelegate) {
        self.uiDelegate = uiDelegate
    }
    
    func moveToNextPage() {
        currentPageIndex += 1
        pagesExamined += 1
    }
    
    func moveToPreviousPage() {
        currentPageIndex -= 1
        pagesExamined += 1
    }
    
    func moveToNextTerm() {
        currentTermIndex += 1
        termsExamined += 1
    }
    
    func moveToPreviousTerm() {
        currentTermIndex -= 1
        termsExamined += 1
    }
    
    func jumpToFirstPage() {
        currentPageIndex = 0
        pagesExamined += 1
    }
    
    func jumpToLastPage() {
        currentPageIndex = dictionary.endIndex - 1
        pagesExamined += 1
    }
    
    func jumpToFirstTerm() {
        currentTermIndex = 0
        pagesExamined += 1
    }
    
    func jumpToLastTerm() {
        currentTermIndex = (dictionary[safe: currentPageIndex]?.endIndex ?? 1) - 1
        termsExamined += 1
    }
    
    func resetCounters() {
        pagesExamined = 0
        termsExamined = 0
        uiDelegate.updateUI(currentPageIndex, currentTermIndex, pagesExamined, termsExamined, currentTerm)
    }
    
    var hasMorePages: Bool {
        return dictionary.indices.contains(currentPageIndex + 1)
    }
    
    var hasPreviousPages: Bool {
        return dictionary.indices.contains(currentPageIndex - 1)
    }
    
    var hasMoreTerms: Bool {
        return dictionary[safe: currentPageIndex]?.indices.contains(currentTermIndex + 1) ?? false
    }
    
    var hasPreviousTerms: Bool {
        return dictionary[safe: currentPageIndex]?.indices.contains(currentTermIndex - 1) ?? false
    }
    
    var currentPageIndex: Int = -1 {
        willSet(newValue) {
            uiDelegate.updateBusyText("Moving to term \(currentTermIndex) on page \(newValue)")
            usleep(100 * 1000)
        }
        didSet {
            uiDelegate.updateUI(currentPageIndex, currentTermIndex, pagesExamined, termsExamined, currentTerm)
        }
    }
    
    var currentTermIndex: Int = -1 {
        willSet(newValue) {
            uiDelegate.updateBusyText("Moving to term \(newValue) on page \(currentPageIndex)")
            usleep(10 * 1000)
        }
        didSet {
            uiDelegate.updateUI(currentPageIndex, currentTermIndex, pagesExamined, termsExamined, currentTerm)
        }
    }
    
    var currentTerm: String? {
        return dictionary[safe: currentPageIndex]?[safe: currentTermIndex]?.term
    }
    
    var currentTermDefinition: String? {
        return dictionary[safe: currentPageIndex]?[safe: currentTermIndex]?.definition
    }
    
    func jumpToSpecificPage(position: Int) {
        currentPageIndex = position
        pagesExamined += 1
        uiDelegate.updateUI(currentPageIndex, currentTermIndex, pagesExamined, termsExamined, currentTerm)
    }
    
    func jumpToSpecificTerm(position: Int) {
        currentTermIndex = position
        termsExamined += 1
        uiDelegate.updateUI(currentPageIndex, currentTermIndex, pagesExamined, termsExamined, currentTerm)
    }
    
    func getPageSize(position: Int) -> Int {
        return dictionary[position].count
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

private extension Array {
    func chunked(size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, self.count)])
        }
    }
}
