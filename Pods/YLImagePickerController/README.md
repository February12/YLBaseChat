# YLPhotoBrowser  

![界面](http://upload-images.jianshu.io/upload_images/6327326-c5cc489fdfbdd848.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)![界面](http://upload-images.jianshu.io/upload_images/6327326-725134e53c71022f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)



![界面](http://upload-images.jianshu.io/upload_images/6327326-e492d9b9a71d4c49.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300) ![界面](http://upload-images.jianshu.io/upload_images/6327326-6e70030c31ae0264.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)



 选择相册和拍照 支持多种裁剪
​    

# 希望
* 如果您在使用时发现错误，希望您可以 Issues 我


* 如果您发现使用的功能不够，希望您可以 Issues 我

# 导入

```swift
pod 'YLImagePickerController'
```

# 使用 

```swift
var imagePicker:YLImagePickerController?

///单选不裁剪
imagePicker = YLImagePickerController.init(imagePickerType: ImagePickerType.album, cropType: CropType.none) 
///单选方形裁剪
imagePicker = YLImagePickerController.init(imagePickerType: ImagePickerType.album, cropType: CropType.square)
///拍照不裁剪
imagePicker = YLImagePickerController.init(imagePickerType: ImagePickerType.album, cropType: CropType.circular)
///多选
imagePicker = YLImagePickerController.init(maxImagesCount: 3)
///拍照不裁剪
imagePicker = YLImagePickerController.init(imagePickerType: ImagePickerType.camera, cropType: CropType.none)
///拍照方形裁剪
imagePicker = YLImagePickerController.init(imagePickerType: ImagePickerType.camera, cropType: CropType.square)

/// 是否需要选择gif 动图  默认不需要 isNeedSelectGifImage
   
/// 导出图片
imagePicker?.didFinishPickingPhotosHandle = {(photos: [YLPhotoModel]) in
      for photo in photos {
          if photo.type == YLAssetType.photo {
              print((UIImagePNGRepresentation(photo.image!)?.count)! / 1024)
          }else if photo.type == YLAssetType.gif {
              print((photo.data?.count)! / 1024)
          }
      }
}
        
present(imagePicker!, animated: true, completion: nil)
```

# 最近更新 

- 0.0.6	添加GIF功能
- 0.0.5	添加原图功能 

