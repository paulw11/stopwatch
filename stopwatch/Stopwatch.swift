//
//  Stopwatch.swift
//  stopwatch
//
//  Created by Paul Wilkinson on 4/9/21.
//

import Combine
import Foundation

class Stopwatches: ObservableObject {
    @Published private(set) var timers = [Stopwatch]()
    
    init() {
        self.timers.append(Stopwatch())
    }
    
    func addTimer() {
        self.timers.append(Stopwatch())
    }
    
    func delete(indexSet: IndexSet) {
        self.timers.remove(atOffsets: indexSet)
    }
}

class Stopwatch: ObservableObject, Identifiable {
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    private var timer: Cancellable?

    @Published private (set) var isRunning = false { didSet {
        if self.isRunning {
            self.timer?.cancel()
            self.timer = Timer.publish(every: 0.01, on: .main, in: .default)
                .autoconnect()
                .sink { date in
                    self.setElapsedTimeStr(using: date)
                }
        } else {
            self.timer?.cancel()
            self.timer = nil
        }
        
    }}
    
    private (set) var id = UUID()
    
    @Published var elapsedTimeStr: String
    
    init() {
        self.elapsedTimeStr = "00:00:00.00"
    }
    
    func start() -> Void {
        guard !self.isRunning else {
            return
        }
        
        self.startTime = Date()
        self.isRunning = true
    }
    
    func stop() -> Void {
        guard self.isRunning, let startTime = self.startTime else {
            return
        }
        
        self.accumulatedTime -= startTime.timeIntervalSinceNow
        self.isRunning = false
        self.startTime = nil
        
    }
    
    func reset() -> Void {
        self.isRunning = false
        self.startTime = nil
        self.accumulatedTime = 0
        self.objectWillChange.send()
    }
    
    private func setElapsedTimeStr(using date: Date) -> Void {
        
        var elapsedTime = self.accumulatedTime
        
        if let startTime = self.startTime {
            elapsedTime -= startTime.timeIntervalSince(date)
        }
        
        let intTime = Int(elapsedTime)
        
        let tenths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = intTime % 60
        let minutes = (intTime / 60) % 60
        let hours = (intTime / 3600)
        self.elapsedTimeStr = String(format: "%0.2d:%0.2d:%0.2d.%0.2d",hours,minutes,seconds,tenths)
    }
}
