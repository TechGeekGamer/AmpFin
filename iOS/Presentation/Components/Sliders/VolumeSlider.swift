//
//  VolumeSlider.swift
//  Music
//
//  Created by Rasmus Krämer on 07.09.23.
//

import SwiftUI
import AFPlayback
import AVKit

struct VolumeSlider: View {
    @State var volume = Double(AudioPlayer.current.volume) * 100
    @State var isDragging: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "speaker.fill")
                .onTapGesture {
                    AudioPlayer.current.volume = 0
                }
            
            Slider(percentage: $volume, dragging: $isDragging)
            
            Image(systemName: "speaker.wave.3.fill")
                .onTapGesture {
                    AudioPlayer.current.volume = 1
                }
        }
        .dynamicTypeSize(isDragging ? .xLarge : .medium)
        .frame(height: 0)
        .animation(.easeInOut, value: isDragging)
        .onChange(of: volume) {
            if isDragging {
                AudioPlayer.current.volume = Float(volume / 100)
            }
        }
        // because apple makes stupid software i guess
        .onReceive(AVAudioSession.sharedInstance().publisher(for: \.outputVolume), perform: { value in
            if !isDragging && AudioPlayer.current.source == .local {
                withAnimation {
                    volume = Double(value) * 100
                }
            }
        })
    }
}
