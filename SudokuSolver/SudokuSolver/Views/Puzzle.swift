//
//  Puzzle.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 12/31/16.
//  Copyright © 2016 Zachary Jones. All rights reserved.
//

import UIKit

///This is the model for the program, the view is in ViewController
public class Puzzle {
	
	/** Represents the number in row, column */
	private var grid: [[Cell]];
	/** Holds the listener for changes to this observable */
	private var view: Listener;
	///The selected row and column, 0 - 8 each
	private var selectedR, selectedC : Int;
	///-1 if no selection, 0 is clear, 1-9 is that number selected
	private var selectedN: Int;
	///if this is true, then this will mark the board, if false, pencil marks
	private var mark: Bool;
	
	private var gridView: UIView;
	
	public init(view: Listener, gridView: UIView){
		self.gridView = gridView;
		self.grid = [];
		//set the cells
		let width = gridView.bounds.width / 9;
		let height = gridView.bounds.height / 9;
		for i in 0...8 {
			var tempArray: [Cell] = [];
			for j in 0...8 {
				let temp = Cell(location: CGPoint(x: CGFloat(j) * width, y: CGFloat(i) * height), size: CGPoint(x: width, y: height));
				//add to drawing
				gridView.addSubview(temp.getView());
				tempArray.append(temp);
			}
			grid.append(tempArray);
		}

		self.view = view;
		selectedR = 0;
		selectedC = 0;
		selectedN = -1;
		mark = true;
	}
	
	/**
	* Clears this puzzle.
	*/
	public func clear(){
		//set all values to 0
		for i in 0..<9 {
			for j in 0..<9 {
				self.grid[i][j].value = 0;
			}
		}
		changedState();
		updateCells();
	}
	
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
			changedState();
			return true;
		}
	}
	
	///Solves this puzzle.
	///Returns true if the puzzle was solved at the selected cell, false if there is no solution
	public func solveCell() -> Bool {
		//solve the selected cell
		let p = PuzzleConfig(p: self);
		let solution = Backtracker.solve(c: p);
		if(solution == nil){
			return false;
		} else {
			let temp = (solution as! PuzzleConfig).getGrid();
			self.grid[selectedR][selectedC].value = Int(temp[selectedR][selectedC]);
			changedState();
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
		for r in 0...8 {
			for c in 0...8 {
				for mark in 0...8 {
					self.grid[r][c].setPencil(set: pencils[r][c][mark], forNum: mark + 1);
				}
			}
		}
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
	
	///Places the mark/pencil at the selected cell
	public func updateAtSelected(){
		//no selection, return
		if self.selectedN == -1 { return; }
		//otherwise update the cells
		let c = self.grid[selectedR][selectedC];
		if self.isMark || self.selectedN == 0 { //clear, set the value to 0
			//set the value of the cell
			c.value = self.selectedN;
		} else {
			c.togglePencil(forNum: self.selectedN);
		}
		updateCells();
	}
	
	/**
	* Sets the value of the puzzle at the location.
	* This clears the pencils in that row, column, and block for that value
	* row An int that is the row of the puzzle to set.
	*  col An int that is the column of the puzzle to set.
	*  value The value to set at row, column.
	* A value of 0 means blank, 1-9 are the allowed values.
	*/
	public func setValue(row: Int, col: Int, value: Int){
		//set the value at row, column
		self.grid[row][col].value = value;
		//clear the pencils if not 0
		if value != 0{
			//get row and column
			for i in 0 ..< 9{
				//go across
				self.grid[row][i].setPencil(set: false, forNum: value);
				self.grid[i][col].setPencil(set: false, forNum: value);
			}
			//get block
			let blockRow = row / 3 * 3; //rounds down to 0, 3, or 6
			let blockCol = col / 3 * 3; //rounds down to 0, 3, or 6
			for r in blockRow ..< blockRow + 3 {
				for c in blockCol ..< blockCol + 3{
					self.grid[r][c].setPencil(set: false, forNum: value);
				}
			}
		}
		changedState();
		updateCells();
	}
	
	/**
	* Gets the value of the puzzle at the location.
	*  row An int that is the row of the puzzle to set.
	*  col An int that is the column of the puzzle to set.
	* Returns: a value of 0 means blank, 1-9 are digits.
	*/
	public func getValue(row: Int, col: Int) -> UInt8{
		return UInt8(self.grid[row][col].value);
	}
	
	///Call when the view should be updated to reflect the changes to this.
	private func changedState(){
		self.view.update();
	}
	
	///Gets a reference to the grid of this puzzle
	public func getGrid() -> [[UInt8]] {
		var temp = Array(repeating: Array(repeating: UInt8(0), count: 9), count: 9);
		for i in 0...8 {
			for j in 0...8 {
				temp[i][j] = UInt8(self.grid[i][j].value);
			}
		}
		return temp;
	}
	
	///Gets / sets the selected row, setting will update the view
	public var selectedRow : Int {
		get {
			return self.selectedR;
		}
		set {
			self.selectedR = newValue;
			self.updateCells();
			self.changedState();
		}
	}
	
	///Gets / sets the selected row, setting will update the view
	public var selectedCol : Int {
		get {
			return self.selectedC;
		}
		set {
			self.selectedC = newValue;
			self.updateCells();
			self.changedState();
		}
	}
	
	///updates the selection of the cells
	private func updateCells(){
		if self.selectedN == -1 { return; }
		for i in 0...8 {
			for j in 0...8 {
				//if the value matches the selected, highlight it
				if self.grid[i][j].value == self.selectedN && selectedN != 0 {
					self.grid[i][j].selected = true;
				} else {
					//not the selected value, or clear is selected
					self.grid[i][j].selected = false;
				}
			}
		}
	}
	
	///Gets the selected number, -1 is no selected, 0 is clear, 1-9 is that number selected.
	///Should only set to 0...9, as setting to the value already selected deselects.
	public var selectedNum: Int {
		get {
			return self.selectedN;
		}
		set {
			//if it is the selected, deselect
			if self.selectedN == newValue {
				self.selectedN = -1;
			} else {
				self.selectedN = newValue;
			}
			self.changedState();
			self.updateCells();
		}
	}
	
	///True if marking the board, false if pencil marks
	public var isMark: Bool {
		get {
			return self.mark;
		}
		set {
			self.mark = newValue;
			self.changedState();
		}
	}
	
}
