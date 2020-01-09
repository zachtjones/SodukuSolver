//
//  Parser.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 1/8/17.
//  Copyright © 2017 Zachary Jones. All rights reserved.
//

import UIKit

public class Parser {
	
	private var width, height: Int;
	private var data: UnsafePointer<UInt8>;
	private var values: [[Int]];
	
	init(image: UIImage) {
		let pixelData = image.cgImage!.dataProvider!.data;
		
		self.data = CFDataGetBytePtr(pixelData);
		self.width = Int(image.size.width);
		self.height = Int(image.size.height);
		self.values = Array(repeating: Array(repeating: 0, count: 9), count: 9);
		
		var totalBright: UInt64 = 0;
		for r in 0..<height {
			for c in 0..<width {
				let color = getColor(x: c, y: r);
				//the brightness of this pixel from 0...255 is the sum of all 3 divided by 3
				let temp: UInt64 = UInt64(color.r) + UInt64(color.g) + UInt64(color.b);
				totalBright += temp / 3;
			}
		}
		let averageBright = totalBright / UInt64(width) / UInt64(height);
		
		//this holds true at row, column for each pixel that is darker than the background
		var foregrounds: [[Bool]] = [];
		for r in 0..<height {
			var rowData: [Bool] = [];
			for c in 0..<width {
				let color = getColor(x: c, y: r);
				let bright = Int(color.r) + Int(color.g) + Int(color.b) / 3;
				if bright < Int(averageBright) {
					//foreground
					rowData.append(true);
				} else {
					rowData.append(false);
				}
			}
			foregrounds.append(rowData);
		}
		//foregrounds is now loaded with each pixel that is the numbers, 
		//and false for each background pixle at row, column
		
		//go through and trim out the foreground border, then take each cell using 1/9 of the image
		//trimming out the border will also make the image better centered.
		//the numbers (foreground pixels) should be surrounded with background pixels
		foregrounds = trimForeground(info: foregrounds);
		
		//grab each little part of the array, and test each of those
		for r in 0...8 {
			for c in 0...8 {
				parseCell(row: r, col: c, largeData: foregrounds);
			}
		}
	}
	
	///Parses a cell into the number.
	///The row and column must be in 0...8, and
	///Large data is the whole 2-d bool array for the entire grid, once trimmed.
	private func parseCell(row: Int, col: Int, largeData: [[Bool]]){
		var cellData: [[Bool]] = [];
		let rowStart = row * largeData.count / 9;
		let rowEnd = rowStart + largeData.count / 9;
		let colStart = col * largeData[0].count / 9;
		let colEnd = colStart + largeData[0].count / 9;
		
		for r in rowStart..<rowEnd {
			var rowData: [Bool] = [];
			for c in colStart..<colEnd {
				rowData.append(largeData[r][c]);
			}
			cellData.append(rowData);
		}
		
		//if a very small (<7% of the image) is foreground (after removing the outside border)
		//  then the image is empty
		if percentFilled(info: trimForeground(info: cellData)) <= 7 {
			self.values[row][col] = 0;
			return;
		}
		
		//remove 1/12 of the border of the cells
		let widthToRemove = (cellData.first?.count ?? 0) / 12;
		let heightToRemove = cellData.count / 12;
		
		cellData.removeLast(heightToRemove);
		cellData.removeFirst(heightToRemove);
		
		for i in 0..<cellData.count {
			cellData[i].removeLast(widthToRemove);
			cellData[i].removeFirst(widthToRemove);
		}
		
		Parser.printOut(info: cellData);
		self.values[row][col] = Comparer.compare(data: cellData);
	}
	
	///Returns an int in the range 0...100
	private func percentFilled(info: [[Bool]]) -> Int {
		let total = info.count * (info.first?.count ?? 0);
		//empty set, return 0
		if(total == 0){ return 0; }
		var count = 0;
		for r in 0..<info.count {
			for c in 0..<info[0].count {
				if(info[r][c]){
					count += 1;
				}
			}
		}
		return count * 100 / total;
	}
	
	///prints the 2-d array to output. A true value is printed as #, and false is printed as a space.
	class func printOut(info: [[Bool]]){
		var output = "";
		for r in 0..<info.count {
			for c in 0..<info[0].count {
				output += info[r][c] ? "#" : " ";
			}
			output += "\n";
		}
		print(output);
	}
	
	///gets the index in the image data for the start of the 4 byte (r, g, b, a) image data
	private func getIndex(x: Int, y: Int) -> Int {
		return ((self.width * y) + x) * 4;
	}
	
	///Gets the color as a tuple of red, green, blue, and alpha values, 
	//each in the range of 0...255, where 255 is fully bright / opaque
	private func getColor(x: Int, y: Int) -> (r: UInt8, g: UInt8, b: UInt8, a: UInt8){
		let index = getIndex(x: x, y: y);
		return (r: data[index], g: data[index + 1], b: data[index + 2], a: data[index + 3]);
	}
	
	///Gets the values at the row and column specified.
	///Both row and column must be in range 0...8
	public func getValue(row: Int, col: Int) -> Int {
		return self.values[row][col];
	}
	
	///Trims out the foreground border from the info passed in, and returns the new array.
	///True values are foreground pixels, and false values are background ones.
	private func trimForeground(info: [[Bool]]) -> [[Bool]]{
		var returnVal = info;
		//top
		while(true){
			var allForeground = true;
			if returnVal.count == 0 { return []; } //empty array, don't remove more
			for i in 0..<returnVal[0].count {
				if returnVal[0][i] == false { //background pixel
					allForeground = false;
				}
			}
			if(!allForeground){ break; }
			returnVal.removeFirst();
		}
		//bottom
		while(true){
			var allForeground = true;
			if returnVal.count == 0 { return []; } //empty array, don't remove more
			for i in 0..<returnVal[returnVal.count - 1].count {
				if returnVal[returnVal.count - 1][i] == false { //background pixel
					allForeground = false;
				}
			}
			if(!allForeground){ break; }
			returnVal.removeLast();
		}
		//left side
		while(true){
			var allForeground = true;
			for i in 0..<returnVal.count {
				if returnVal[i][0] == false {
					allForeground = false;
				}
			}
			if(!allForeground){ break; }
			//trim the first element from each subarray
			for i in 0..<returnVal.count {
				returnVal[i].removeFirst();
			}
		}
		//right side
		while(true){
			var allForeground = true;
			for i in 0..<returnVal.count {
				if returnVal[i][returnVal[i].count - 1] == false {
					allForeground = false;
				}
			}
			if(!allForeground){ break; }
			//trim the last element from each subarray
			for i in 0..<returnVal.count {
				returnVal[i].removeLast();
			}
		}
		return returnVal;
	}
	
}
