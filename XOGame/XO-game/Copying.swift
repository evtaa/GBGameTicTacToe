//
//  Copying.swift
//  XO-game
//
//  Created by Alexandr Evtodiy on 27.12.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

protocol Copying {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}
