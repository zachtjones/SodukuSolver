//
//  PuzzleConfig.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 12/31/16.
//  Copyright © 2016 Zachary Jones. All rights reserved.
//

import Foundation

public class PuzzleConfig : Configuration {
	
	private var grid: [[UInt8]];
	private var cursorCol: Int, cursorRow: Int;
	
	/**
	* Constructor from a Puzzle object
	*/
	public init(p: Puzzle){
		self.grid = Array(repeating: Array(repeating: 0, count: 9), count: 9)
		// TODO grab the values of the puzzle's grid to fill in all values here
		self.cursorRow = 0;
		self.cursorCol = -1;
		//create a separate grid, don't want a reference
		self.grid = PuzzleConfig(other: self).grid;
	}
	
	/**
	* Copy constructor. This creates a 'deep' copy.
	* @param other The other PuzzleConfig to create a copy of.
	*/
	public init(other: PuzzleConfig){
		self.cursorRow = other.cursorRow;
		self.cursorCol = other.cursorCol;
		self.grid = Array(repeating: Array(repeating: 0, count: 9), count: 9);
		//copy grid
		for i in 0..<9 {
			for j in 0..<9 {
				self.grid[i][j] = other.grid[i][j];
			}
		}
	}
	
	///Gets the configuration's successors in the backtracking algorithm
	public func getSuccessors() -> [Configuration] {
		var c : [PuzzleConfig] = [];
		//advance the cursor
		self.cursorCol += 1;
		if(self.cursorCol == 9){
			self.cursorCol = 0;
			self.cursorRow += 1;
		}
		if(self.grid[cursorRow][cursorCol] != 0){
			//already set, so move on to next one
			//the array of length 1
			return [PuzzleConfig(other: self)];
		} else {
			//add all 9
			for i: UInt8 in 1...9 {
				let temp = PuzzleConfig(other: self);
				temp.grid[cursorRow][cursorCol] = i;
				c.append(temp);
			}
			return c;
		}
	}
	
	///Gets if this configuration is the goal
	public func isGoal() -> Bool {
		if(cursorCol == 8 && cursorRow == 8){
			return isValid();
		}
		//not at the end yet
		return false;
	}
	
	///Gets if this configuration is valid
	public func isValid() -> Bool{
		//only need to check the last thing placed at the cursor
		//the item at the cursor will never be 0
		
		for i in 0 ..< 9{
			//go across
			if(i == self.cursorCol){ continue; }
			if(self.grid[cursorRow][i] == self.grid[cursorRow][cursorCol]){
				return false; //duplicate in row
			}
		}
		for i in 0 ..< 9{
			//go down
			if(i == self.cursorRow){ continue; }
			if(self.grid[i][cursorCol] == self.grid[cursorRow][cursorCol]){
				return false; //duplicate in column
			}
		}
		//check block
		let blockRow = self.cursorRow / 3 * 3; //rounds down to 0, 3, or 6
		let blockCol = self.cursorCol / 3 * 3; //rounds down to 0, 3, or 6
		for row in blockRow ..< blockRow + 3 {
			for col in blockCol ..< blockCol + 3{
				if(row == cursorRow && col == cursorCol){ continue; }
				if(self.grid[cursorRow][cursorCol] == grid[row][col]){
					return false; //dupblicate in block
				}
			}
		}

		return true;
	}
	
	/**Returns the grid of this puzzle configuration.*/
	public func getGrid() -> [[UInt8]]{
		return self.grid;
	}
	
}
