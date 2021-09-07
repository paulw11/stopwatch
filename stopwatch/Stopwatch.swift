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
    
    func add() {
        self.timers.append(Stopwatch())
    }
    
    func delete(indexSet: IndexSet) {
        self.timers.remove(atOffsets: indexSet)
    }
}

class Stopwatch: ObservableObject, Identifiable {
    private var startTime: Date?
    private var accumulatedTime:TimeInterval = 0
    private var timer: Cancellable?
    
    
    @Published var isRunning = false {
        didSet {
            if self.isRunning {
                self.start()
            } else {
                self.stop()
            }
        }
    }
    @Published private(set) var elapsedTime: TimeInterval = 0
    
    let id = UUID()
    
    private func start() -> Void {
        self.timer?.cancel()
        self.timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect().sink { _ in
            self.elapsedTime = self.getElapsedTime()
        }
        self.startTime = Date()
    }
    
    private func stop() -> Void {
        self.timer?.cancel()
        self.timer = nil
        self.accumulatedTime = self.getElapsedTime()
        self.startTime = nil
    }
    
    func reset() -> Void {
        self.accumulatedTime = 0
        self.elapsedTime = 0
        self.startTime = nil
        self.isRunning = false
    }
    
    private func getElapsedTime() -> TimeInterval {
        return -(self.startTime?.timeIntervalSinceNow ??     0)+self.accumulatedTime
    }
}
