# YLPhotoBrowser  

![界面](http://upload-images.jianshu.io/upload_images/6327326-3dc14c514c09ec06.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)![界面](http://upload-images.jianshu.io/upload_images/6327326-725134e53c71022f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)



![界面](http://upload-images.jianshu.io/upload_images/6327326-97cb07f13a9f7edf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300) ![界面](http://upload-images.jianshu.io/upload_images/6327326-6e70030c31ae0264.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)



 选择相册和拍照 支持多种裁剪
​    

# 希望
* 如果您在使用时发现错误，希望您可以 Issues 我


* 如果您发现使用的功能不够，希望您可以 Issues 我

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

imagePicker?.didFinishPickingPhotosHandle = {(images: [UIImage]) in
    for image in images {
        print(image.size)
    }
}
present(imagePicker!, animated: true, completion: nil)
```

​     