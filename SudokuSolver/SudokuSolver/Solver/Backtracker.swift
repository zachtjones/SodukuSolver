//
//  Backtracker.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 12/31/16.
//  Copyright © 2016 Zachary Jones. All rights reserved.
//
import Foundation

public class Backtracker {
	
	/**
	* Uses backtracking to solve the configuration passed.
	* @param c The configuration to solve.
	* @return The configuration that is the solution, or null
	* if there is no solution
	*/
	public class func solve(c: Configuration) -> Configuration? {
		if(c.isGoal()){
			return c; //done, found the solution
		} else {
			// go through the successors
			for child in c.getSuccessors(){
				//only continue through valid successors
				if(child.isValid()){
					let result = solve(c: child);
					//if the result is not null, then return that configuration
					if(result != nil){ return result; }
				}
			}
		}
		//no solution found as any child of the Configuration c,
		//so return nil
		return nil;
	}
}
