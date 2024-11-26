//
//  ContentView.swift
//  App Name: Push Up Plus
//
//  Created by Troy Kubanka on 8/2/23.
//



import SwiftUI
import AVFoundation
import AVKit


// Custom navigation style
struct CustomNavigationStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}


// My first view or "home page" of the app
struct ContentView: View {
    @State private var isCalendarPresented = false // New state variable to pull up calender
    @State private var isTrophyListPresented = false // New state variable to pull up trophy/badge list
    @State private var isPushupsCompleted = false // New state variable to say if push-ups are completed
    @State private var isRecordingInProgress = false // New state variable to track if video recording is in progress
        
    
    // main menu
    var body: some View {
        NavigationView {
                VStack {
                    TrophyButton(isTrophyListPresented: $isTrophyListPresented) // trophy button

                Text("Push-Up+")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Image("PushUpImage") //(systemName: "figure.walk")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 200)
                
                // "Complete Daily Push-Ups" button
                Button(action: {
                    isPushupsCompleted = true // Mark push-ups as completed
                }) {
                    Text("💪   Reach  Your  Next  Goal  💪")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(25)
                        .background(Color.green) // Set the button color to green
                        .cornerRadius(10)
                }
                .padding()
                .modifier(CustomNavigationStyle()) // Apply the custom navigation style here
                
                // "Record Your Push-ups" button with video recording
                Button(action: {
                    isRecordingInProgress = true // Start the recording process
                }) {
                    Text("🎥  Record  Your  Push-ups  🎥")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(25)
                        .background(Color.red) // Set the button color to blue
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $isRecordingInProgress) {
                    VideoRecorder(isRecordingInProgress: $isRecordingInProgress)
                }
                
                // "View Your Progress" button
                NavigationLink(
                    destination: ProgressView(isCalendPresented: $isCalendarPresented),
                    isActive: $isCalendarPresented,
                    label: {
                        Text("🗓️     View  Your  Progress     🗓️")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(25)
                            .background(Color.orange) // Set the button color to orange
                            .cornerRadius(10)
                    }
                )
                .padding()
                
                // REVIEW THIS PART
                
                // Show the "Push-ups Completed!" button on a new screen if push-ups are completed
                if isPushupsCompleted {
                    NavigationLink(
                        destination: PushupsCompletedView(isRecordingInProgress: $isRecordingInProgress),
                        isActive: $isPushupsCompleted,
                        label: {
                            Text("Push-Ups Completed!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green) // Set the button color to green
                                .cornerRadius(10)
                        }
                    )
                    .padding()
                }
            }
            .onAppear {
                isPushupsCompleted = false // Reset isPushupsCompleted when the view appears
            }
            .background(Color(UIColor.systemBackground)) // Set the background color to match light/dark mode

        }
    }
}


// Achievements/Trophies Section
struct TrophyButton: View {
    @Binding var isTrophyListPresented: Bool

