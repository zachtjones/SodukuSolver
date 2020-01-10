//
//  CellView.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 1/10/20.
//  Copyright © 2020 ZachJones. All rights reserved.
//

import SwiftUI

private let cellSize: CGFloat = 25

struct CellView: View {
	var bgColor: Color
	var cellRef: PuzzleCell
    var body: some View {
		ZStack {
			Rectangle()
				.fill(bgColor)
				.border(Color.blue, width: 1)
			if (cellRef.value != 0) {
				Text("\(cellRef.value)")
			}
		}
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(puzzle: Puzzle())
    }
}
