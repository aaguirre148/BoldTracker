//
//  ContentView.swift
//  BoldTracker
//
//  Created by Adrian Aguirre on 30/10/25.
//

import SwiftUI

struct DailyBoldTrackerView: View {
    
    @StateObject private var viewModel = BoldTrackerViewModel()
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("🔥 Daily Bold Tracker")
                .font(.largeTitle)
                .bold()
            
            //Text("Racha actual: \(viewModel.streakCount) días")
            VStack {
                Text("TU RACHA:")
                Text("\(viewModel.streakCount) días")
            }
            .font(.title2)
            .foregroundColor(.accentColor)
            .padding(20)
            
            Button(action: viewModel.markBoldAction) {
                Text("Hoy fui audaz 💥")
                    .padding()
                    .frame(maxWidth: .maximumMagnitude(5, 150))
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()
            
            Button(action: viewModel.resetButton) {
                Text("Reset")
                    .foregroundColor(.red)
            }
            .padding()
            
            List {
                ForEach(viewModel.boldHistory.sorted(by: >), id: \.self) { interval in
                    let date = Date(timeIntervalSince1970: interval)
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                }
            }
            .frame(height: 120)
                        
            // LazyGrid para hacer la vista de calendario
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.last30Days, id: \.self) { date in
                    let dayInterval = Calendar.current.startOfDay(for: date).timeIntervalSince1970
                    let isBold = viewModel.boldHistory.contains(dayInterval)
                    
                    Circle()
                        .fill(isBold ? Color.green : Color.gray.opacity(0.2))
                        .frame(width: 12, height: 12)
                        .animation(.easeInOut(duration: 0.2), value: isBold)
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    DailyBoldTrackerView()
}
