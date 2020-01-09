//
//  Cell.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 1/1/17.
//  Copyright © 2017 Zachary Jones. All rights reserved.
//

import UIKit

public class Cell {
	private var view: UIView;
	///labels[0] is the big label, the others are the pencil mark labels
	private var labels: [UILabel];
	//each item is whether or not the pencil is marked for the value
	private var pencils: [Bool] = Array(repeating: false, count: 9);
	private var val: Int = 0;
	private var isSelected: Bool = false;
	
	///Initializer given the size as width, height
	init(location: CGPoint, size: CGPoint) {
		self.view = UIView();
		view.frame = CGRect(x: location.x, y: location.y, width: size.x - 2, height: size.y - 2);
		view.backgroundColor = UIColor(white: 1.0, alpha: 1.0);
		labels = [];
		//set the 10 labels
		let largeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: size.x, height: size.y));
		largeLabel.textAlignment = NSTextAlignment.center;
		labels.append(largeLabel);
		view.addSubview(largeLabel);
		
		for i in 0...2 {
			for j in 0...2{
				let width = size.x / 3;
				let height = size.y / 3;
				let newLabel = UILabel(frame: CGRect(x: width * CGFloat(j), y: height * CGFloat(i), width: width, height: height));
				newLabel.font = newLabel.font.withSize(8); //smaller font
				newLabel.textAlignment = NSTextAlignment.center;
				labels.append(newLabel);
				view.addSubview(newLabel);
			}
		}
		update();
	}
	
	///Gets the view for this cell.
	public func getView() -> UIView {
		return self.view;
	}
	
	///Gets / sets the value (the large number).
	///This will always clear the pencil marks for this cell
	public var value: Int {
		get{
			return self.val;
		}
		set {
			self.val = newValue;
			self.pencils = Array(repeating: false, count: 9);
			update();
		}
	}
	
	///Sets the number's pencil mark to the set
	///For num should be in 1...9
	public func setPencil(set: Bool, forNum: Int){
		self.pencils[forNum - 1] = set;
		update();
	}
	
	///Toggles if there is / is not a pencil for that number in range 1...9
	public func togglePencil(forNum: Int){
		self.pencils[forNum - 1] = !self.pencils[forNum - 1];
		update();
	}
	
	///draws updates the labels
	private func update() {
		//don't put the 0 in, leave blank
		labels[0].text = value.description == "0" ? "" : value.description;
		for i in 1...9 {
			//ternary operator, short for if condition ? truePart : falsePart
			labels[i].text = (pencils[i-1] ? i.description : "");
		}
	}
	
	public var selected: Bool {
		get {
			return self.isSelected;
		}
		set {
			self.isSelected = newValue;
			//update the view
			if isSelected {
				self.view.backgroundColor = UIColor.yellow;
			} else {
				self.view.backgroundColor = UIColor.white;
			}
		}
	}
}
