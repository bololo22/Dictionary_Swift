//
//  SearchUserInterfaceDelegate.swift
//  SwiftChallenge
//
//  Created by Manolo Fernandez on 4/11/18.
//  Copyright © 2018 InMoment, Inc. All rights reserved.
//

import Foundation

protocol SearchUserInterfaceDelegate {
    
    func showDefinition(_ definition: String?)
    func showWordNotFound()
    
}
