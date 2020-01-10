//
//  ContentView.swift
//  SodukuSolver
//
//  Created by Zachary Jones on 1/9/20.
//  Copyright © 2020 ZachJones. All rights reserved.
//

import SwiftUI

let borderWidth: CGFloat = 15.0
let backgroundColor = Color(red: 0.92, green: 0.92, blue: 0.92)

struct ContentView: View {
    var body: some View {
		VStack {
			HStack {
				Spacer()
					.frame(width: borderWidth)
				Text("Load: ")
				Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
					Image(systemName: "camera")
				}
				Button(action: {}) {
					Image(systemName: "photo")
				}
				Spacer()
				Button(action: {}) {
					Image(systemName: "clear")
				}
				Spacer()
				.frame(width: borderWidth)
			}
			Spacer()
				.frame(height: borderWidth*2)
			HStack {
				Spacer()
					.frame(width: borderWidth)
				PuzzleView()
				Spacer()
					.frame(width: borderWidth)
			}
			Spacer()
		}
		.background(backgroundColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
