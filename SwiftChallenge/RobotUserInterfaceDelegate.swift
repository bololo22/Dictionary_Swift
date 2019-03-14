//
//  RobotUserInterfaceDelegate.swift
//  SwiftChallenge
//
//  Created by Kyler Jensen on 4/10/18.
//  Copyright © 2018 InMoment, Inc. All rights reserved.
//

import Foundation

protocol RobotUserInterfaceDelegate {
    
    func updateUI(_ pageIndex: Int, _ termIndex: Int, _ pagesExamined: Int, _ termsExamined: Int, _ currentTerm: String?)
    
    func updateBusyText(_ busyText: String?)
    
}
