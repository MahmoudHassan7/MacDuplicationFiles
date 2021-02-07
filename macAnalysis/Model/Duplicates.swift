//
//  Duplicates.swift
//  macAnalysis
//
//  Created by Mahmoud Hassan on 2/2/21.
//  Copyright © 2021 Mahmoud Hassan. All rights reserved.
//

import Foundation


class Duplicates:NSObject
{
    
  @objc  var name: String
  @objc  var url: URL
  @objc  var size: Float
  @objc  var type : String
@objc var match: Int
    
    init(name: String, url: URL , size: Float, type: String, match: Int)
    {
        self.name = name
        self.url = url
        self.size = size
        self.type = type
        self.match = match
    }
    
}
