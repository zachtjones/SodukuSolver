//
//  PuzzleView.swift
//  SudokuSolver
//
//  Created by Zachary Jones on 1/10/20.
//  Copyright © 2020 Zachary Jones. All rights reserved.
//

import SwiftUI

struct PuzzleView: View {
    var body: some View {
		VStack(spacing: 0) {
			ForEach(1...3, id: \.self) {_ in
				HStack(spacing: 0) {
					ForEach(1...3, id: \.self) {_ in
						InnerPuzzleView()
					}
				}
			}
		}
		.aspectRatio(1.0, contentMode: ContentMode.fit)
		.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
    }
}

struct InnerPuzzleView: View {
	var body: some View {
		VStack(spacing: 0) {
			ForEach(1...3, id: \.self) {_ in
				HStack(spacing: 0) {
					ForEach(1...3, id: \.self) {_ in
						CellView()
					}
				}
			}
		}
		.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1.5)
	}
}

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
