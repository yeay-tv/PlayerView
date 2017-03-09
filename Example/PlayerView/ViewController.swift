//
//  ViewController.swift
//  PlayerVideo
//
//  Created by David Alejandro on 2/17/16.
//  Copyright © 2016 David Alejandro. All rights reserved.
//

import UIKit
import PlayerView
import AVFoundation


private extension Selector {
    static let changeFill = #selector(ViewController.changeFill(_:))
}


class ViewController: UIViewController {
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet var playerVideo: PlayerView!
    
    @IBOutlet var rateLabel: UILabel!
    
    @IBOutlet var playButton: UIButton!
    
    
    var duration: Float!
    var isEditingSlider = false
    let tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        playerVideo.delegate = self
        let url1 = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!
        let url = URL(string: "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4")!
        
        //playerVideo.url = url
        
        playerVideo.urls = [url1,url1]
        playerVideo.loopVideosQueue = true
        playerVideo.play()
        //playerVideo.addVideosOnQueue(urls: [url])
        tap.numberOfTapsRequired = 2
        tap.addTarget(self, action: .changeFill)
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sliderChange(_ sender: UISlider) {
        //print(sender.value)
        
        playerVideo.currentTime = Double(sender.value)
    }
    
    @IBAction func sliderBegin(_ sender: AnyObject) {
        print("beginEdit")
        isEditingSlider = true
    }
    
    @IBAction func sliderEnd(_ sender: AnyObject) {
        print("endEdit")
        isEditingSlider = false
    }
    
    
    
    @IBAction func backwardTouch(_ sender: AnyObject) {
        playerVideo.rate = playerVideo.rate - 0.5
    }
    
    @IBAction func playTouch(_ sender: AnyObject) {
        if playerVideo.rate == 0 {
            playerVideo.play()
        } else {
            playerVideo.pause()
        }
    }
    
    @IBAction func fowardTouch(_ sender: AnyObject) {
        playerVideo.rate = playerVideo.rate + 0.5
    }
    
    func changeFill(_ sender: AnyObject) {
        switch playerVideo.fillMode {
        case .Some(.ResizeAspect):
                playerVideo.fillMode = .ResizeAspectFill
        case .Some(.ResizeAspectFill):
            playerVideo.fillMode = .Resize
        case .Some(.Resize):
            playerVideo.fillMode = .ResizeAspect
        default:
            break
        }
    }
    override func loadView() {
        super.loadView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension ViewController: PlayerViewDelegate {
    
    func playerVideo(_ player: PlayerView, statusPlayer: PVStatus, error: NSError?) {
        print(statusPlayer)
    }
    
    func playerVideo(_ player: PlayerView, statusItemPlayer: PVItemStatus, error: NSError?) {
        
    }
    func playerVideo(_ player: PlayerView, loadedTimeRanges: [PVTimeRange]) {
        
        let durationTotal = loadedTimeRanges.reduce(0) { (actual, range) -> Double in
            return actual + range.end.seconds
        }
        let dur2 = Float(durationTotal)
        let progress = dur2 / duration
        progressBar?.progress = progress
        
        if loadedTimeRanges.count > 1 {
            print(loadedTimeRanges.count)
        }
        //print("progress",progress)
    }
    func playerVideo(_ player: PlayerView, duration: Double) {
        //print(duration.seconds)
        self.duration = Float(duration)
        slider?.maximumValue = Float(duration)
    }
    
    func playerVideo(_ player: PlayerView, currentTime: Double) {
        if !isEditingSlider {
            slider.value = Float(currentTime)
        }
        //print("curentTime",currentTime)
    }
    
    func playerVideo(_ player: PlayerView, rate: Float) {
        rateLabel.text = "x\(rate)"
        
        
        let buttonImageName = rate == 0.0 ? "PlayButton" : "PauseButton"
        
        let buttonImage = UIImage(named: buttonImageName)
        
        playButton.setImage(buttonImage, for: UIControlState())
        
        //slider.value = Float(currentTime)
        //print(currentTime.seconds)
    }
    
    func playerVideo(playerFinished player: PlayerView) {
        player.next()
        player.play()
        print("video has finished")
    }
}
