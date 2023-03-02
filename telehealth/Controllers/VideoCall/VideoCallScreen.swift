//
//  VideoCallScreen.swift
//  telehealth
//
//  Created by iroid on 25/08/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import TwilioVideo


class VideoCallScreen: UIViewController, LocalParticipantDelegate {
    
    @IBOutlet weak var remoteView: VideoView!
    @IBOutlet weak var previewView: VideoView!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cameraAudioMessageLabel: UILabel!
    @IBOutlet weak var voiceMuteImageView: UIImageView!
    @IBOutlet weak var voiceMuteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var count = 0
    var localAudioTrack = LocalAudioTrack()
    var localDataTrack = LocalDataTrack()
    var localVideoTrack : LocalVideoTrack?
    var callModel : CallModel?
    var appointmentDeatilModel :AppointmentDataModel?
    var room: Room?
    var camera: CameraSource?
    var remoteParticipant: RemoteParticipant?
    var audioEnable = Bool()
    var videoEnable = Bool()
    var name = String()
    var onDoneBlock : ((Bool) -> Void)?
    var timer : Timer?
    
    deinit {
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PlatformUtils.isSimulator {
            self.previewView.removeFromSuperview()
        } else {
            self.startPreview()
        }
        initalizedDetails()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    @objc func preventScreenRecording() {
        let isCaptured = UIScreen.main.isCaptured
        if isCaptured {
            blockView.isHidden = false
        } else {
            blockView.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.isIdleTimerDisabled = true
        isOnCallScreen = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if timer != nil {
           timer!.invalidate()
           timer = nil
         }
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.isIdleTimerDisabled = false
        isOnCallScreen = false
    }

    
    @IBAction func roomDisconnected(_ sender: Any) {
        self.roomDiscnnected()
    }
    
    @IBAction func onHideTimer(_ sender: Any) {
        if(timerLabel.isHidden){
            timerLabel.isHidden = false
            userNameLabel.isHidden = false
        }else{
            timerLabel.isHidden = true
            userNameLabel.isHidden = true
        }
    }
    @IBAction func onMuteUnmute(_ sender: Any) {
        if (self.localAudioTrack != nil) {
            if (self.localAudioTrack?.isEnabled == true) {
                self.localAudioTrack?.isEnabled = false
                muteButton.setBackgroundImage(UIImage(named: "audio_mute_icon"), for: .normal)
            } else {
                self.localAudioTrack?.isEnabled = true
                muteButton.setBackgroundImage(UIImage(named: "Audio_icon"), for: .normal)
            }
        }
    }
    
    func initalizedDetails(){
        audioEnable = true
        videoEnable = true
        self.name = ""
        if(appointmentDeatilModel?.role == 1){
            userNameLabel.text = appointmentDeatilModel?.username
        }else{
            userNameLabel.text = "\(appointmentDeatilModel?.firstname ?? "") \(appointmentDeatilModel?.lastname ?? "")"
        }
        if(appointmentDeatilModel?.profile == nil || appointmentDeatilModel?.profile == ""){
//            profileImageView.image = UIImage(named:"video_call_placeholder.png")
        }else{
            Utility.setImage(appointmentDeatilModel?.profile, imageView: profileImageView)
        }
        self.name = userNameLabel.text!
        self.setEnableDisableView()
        muteButton.isUserInteractionEnabled = false
        
        self.callConnect()
        
    }
    
    func callConnect(){
        let connectOptions = ConnectOptions(token: (self.callModel?.data?.accessToken) ?? "") { (builder) in
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
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
    
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            
            let options = CameraSourceOptions { (builder) in
                if #available(iOS 13.0, *) {
                    builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
                }
            }
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(options: options, delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            logMessage(messageText: "Video track created")
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.logMessage(messageText:"No front or back capture device found!")
        }
    }
    
    @IBAction func onVideo(_ sender: Any) {
        if (self.localVideoTrack != nil) {
            // Update the button title
            if (self.localVideoTrack?.isEnabled == true) {
                //                       self.micButton.setTitle("Mute", for: .normal)
                self.localVideoTrack?.isEnabled = false
                videoButton.setBackgroundImage(UIImage(named: "video_call_mute_icon"), for: .normal)
            } else {
                //                       self.micButton.setTitle(, for: .normal)
                self.localVideoTrack?.isEnabled = true
                videoButton.setBackgroundImage(UIImage(named: "Video_call_icon"), for: .normal)
            }
        }
        
    }
    @IBAction func onFlipCamera(_ sender: Any) {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        // self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    //    @objc func flipCamera()
    
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }
    @objc func update() {
        if(Utility.getCurrentLanguage() == ARABIC_LANG_CODE){
            
        }else{
            
        }
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
                timerLabel.text = String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
                count+=1
            }else{
                if timer != nil {
                   timer!.invalidate()
                   timer = nil
                 }
                self.roomDiscnnected()
            }
        }else{
        if(minute >= -59){
            let minutes = (count / 60)
            let seconds = (count % 60)
            timerLabel.text = String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
            count+=1
        }else{
            if timer != nil {
               timer!.invalidate()
               timer = nil
             }
            self.roomDiscnnected()
        }
        }
    }
    