    var body: some View {
        Button(action: {
            isTrophyListPresented.toggle()
        }) {
            Image(systemName: "trophy")
                .font(.title)
                .foregroundColor(.blue)
        }
        .popover(isPresented: $isTrophyListPresented, arrowEdge: .top) {
            VStack(spacing: 75) {
                TrophySection(
                    title: "Push-up Growth",
                    colors: [.green, .silver, .gold],
                    labelTexts: ["+10", "+25", "+50"]
                )
                TrophySection(
                    title: "Day Streak",
                    colors: [.bronze, .silver, .gold],
                    labelTexts: ["7", "14", "31"]
                )
                TrophySection(
                    title: "Total Push-ups",
                    colors: [.bronze, .silver, .gold],
                    labelTexts: ["25", "50", "100"]
                )
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
        .padding(.trailing, 20)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct TrophySection: View {
    var title: String
    var colors: [Color]
    var labelTexts: [String]

    var body: some View {
        VStack(spacing: 25) {
            Text(title)
                .font(.system(size: 30))
                .fontWeight(.bold)

            HStack(spacing: 50) {
                ForEach(0..<colors.count, id: \.self) { index in
                    ZStack {
                        Circle()
                            .foregroundColor(colors[index])
                            .frame(width: 70, height: 70)

                        Text(labelTexts[index])
                            .font(.system(size: 30))
                    }
                }
            }
        }
    }
}

// Color extension
extension Color {
    static let gold = Color(red: 255 / 255, green: 215 / 255, blue: 0)
    static let silver = Color(red: 192 / 255, green: 192 / 255, blue: 192 / 255)
    static let bronze = Color(red: 205 / 255, green: 127 / 255, blue: 50 / 255)
}



// Custom view to display a random congratulatory message in struct PushupsCompletedView below
struct RandomCongratulatoryMessage: View {
    let messages = congratulatoryMessages.shuffled()
    
    var body: some View {
        Text(messages.first ?? "")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }
}

// Struct for once the button "Reach Your Next Goal" is selected
struct PushupsCompletedView: View {
    @Binding var isRecordingInProgress: Bool // Binding to track if recording is in progress
    @State private var showCongratulations = false // State variable to control the presentation of the "Congratulations" page
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Text("x                                  push-ups")
                .font(.system(size: 40, weight: .bold)) // Set the font size and weight
                .padding(.bottom, 20)
                .frame(width: 350)
                .multilineTextAlignment(.center) // Center the text horizontally
            Text("Did you complete this challenge?")
                .font(.system(size: 30, weight: .bold)) // Set the font size and weight
                .padding(.bottom, 20)
                .frame(width: 350)
                .multilineTextAlignment(.center) // Center the text horizontally
            
            HStack(spacing: 75)   {
                      // Handles the action for "YES" button
                Button(action: {
                    showCongratulations = true // Show the Congratulations page
                }) {
                    Text("YES")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.green) // Set the button color to green
                        .cornerRadius(25)
                }
               
            }
            .padding(.bottom, 20) // Add some spacing between the text and buttons
            
            Spacer()
            
            // Add more content here for the completed screen
        }
        .navigationBarTitle("Current Challenge") // Set the navigation bar title
        .sheet(isPresented: $showCongratulations) {
            VStack {
                RandomCongratulatoryMessage()
                Spacer()
                NavigationLink(destination: Text("New Page with Blue NEXT Button")) {
                    Text("NEXT")
                        .font(.system(size: 25, weight: .bold))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(25)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}


// Congratulations View
struct CongratulationsView: View {
    let congratulatoryMessage: String
    
    var body:  some View {
        VStack(spacing: 5) {
            Spacer()
            Text(congratulatoryMessage)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
            NavigationLink(destination: Text("New Page with Blue NEXT Button")) {
                Text("NEXT")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(25)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
// Array of congratulatory messages
let congratulatoryMessages = [
    "Congratulations!",
    "Amazing Job!",
    "Excellent!",
    "Awesome!",
    "Way To Go!"
]




// Struct for the button "View Your Progress"
struct ProgressView: View {
    @Binding var isCalendPresented: Bool
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            .padding(.horizontal)
            
            Text("  Current Streak : 5 🔥")
                .font(.headline)
                .padding()
                
            Text("Push-Ups: 23")
                .font(.headline)
                .padding()
            Text("Calendar")
                .font(.title)
                .fontWeight(.bold)
                .padding()
           
            // DatePicker for selecting a date
            DatePicker(selection: $selectedDate, in: ...Date(), displayedComponents: .date) {
                Text("Select Date")
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitle("Your Progress") // Set the navigation bar title
    }
}









// Custom View for video recording and countdown
struct VideoRecorder: View {
    @Binding var isRecordingInProgress: Bool
    @State private var isRecording = false // New state variable to track if video recording is in progress
    @State private var countdownCompleted = false // Track if the countdown is completed
    
    
   // trying to get camera access to work
    /*
    let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

    let microphoneAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    */

    
    
    var body: some View {
        VStack {
            Text("Video Recording")
                .font(.title)
            
            // Display a placeholder view for video recording, or use AVFoundation to record video
            Rectangle()
                .frame(height: 400)
                .foregroundColor(.black)
                .padding()
            
            if isRecordingInProgress {
                if countdownCompleted {
                    Text("Recording in progress...")
                        .font(.headline)
                        .foregroundColor(.red)
                } else {
                    // Nested CountdownView inside the VideoRecorder
                    CountdownView(countdownSeconds: 3, onCompletion: { countdownCompleted = true })
                        .padding()
                }
            }
            
            Button(action: {
                // Stop video recording
                stopRecording()
            }) {
                Text("Stop Recording")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
        }
    }
    
    // Start video recording method
    private func startRecording() {
        // Your AVFoundation code to start recording here
    }
    
    // Stop video recording method
    private func stopRecording() {
        isRecording = false
        isRecordingInProgress = false
        // timer?.invalidate()
    }
}

// Nested CountdownView inside the VideoRecorder
struct CountdownView: View {
    var countdownSeconds: Int
    var onCompletion: (() -> Void)?
    @State private var remainingSeconds: Int
    @State private var timer: Timer?
    
    init(countdownSeconds: Int, onCompletion: (() -> Void)? = nil) {
        self.countdownSeconds = countdownSeconds
        self.onCompletion = onCompletion
        _remainingSeconds = State(initialValue: countdownSeconds)
    }
    
    var body: some View {
        Text("\(remainingSeconds)")
            .font(.largeTitle)
            .foregroundColor(.red)
            .onAppear {
                startCountdown()
            }
    }
    
    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remainingSeconds -= 1
            if remainingSeconds <= 0 {
                timer.invalidate()
                onCompletion?()
            }
        }
        timer?.tolerance = 0.1
    }
}
// -------------------------------------








/*
 
// Try to incorporate a streak counter (every 48 hours)
 
 private extension Sequence where Element == Date {
     
     var streaks: Int {
         let TwoDaysInSeconds: Double = 60*60*48
         let days = self.compactMap { Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: $0) }
         let uniq = Set(days).sorted(by: >)
         
         var count = 0
         guard var lastStreak = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) else { return count }
         
         for date in uniq {
             guard date > lastStreak.advanced(by: -oneDayInSeconds - 1) else { break }
             count += 1
             lastStreak = date
         }
         
         return count
     }
     
 }
 
 
 */








// ---------------------------------------------------------------




// To preview the app
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




