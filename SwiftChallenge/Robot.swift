//
//  Robot.swift
//  SwiftChallenge
//
//  Created by Kyler Jensen on 4/10/18.
//  Copyright © 2018 InMoment, Inc. All rights reserved.
//

import Foundation

/**
 A protocol for communicating with a dictionary-searching robot. This
 protocol gives no guarantees as to the location, speed, efficiency,
 or volatility of the physical or digital robot it represents.
 */
protocol Robot {
    
    /**
     Instructs the robot to turn to the next page of the dictionary.
     */
    func moveToNextPage()
    
    /**
     Instructs the robot to turn to the previous page of the dictionary.
     */
    func moveToPreviousPage()
    
    /**
     Instructs the robot to move its camera to the next term on the current
     page of the dictionary.
     */
    func moveToNextTerm()
    
    /**
     Instructs the robot to move its camera to the previous term on the
     current page of the dictionary.
     */
    func moveToPreviousTerm()
    
    /**
     Instructs the robot to turn to the first page of the dictionary
     (pageIndex == 0).
     */
    func jumpToFirstPage()
    
    /**
     Instructs the robot to turn to the last page of the dictionary
     (pageIndex == unknown).
     */
    func jumpToLastPage()
    
    /**
     Instructs the robot to move its camera to the first term on the
     current page of the dictionary (termIndex == 0).
     */
    func jumpToFirstTerm()
    
    /**
     Instructs the robot to move its camera to the first last on the
     current page of the dictionary (termIndex == unknown).
     */
    func jumpToLastTerm()
    
    /**
     Instructs the robot to reset any counters that it may be keeping,
     such as the number of pages or terms examined.
     */
    func resetCounters()
    
    /**
     True if there are more pages after the current page of the dictionary.
     */
    var hasMorePages: Bool { get }
    
    /**
     True if there are more pages before the current page of the dictionary.
     */
    var hasPreviousPages: Bool { get }
    
    /**
     True if there are more terms after the current term on the
     current page of the dictionary.
     */
    var hasMoreTerms: Bool { get }
    
    /**
     True if there are more terms after the current term on the
     current page of the dictionary.
     */
    var hasPreviousTerms: Bool { get }
    
    /**
     The index of the current page of the dictionary (0-indexed).
     */
    var currentPageIndex: Int { get }
    
    /**
     The index of the current term on the current page of the dictionary (0-indexed).
     */
    var currentTermIndex: Int { get }
    
    /**
     The text of the current term on the current page of the dictionary,
     or nil if the robot's camera is not over any term.
     */
    var currentTerm: String? { get }
    
    /**
     The text of the definition corresponding to the current term on
     the current page of the dictionary, or nil if the robot's camera
     is not over any term.
     */
    var currentTermDefinition: String? { get }
    
    /**
     * Instructs the robot to jump to specified Page index.
     * */
    func jumpToSpecificPage(position: Int)
    
    /**
     * Instructs the robot to jump to specified Term index.
     */
    func jumpToSpecificTerm(position: Int)
    
    /**
     * The number of terms per page
     * */
    func getPageSize(position: Int) -> Int
    
}
