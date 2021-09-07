//
//  ContentView.swift
//  Stopwatch
//
//  Created by Paul Wilkinson on 4/9/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var stopwatches = Stopwatches()
    var body: some View {
        VStack {
            HStack {
                Text("Timers").font(.largeTitle)
                Spacer()
                Button(action: { self.stopwatches.add()}) {
                    Image(systemName: "plus.circle").resizable().frame(width: 30, height: 30, alignment: .center)
                }
            }.padding()
            
            List {
                ForEach(self.stopwatches.timers) { stopwatch in
                    HStack {
                        Spacer()
                        StopwatchView(stopwatch:  stopwatch).buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }.onDelete(perform: { indexSet in
                    self.stopwatches.delete(indexSet: indexSet)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
