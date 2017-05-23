# YLBaseChat
聊天界面封装，快速开发。

YLReplyView 文件夹 输入框的封装
![image](https://github.com/zhuyunlongYL/YLBaseChat/blob/master/RImage/1.png)

// MARK: - 子类可以重写/外部调用
extension YLReplyView{
    
    // 添加表情面板
    func efAddFacePanelView() -> UIView {
        
        let faceView:YLFaceView = Bundle.main.loadNibNamed("YLFaceView", owner: self, options: nil)?.first as! YLFaceView
        
        faceView.delegate = self
        
        return faceView
    }
    
    // 添加更多面板
    func efAddMorePanelView() -> UIView {
        let panelView = UIView()
        panelView.backgroundColor = UIColor.white
        return panelView
    }
    
    // 恢复普通状态
    func efDidRecoverReplyViewStateForNormal() {}
    
    // 恢复编辑状态
    func efDidRecoverReplyViewStateForEdit() {}
    
    // 收起输入框
    func efPackUpInputView() {
        updateReplyViewState(YLReplyViewState.normal)
    }
    
    // 录音处理
    func efStartRecording() {}
    func efCancelRecording() {}
    func efSendRecording() {}
    func efSlideUpToCancelTheRecording() {}
    func efLoosenCancelRecording() {}
    
    // 发送消息
    func efSendMessageText() {}

}
