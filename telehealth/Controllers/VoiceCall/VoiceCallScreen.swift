//
//  VoiceCallScreen.swift
//  telehealth
//
//  Created by iroid on 24/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import TwilioVideo


class VoiceCallScreen: UIViewController ,LocalParticipantDelegate{
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var profileImageView: dateSportImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    
    var localAudioTrack = LocalAudioTrack()
    var localDataTrack = LocalDataTrack()
    var callModel : CallModel?
    var room: Room?
    var remoteParticipant: RemoteParticipant?
    var count = 0
    var audioEnable = Bool()
    var name = String()
    var appointmentDeatilModel :AppointmentDataModel?
    var onDoneBlock : ((Bool) -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalizedDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isOnCallScreen = true
        UIApplication.shared.isIdleTimerDisabled = true

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
           isOnCallScreen = false
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func initalizedDetails(){
        muteButton.isUserInteractionEnabled = false
        audioEnable = true
        self.name = ""
        if(appointmentDeatilModel?.role == 1){
            userNameLabel.text = appointmentDeatilModel?.username
        }else{
            userNameLabel.text = "\(appointmentDeatilModel?.firstname ?? "") \(appointmentDeatilModel?.lastname ?? "")"
        }
        Utility.setImage(appointmentDeatilModel?.profile, imageView: self.profileImageView)
        self.callConnect()
    }
    
    @IBAction func onAudio(_ sender: UIButton) {
        if (self.localAudioTrack != nil) {
            if (self.localAudioTrack?.isEnabled == true) {
                self.localAudioTrack?.isEnabled = false
                muteButton.setBackgroundImage(UIImage(named: "calling_mute_icon"), for: .normal)
            } else {
                self.localAudioTrack?.isEnabled = true
                muteButton.setBackgroundImage(UIImage(named: "calling_audio_icon"), for: .normal)
            }
        }
    }
    
    @IBAction func onCall(_ sender: UIButton) {
        self.roomDiscnnected()
    }
    
    func callConnect(){
        let connectOptions = ConnectOptions(token: (self.callModel?.data?.accessToken) ?? "") { (builder) in
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            builder.roomName = self.callModel?.data?.roomName
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        logMessage(messageText: "Attempting to connect to room ")
        
        self.prepareLocalMedia()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.room != nil
    }
    
    func roomDiscnnected(){
        room?.disconnect()
        self.endAppointment()
    }
    
    func endAppointment(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(END_CALL)\(appointmentDeatilModel?.sessionId ?? 0)"
            CallServices.shared.endAppointment(url:url,success: { (statusCode, blogModel) in
                Utility.hideIndicator()
                self.onDoneBlock!(true)
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    @objc func update() {
        let time = Utility.UTCToLocal(date: (appointmentDeatilModel?.session)!, fromFormat: YYYY_MM_DDHHMMSS, toFormat: YYYY_MM_DDHHMMSS)
        let today = Date()
        let todayDate = today.toString(dateFormat: YYYY_MM_DDHHMMSS)
        
        let timeformatter = DateFormatter()
        timeformatter.locale = Locale(identifier: "en")
        timeformatter.dateFormat = YYYY_MM_DDHHMMSS
        
        
        guard let time1 = timeformatter.date(from: time),
              let time2 = timeformatter.date(from: todayDate) else { return  }
        
        //You can directly use from here if you have two dates
        
        let interval = time1.timeIntervalSince(time2)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        if(appointmentDeatilModel?.consultationPrice == "" || appointmentDeatilModel?.consultationPrice == nil || appointmentDeatilModel?.consultationPrice == "0" ){
            if(minute >= -29){
                let minutes = (count / 60)
                let seconds = (count % 60)
                if(audioEnable){
                    timerLabel.text = String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
                }else{
                    timerLabel.text = "Call muted"
                }
                count+=1
            }else{
                self.roomDiscnnected()
            }
        }else{
        if(minute >= -59){
            let minutes = (count / 60)
            let seconds = (count % 60)
            if(audioEnable){
                timerLabel.text = String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
            }else{
                timerLabel.text = "Call muted"
            }
            count+=1
        }else{
            self.roomDiscnnected()
        }
        }
    }
    
    
    func prepareLocalMedia() {
        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
    
    func startTimer(){
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
}

extension VoiceCallScreen : RoomDelegate {
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
            muteButton.isUserInteractionEnabled = true
              muteButton.setBackgroundImage(UIImage(named: "calling_audio_icon"), for: .normal)
              self.startTimer()
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        self.room = nil
        }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        
        //        self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self
        muteButton.isUserInteractionEnabled = true
        muteButton.setBackgroundImage(UIImage(named: "calling_audio_icon"), for: .normal)
        self.startTimer()
        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        self.roomDiscnnected()
//        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
//        if(uesrRole == 1){
//            let storyBoard = UIStoryboard(name: "Feedback", bundle: nil)
//            let control = storyBoard.instantiateViewController(withIdentifier: "FeedbackScreen") as! FeedbackScreen
//            control.psychologistId = self.appointmentDeatilModel?.psychologistId ?? 0
//            control.modalPresentationStyle = .overFullScreen
//            self.present(control, animated: true, completion: nil)
//        }
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

// MARK:- RemoteParticipantDelegate
extension VoiceCallScreen : RemoteParticipantDelegate {
    
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        if (self.remoteParticipant == nil) {
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        if self.remoteParticipant == participant {
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        audioEnable = true
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        audioEnable = false
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}
