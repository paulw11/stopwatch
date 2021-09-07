//
//  StopwatchView.swift
//  Stopwatch
//
//  Created by Paul Wilkinson on 4/9/21.
//

import SwiftUI

struct StopwatchView: View {
    
    @ObservedObject var stopwatch: Stopwatch
    
    private static var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [ .hour, .minute, .second ] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale
        formatter.allowsFractionalUnits = true
        return formatter
    }()
    
    var body: some View {
        HStack {
            Spacer()
            Text(self.elapsedTimeStr(timeInterval: self.stopwatch.elapsedTime)).font(.system(.body, design: .monospaced))
            Spacer()
            Button(action: {
                self.stopwatch.isRunning.toggle()
            }) {
                self.playPauseImage
            }
            Button(action: {
                self.stopwatch.reset()
            }) {
                Image(systemName: "gobackward")
            }.disabled(self.stopwatch.isRunning)
            Spacer()
        }.padding().background(Capsule().fill(Color.orange))
    }
    
    private var playPauseImage: Image {
        return Image(systemName: self.stopwatch.isRunning ? "pause":"play")
    }
    
    private func elapsedTimeStr(timeInterval: TimeInterval) -> String {
        return StopwatchView.formatter.string(from: timeInterval) ?? ""
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(stopwatch: Stopwatch())
    }
}
