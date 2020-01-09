//
//  Comparer.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 4/5/17.
//  Copyright © 2017 Zachary Jones. All rights reserved.
//

import Foundation

class Comparer {
	
	///Returns the number that most nearly is the number.
	class func compare(data: [[Bool]]) -> Int {
		var numbers = [Int:Int]();
		numbers[1] = compare(data: data, against: Numbers.one);
		numbers[2] = compare(data: data, against: Numbers.two);
		numbers[3] = compare(data: data, against: Numbers.three);
		numbers[4] = compare(data: data, against: Numbers.four);
		numbers[5] = compare(data: data, against: Numbers.five);
		numbers[6] = compare(data: data, against: Numbers.six);
		numbers[7] = compare(data: data, against: Numbers.seven);
		numbers[8] = compare(data: data, against: Numbers.eight);
		numbers[9] = compare(data: data, against: Numbers.nine);
		
		print(numbers);
		//find the max of the comparisons.
		var maxNum = 1, maxAmount = 1;
		
		for(k, v) in numbers {
			if(v > maxAmount) {
				maxNum = k;
				maxAmount = v;
			}
		}
		return maxNum;
	}
	
	///Returns an int in the range 0...100 that is the similarity %
	private class func compare(data: [[Bool]], against: [[Bool]]) -> Int {
		//trim them
		let dataT = trimBackground(info: data);
		let againstT = trimBackground(info: against);
		//make data have the larger size
		if(dataT.count > againstT.count){
			return compare(data: againstT, against: dataT);
		}
		
		
		//total amount of comparisons.
		var total = 0;
		//data is larger, so calculate the indexes
		for r in 0..<againstT.count {
			for c in 0..<againstT[0].count {
				let dataRow = r * dataT.count / againstT.count;
				let dataCol = c * dataT[0].count / againstT[0].count;
				if againstT[r][c] == dataT[dataRow][dataCol] {
					total += 1;
				}
			}
		}
		
		return total * 100 / (againstT.count * againstT[0].count);
	}
	
	///Trims out the foreground border from the info passed in, and returns the new array.
	///True values are foreground pixels, and false values are background ones.
	private class func trimBackground(info: [[Bool]]) -> [[Bool]]{
		var returnVal = info;
		//top
		while(true){
			var allBackground = true;
			if returnVal.count == 0 { return []; } //empty array, don't remove more
			for i in 0..<returnVal[0].count {
				if returnVal[0][i] == true { //foreground pixel
					allBackground = false;
				}
			}
			if(!allBackground){ break; }
			returnVal.removeFirst();
		}
		//bottom
		while(true){
			var allBackground = true;
			if returnVal.count == 0 { return []; } //empty array, don't remove more
			for i in 0..<returnVal[returnVal.count - 1].count {
				if returnVal[returnVal.count - 1][i] == true { //foreground pixel
					allBackground = false;
				}
			}
			if(!allBackground){ break; }
			returnVal.removeLast();
		}
		//left side
		while(true){
			var allBackground = true;
			for i in 0..<returnVal.count {
				if returnVal[i][0] == true {
					allBackground = false;
				}
			}
			if(!allBackground){ break; }
			//trim the first element from each subarray
			for i in 0..<returnVal.count {
				returnVal[i].removeFirst();
			}
		}
		//right side
		while(true){
			var allBackground = true;
			for i in 0..<returnVal.count {
				if returnVal[i][returnVal[i].count - 1] == true {
					allBackground = false;
				}
			}
			if(!allBackground){ break; }
			//trim the last element from each subarray
			for i in 0..<returnVal.count {
				returnVal[i].removeLast();
			}
		}
		return returnVal;
	}
	
}
