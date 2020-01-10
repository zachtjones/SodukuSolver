//
//  Puzzle.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 12/31/16.
//  Copyright © 2016 Zachary Jones. All rights reserved.
//

import UIKit

class PuzzleCell {
	init(value: Int) {
		self.value = value
	}
	@Published var value: Int = 0
	// TODO add stuff for pencil marks
}

///This is the model for the program, the view is in ViewController
public class Puzzle {
	
	/** Represents the number in row, column */
	private var grid: [[PuzzleCell]];
		
	public init(){
		// 9x9 initially empty
		self.grid = Array(repeating: Array(repeating: PuzzleCell(value: 0), count: 9), count: 9);
		for i in 0..<9 {
			for j in 0..<9 {
				self.grid[i][j] = PuzzleCell(value: 0)
			}
		}
		
		// TODO remove the following lines once the image loading works.
		self[0,0] = 2
		self[0,1] = 4
		self.grid[0][2].value = 6
	}
	
	/**
	* Clears this puzzle, setting all values to 0.
	*/
	public func clear(){
		//set all values to 0
		for i in 0..<9 {
			for j in 0..<9 {
				self.grid[i][j].value = 0;
			}
		}
	}
	
	/*** Gets the cell at the sepecific major row, major column, inner row, inner column */
	func getCell(row: Int, col: Int, r: Int, c: Int) -> PuzzleCell {
		return self.grid[row * 3 + r][col * 3 + c]
	}
	
	/**
	Gets / sets the value at a specified row and column.
	0 is the value of empty.
	*/
	subscript(row: Int, col: Int) -> Int {
		get {
			return self.grid[row][col].value
		}
		set {
			self.grid[row][col].value = newValue
		}
	}
	
	// TODO methods below here might not be needed.
	
	/**
	* Solves this puzzle.
	* Returns true if the puzzle was solved, false if there is no solution.
	*/
	public func solve() -> Bool {
		//solve the entire board
		let p = PuzzleConfig(p: self);
		let solution = Backtracker.solve(c: p);
		if(solution == nil){
			return false;
		} else {
			let g = (solution as! PuzzleConfig).getGrid();
			for i in 0...8 {
				for j in 0...8 {
					self.grid[i][j].value = Int(g[i][j]);
				}
			}
			return true;
		}
	}
	
	///Fills in the pencil marks for all cells
	public func fillPencils() {
		//calculate all
		var pencils: [[[Bool]]] = Array(repeating: Array(repeating: Array(repeating:false, count: 9), count: 9), count: 9);
		for r in 0...8 {
			for c in 0...8 {
				//the pencil mark to set
				for mark in 1...9 {
					if self.grid[r][c].value == 0 {
						//if it is 0, add the pencil marks
						//otherwise leave as false
						pencils[r][c][mark - 1] = canPlace(num: mark, row: r, col: c);
					}
				}
			}
		}
		
		///set the pencil marks into the grid
//		for r in 0...8 {
//			for c in 0...8 {
//				for mark in 0...8 {
//					//self.grid[r][c].setPencil(set: pencils[r][c][mark], forNum: mark + 1);
//				}
//			}
//		}
	}
	
	///Returns true if you can place the number at the specified row and column.
	///Do not call with num = 0.
	private func canPlace(num: Int, row: Int, col: Int) -> Bool {
		//only need to check the last thing placed at the cursor
		for i in 0 ..< 9{
			//go across
			if(i == col){ continue; }
			if(self.grid[row][i].value == num){
				return false; //duplicate in row
			}
		}
		for i in 0 ..< 9{
			//go down
			if(i == row){ continue; }
			if(self.grid[i][col].value == num){
				return false; //duplicate in column
			}
		}
		//check block
		let blockRow = row / 3 * 3; //rounds down to 0, 3, or 6
		let blockCol = col / 3 * 3; //rounds down to 0, 3, or 6
		for r in blockRow ..< blockRow + 3 {
			for c in blockCol ..< blockCol + 3{
				if(r == row && c == col){ continue; }
				if(self.grid[r][c].value == num){
					return false; //dupblicate in block
				}
			}
		}
		
		return true;
	}
	
	///Parses the image into the puzzle, setting the grid to the contents
	public func loadImage(image: UIImage) {
		//parse the image using the parser class and update the values
		let parser = Parser(image: image);
		for r in 0...8 {
			for c in 0...8 {
				self.grid[r][c].value = parser.getValue(row: r, col: c);
			}
		}
	}
}
