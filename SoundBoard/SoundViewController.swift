//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Stephen Romero on 2/5/17.
//  Copyright © 2017 Stephen Romero. All rights reserved.
//

import UIKit
//audio import
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    //optional variable for audiorecorder
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        //greys out the add button and play button
        playButton.isEnabled = false
        addButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func setupRecorder()
    {
        do {
            //Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            //Create URL for the audio file
            //URL can also refer to a file in the file system
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "aduio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("##############")
            print(audioURL!)
            print("##############")
            
            //Create settings for audio recorder
            var settings : [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            //Create audio recorder object
            audioRecorder =  try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError
        {
            print(error)
        }
    }
    @IBAction func recordTapped(_ sender: Any)
    {
        if audioRecorder!.isRecording
        {
            //Stop the recording
            audioRecorder!.stop()
            
            //Change button title to record
            recordButton.setTitle("Record", for: .normal)
            //allows user to press the play button and add button once they record a sound
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        }
        else
        {
            //Start the recording
            audioRecorder!.record()
            
            //Change the button title to stop
            recordButton.setTitle("Stop", for: .normal)
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any)
    {
        do
        {
          try  audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
          audioPlayer?.play()
        }
        catch
        {
            
        }
        
    }
    
    @IBAction func addTapped(_ sender: Any)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        //NS data
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //goes back to previous screen once the user adds the sound
        navigationController!.popViewController(animated: true)
        
        
    }
    
}
