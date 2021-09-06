//
//  StopwatchView.swift
//  Stopwatch
//
//  Created by Paul Wilkinson on 4/9/21.
//

import SwiftUI

struct StopwatchView: View {
    
    @ObservedObject var stopwatch: Stopwatch
    
    var body: some View {
            HStack {
                Spacer()
                Text(self.stopwatch.elapsedTimeStr).font(.system(.body, design: .monospaced))
                Spacer()
                Button(action: {
                    if self.stopwatch.isRunning {
                        self.stopwatch.stop()
                    } else {
                        self.stopwatch.start()
                    }
                }) {
                    Image(systemName: self.stopwatch.isRunning ? "pause":"play")
                }
                Button(action: {
                    self.stopwatch.reset()
                }) {
                    Image(systemName: "gobackward")
                }.disabled(self.stopwatch.isRunning)
                Spacer()
            }.padding().background(Capsule().fill(Color.orange))
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(stopwatch: Stopwatch())
    }
}
