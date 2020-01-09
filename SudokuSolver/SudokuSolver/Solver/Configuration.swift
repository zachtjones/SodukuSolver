//
//  Configuration.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 12/31/16.
//  Copyright © 2016 Zachary Jones. All rights reserved.
//

import Foundation

public protocol Configuration {
	/**
	Gets the successors for this configuration.
	Used in backtracking.
	Returns an arrray of configurations, valid or not.
	*/
	func getSuccessors() -> [Configuration];
	
	/**
	Gets if this configuration is the goal, that is
	a solution to the backtracking.
	Returns a boolean value that is if this is the goal.
	*/
	func isGoal() -> Bool;
	
	/**
	Gets if this configuration is valid, that is
	if this configuration does not break any rules.
	Returns a boolean value that is if this is a valid configuration.
	*/
	func isValid() -> Bool;
}
