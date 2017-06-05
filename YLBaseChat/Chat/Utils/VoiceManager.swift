//
//  VoiceManager.swift
//  YLBaseChat
//
//  Created by yl on 17/6/5.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import AVFoundation

typealias PlayerDidFinishPlayingBlock = () -> Void

class VoiceManager:NSObject{
    
    // 单例
    static let shared = VoiceManager()
    private override init(){}
    
    var duration:Int = 0 // 录音时间
    var recorder_file_path:String? = nil // 录音路径
    
    fileprivate var recorder: AVAudioRecorder? = nil
    fileprivate var player: AVAudioPlayer? = nil
    
    fileprivate var timer:Timer? = nil
    fileprivate var pathTag:Int = 0
    
    fileprivate var completeBlock:PlayerDidFinishPlayingBlock?
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    //开始录音
    func beginRecord() {
        duration = 0
        
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            recorder_file_path = getFilePath()
            if let file_path = recorder_file_path {
                let url = URL(fileURLWithPath: file_path)
                recorder = try AVAudioRecorder(url: url, settings: recordSetting)
                recorder!.prepareToRecord()
                recorder!.record()
                
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(VoiceManager.recordingTime)), userInfo: nil, repeats: true)
                print("开始录音")
            }
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    //结束录音
    func stopRecord() {
        timer?.invalidate()
        timer = nil
        if let recorder = recorder {
            if recorder.isRecording {
                if let file_path = recorder_file_path {
                    print("正在录音，马上结束它，文件保存到了：\(file_path)")
                }
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    // 取消录音
    func cancelRecord() {
        stopRecord()
        if let file_path = recorder_file_path {
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: file_path))
            print("删除录音:\(file_path)")
        }
        
    }
    
    // 录音获取音量
    func getRecordVolume() -> Float {
        var ret:Float = 0.0
        if let recorder = recorder {
            if recorder.isRecording {
                recorder.updateMeters()
                //获取音量的平均值  [recorder averagePowerForChannel:0];
                //音量的最大值  [recorder peakPowerForChannel:0];
                ret = pow(10, (0.05 *  recorder.peakPower(forChannel: 0)))
            }
        }
        return ret
    }
    
    //播放
    func play(_ path: String?,_ block: PlayerDidFinishPlayingBlock?) {
        
        do {
            completeBlock = block
            
            if let path = path {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.delegate = self
                player?.prepareToPlay()
                player!.play()
            }
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    //结束播放
    func stopPlay() {
        
        if let player = player {
            if player.isPlaying {
                print("停止播放")
            }else {
                print("没有播放")
            }
            player.stop()
            completeBlock = nil
            self.player?.delegate = nil
            self.player = nil
        }else {
            print("没有初始化")
        }
    }
    
    
    // 录音记时
    @objc fileprivate func recordingTime() {
        
        duration += 1
        print("录音时间:\(duration)")
    }
    
    // 获取路径
    fileprivate func getFilePath() -> String! {
        
        pathTag += 1
        
        if pathTag > 1000 {
            pathTag = 0
        }
        
        return NSHomeDirectory() + "/Library/Caches/\(pathTag)-\(Date().timeIntervalSince1970).wav"
    }
    
}


//// MARK: - AVAudioPlayerDelegate
extension VoiceManager:AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if let completeBlock = completeBlock {
            completeBlock()
        }
        
    }
    
}