    func roomDiscnnected(){
        room?.disconnect()
        self.endAppointment()
    }
    func prepareLocalMedia() {
        
        // We will share local audio and video when we connect to the Room.
        
        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
            
            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    
    
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    
    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    
    func endAppointment(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(END_CALL)\(appointmentDeatilModel?.sessionId ?? 0)"
            CallServices.shared.endAppointment(url:url,success: { (statusCode, blogModel) in
                Utility.hideIndicator()
                self.onDoneBlock!(true)
                if self.timer != nil {
                    self.timer!.invalidate()
                    self.timer = nil
                 }
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
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func setEnableDisableView(){
        if(videoEnable && audioEnable){
            cameraAudioMessageLabel.text = ""
            cameraAudioMessageLabel.isHidden = true
            voiceMuteImageView.isHidden = true
            voiceMuteHeightConstraint.constant = 0
        }else if(!videoEnable && !audioEnable){
            voiceMuteImageView.isHidden = true
            voiceMuteHeightConstraint.constant = 0
            cameraAudioMessageLabel.text = "\(self.name) \(Utility.getLocalizdString(value: "CAMERA_AND_MICROPHONE_OFF"))"
            cameraAudioMessageLabel.isHidden = false
        }else{
            if(!videoEnable){
                cameraAudioMessageLabel.text = "\(self.name) \(Utility.getLocalizdString(value: "CAMERA_OFF"))"
                cameraAudioMessageLabel.isHidden = false
            }else if(!audioEnable){
                cameraAudioMessageLabel.text = "\(self.name) \(Utility.getLocalizdString(value: "MUTED_THIS_CALL"))"
                cameraAudioMessageLabel.isHidden = false
                voiceMuteImageView.isHidden = false
                voiceMuteHeightConstraint.constant = 25
            }
        }
    }
}

extension VideoCallScreen : RoomDelegate {
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            self.startTimer()
            muteButton.isUserInteractionEnabled = true
            muteButton.setBackgroundImage(UIImage(named: "Audio_icon"), for: .normal)
            profileImageView.isHidden = true
            remoteParticipant.delegate = self
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        //        self.showRoomUI(inRoom: false)
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
        self.startTimer()
        muteButton.isUserInteractionEnabled = true
        muteButton.setBackgroundImage(UIImage(named: "Audio_icon"), for: .normal)
        profileImageView.isHidden = true
        participant.delegate = self
        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        self.roomDiscnnected()
    }
}

// MARK:- RemoteParticipantDelegate
extension VideoCallScreen : RemoteParticipantDelegate {
    
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
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
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
        videoEnable = true
        self.setEnableDisableView()
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        videoEnable = false
        self.setEnableDisableView()
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        audioEnable = true
        self.setEnableDisableView()
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        audioEnable = false
        self.setEnableDisableView()
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- VideoViewDelegate
extension VideoCallScreen : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension VideoCallScreen : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}

class Settings: NSObject {
    
    // ISDK-2644: Resolving a conflict with AudioToolbox in iOS 13
    let supportedAudioCodecs: [TwilioVideo.AudioCodec] = [IsacCodec(),
                                                          OpusCodec(),
                                                          PcmaCodec(),
                                                          PcmuCodec(),
                                                          G722Codec()]
    
    let supportedVideoCodecs: [VideoCodec] = [Vp8Codec(),
                                              Vp8Codec(simulcast: true),
                                              H264Codec(),
                                              Vp9Codec()]
    
    // Valid signaling Regions are listed here:
    // https://www.twilio.com/docs/video/ip-address-whitelisting#signaling-communication
    let supportedSignalingRegions: [String] = ["gll",
                                               "au1",
                                               "br1",
                                               "de1",
                                               "ie1",
                                               "in1",
                                               "jp1",
                                               "sg1",
                                               "us1",
                                               "us2"]
    
    
    let supportedSignalingRegionDisplayString: [String : String] = ["gll": "Global Low Latency",
                                                                    "au1": "Australia",
                                                                    "br1": "Brazil",
                                                                    "de1": "Germany",
                                                                    "ie1": "Ireland",
                                                                    "in1": "India",
                                                                    "jp1": "Japan",
                                                                    "sg1": "Singapore",
                                                                    "us1": "US East Coast (Virginia)",
                                                                    "us2": "US West Coast (Oregon)"]
    
    var audioCodec: TwilioVideo.AudioCodec?
    var videoCodec: VideoCodec?
    
    var maxAudioBitrate = UInt()
    var maxVideoBitrate = UInt()
    
    var signalingRegion: String?
    
    func getEncodingParameters() -> EncodingParameters?  {
        if maxAudioBitrate == 0 && maxVideoBitrate == 0 {
            return nil;
        } else {
            return EncodingParameters(audioBitrate: maxAudioBitrate,
                                      videoBitrate: maxVideoBitrate)
        }
    }
    
    private override init() {
        // Can't initialize a singleton
    }
    
    // MARK:- Shared Instance
    static let shared = Settings()
}


// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

