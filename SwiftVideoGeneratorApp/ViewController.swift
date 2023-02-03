//
//  ViewController.swift
//  SwiftVideoGeneratorApp
//
//  Created by Kostya Lee on 02/02/23.
//

import UIKit
import SwiftVideoGenerator
import AVFoundation
import AVKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func GenerateTapped(_ sender: UIButton) {
        generateVideo()
    }
    
    func generateVideo() {
        if let audioURL = Bundle.main.url(forResource: "music", withExtension: Mp3Extension) {
          LoadingView.lockView()
          
          VideoGenerator.fileName = MultipleSingleMovieFileName
          VideoGenerator.shouldOptimiseImageForVideo = true
          
          VideoGenerator.current.generate(withImages: [#imageLiteral(resourceName: "person_jump"), #imageLiteral(resourceName: "person_garage"), #imageLiteral(resourceName: "person_roof"), #imageLiteral(resourceName: "skate"), #imageLiteral(resourceName: "person_sky"), #imageLiteral(resourceName: "person_walls"),], andAudios: [audioURL], andType: .singleAudioMultipleImage, { (progress) in
            print(progress)
          }) { (result) in
            LoadingView.unlockView()
            switch result {
            case .success(let url):
              print(url)
              self.createAlertView(message: self.FinishedSingleTypeVideoGeneration)
                self.playVideo(from: url)
            case .failure(let error):
              print(error)
              self.createAlertView(message: error.localizedDescription)
            }
          }
        } else {
          self.createAlertView(message: MissingAudioFiles)
        }
    }
    
    fileprivate func createAlertView(message: String?) {
      let messageAlertController = UIAlertController(title: Message, message: message, preferredStyle: .alert)
      messageAlertController.addAction(UIAlertAction(title: OK, style: .default, handler: { (action: UIAlertAction!) in
        messageAlertController.dismiss(animated: true, completion: nil)
      }))
      DispatchQueue.main.async { [weak self] in
        self?.present(messageAlertController, animated: true, completion: nil)
      }
    }
    
    private func playVideo(from url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    // MARK: - Private properties
    
    /// Alert error strings
    private let MissingResourceFiles = "Missing resource files"
    private let MissingImageFiles = "Missing image files"
    private let MissingAudioFiles = "Missing audio files"
    private let MissingVideoFiles = "Missing video files"
    
    private let FnishedMultipleVideoGeneration = "Finished multiple type video generation"
    private let FinishedSingleTypeVideoGeneration = "Finished single type video generation"
    private let FinishedMergingVideos = "Finished merging videos"
    private let FinishReversingVideo = "Finished reversing video"
    private let FinishSplittingVideo = "Finished splitting video"
    private let FinishMergingVideoWithAudio = "Finished merging video with audio"
    
    private let SingleMovieFileName = "singleMovie"
    private let MultipleMovieFileName = "multipleVideo"
    private let MultipleSingleMovieFileName = "newVideo"
    private let MergedMovieFileName = "mergedMovie"
    private let ReversedMovieFileName = "reversedMovie"
    private let SplitMovieFileName = "splitMovie"
    private let NewAudioMovieFileName = "newAudioMovie"
    
    /// Resource extensions
    private let MovExtension = "mov"
    private let Mp3Extension = "mp3"
    private let MOVExtension = "mov"
    private let Mp4Extension = "mp4"
    
    /// Resource file names
    private let Video1 = "video1"
    private let Video2 = "video2"
    private let Video3 = "video3"
    private let Video4 = "video4"
    private let PortraitVideo = "portraitVideo"
    
    private let Message = "message"
    private let OK = "OK"
}
