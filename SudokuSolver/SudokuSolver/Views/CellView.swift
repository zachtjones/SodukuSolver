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
    var body: some View {
		Rectangle()
		.fill(Color.white)
		.border(Color.blue, width: 1)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
