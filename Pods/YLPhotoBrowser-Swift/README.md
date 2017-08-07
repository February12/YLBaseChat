# YLPhotoBrowser  

![(界面)](http://upload-images.jianshu.io/upload_images/6327326-1a067526d30d6204.gif)

 仿微信图片浏览器(定义转场动画、支持本地和网络gif、拖拽取消）  
    
# 希望
    * 如果您在使用时发现错误，希望您可以 Issues 我
   	* 如果您发现使用的功能不够，希望您可以 Issues 我
  
# 导入
    
    pod 'YLPhotoBrowser-Swift' 
   
# 使用  使用 -> 简单易用,拖拽取消 
    
    var photos = [YLPhoto]()  
    photos.append(YLPhoto.addImage(image, imageUrl: nil, frame: frame))  
    let photoBrowser = YLPhotoBrowser.init(photos, index: index)  
    present(photoBrowser, animated: true, completion: nil)
    
# 介绍   

    // YLPhoto                                      
    // 为了让动画效果最佳,最好有 image(原图/缩略图) 和 frame(图片初始位置)                                           
    public class func addImage(_ image: UIImage?,imageUrl: String?,frame: CGRect?) -> YLPhoto {
        let photo = YLPhoto()
        photo.image = image
        photo.imageUrl = imageUrl ?? ""
        photo.frame = frame
        return photo
    }

    // YLPhotoBrowser                                                 
    // 初始化
    public convenience init(_ photos: [YLPhoto],index: Int) {
        self.init()
        
        self.photos = photos
        self.currentIndex = index
        
        let photo = photos[index]
        
        editTransitioningDelegate(photo)
    }

    // YLGifImage
    // 获取本地gif name 带后缀 如  1.gif
    public class func yl_gifAnimated(_ name: String) -> UIImage?       
