//
//  Listener.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 12/31/16.
//  Copyright © 2016 Zachary Jones. All rights reserved.
//

import Foundation

public protocol Listener {
	/**
	* Call when the listener should update the values
	*/
	func update() -> Void;
}
