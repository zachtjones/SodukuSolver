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
			ForEach(1...3, id: \.self) {i in
				HStack(spacing: 0) {
					ForEach(1...3, id: \.self) {j in
						InnerPuzzleView(bgColor: (i+j)%2==0 ? darkBackgroundColor : backgroundColor)
					}
				}
			}
		}
		.aspectRatio(1.0, contentMode: ContentMode.fit)
		.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
    }
}

struct InnerPuzzleView: View {
	var bgColor: Color
	var body: some View {
		VStack(spacing: 0) {
			ForEach(1...3, id: \.self) {_ in
				HStack(spacing: 0) {
					ForEach(1...3, id: \.self) {_ in
						CellView(bgColor: self.bgColor)
					}
				}
			}
		}
		.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1.5)
		.background(bgColor)
	}
}

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
