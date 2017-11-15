//
//  RecognizerViewController.swift
//  SpeechRecognizer
//
//  Created by Andrei Momot on 11/15/17.
//    Copyright © 2017 Andrey Momot. All rights reserved.
//

import UIKit
import Speech

typealias RecognizerViewControllerType = MVCViewController<RecognizerModelProtocol, RecognizerViewProtocol, RecognizerRouter>

class RecognizerViewController: RecognizerViewControllerType, SFSpeechRecognizerDelegate, RecognizerViewDelegate, RecognizerModelDelegate {
    
    // MARK: Initializers
    
    required public init(withView view: RecognizerViewProtocol!, model: RecognizerModelProtocol!, router: RecognizerRouter?) {
        super.init(withView: view, model: model, router: router)
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // MARK: - View life cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        customView.delegate = self
        model.delegate = self
        speechAuth()
    }
    
    // MARK: - Speech Recognition Authorization Request
    func speechAuth() {
        customView.recordButton.isEnabled = false
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted in this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation {
                self.customView.recordButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.customView.recognizedTextView.text = result!.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.customView.recordButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.customView.recognizedTextView.text = "Say something, I'm listening!"
    }
    
    // MARK: - SFSpeechRecognizerDelegate
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            customView.recordButton.isEnabled = true
        } else {
            customView.recordButton.isEnabled = false
        }
    }
    
    public func startRecognition(view: RecognizerViewProtocol) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            customView.recordButton.isEnabled = false
            customView.recordButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            customView.recordButton.setTitle("Stop Recording", for: .normal)
        }
    }
}
