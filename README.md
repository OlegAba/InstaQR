<img align="left" width="80" height="80" src="https://github.com/OlegAba/InstaQR/blob/master/Design/Logo/InstaQRLogo.jpg" alt="app icon">

# InstaQR - Live Wallpaper Maker

<br />

<p align="center">
  <a href="https://apps.apple.com/us/app/instaqr-live-wallpaper-maker/id1514732973?ign-mpt=uo%3D4">
    <img src="https://i.ibb.co/0q0bzgK/frame.png" width="250"/>
  </a>
</p>

<p align="center">
  <a href="https://apps.apple.com/us/app/instaqr-live-wallpaper-maker/id1514732973?ign-mpt=uo%3D4">
    <img src="https://linkmaker.itunes.apple.com/en-us/badge-lrg.svg?releaseDate=2019-11-16&amp;kind=iossoftware&amp;bubble=ios_apps" width="250"/>
  </a>
</p>



InstaQR generates a live wallpaper by combining an image of your choice with a scannable QR code. The QR code stores your share action (any link such as a social media profile) and stays hidden until the live wallpaper is activated by pressing into the screen. Simply ask the person you would like to share your action with to open their camera app and point it at the QR code.

## Preview
<p align="center">
<img src="https://is1-ssl.mzstatic.com/image/thumb/Purple113/v4/6b/be/44/6bbe447b-6bad-2571-9828-24493c3eeced/pr_source.jpg/230x0w.jpg"  width=240 />
<img src="https://is4-ssl.mzstatic.com/image/thumb/Purple123/v4/d0/e1/bb/d0e1bb44-abe2-d45c-97e4-1c89ad925c19/pr_source.jpg/230x0w.jpg" width=240 />
<img src="https://is1-ssl.mzstatic.com/image/thumb/Purple123/v4/14/69/4b/14694bf7-53da-834f-3c27-08d8a81ff844/pr_source.jpg/230x0w.jpg" width=240 />  
</p>

## Installation
We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

To access the project, run the following:
```
git clone --recursive https://github.com/OlegAba/InstaQR.git
pod install
```
Make sure to open the Xcode workspace!


## Build With
[CocoaPods](https://github.com/CocoaPods/CocoaPods) - Dependency manager\
[LPLivePhotoGenerator](https://github.com/OlegAba/LPLivePhotoGenerator) - A Swift library for creating and saving Live Photos\
[UnsplashPhotoPicker](https://github.com/unsplash/unsplash-photopicker-ios) - iOS UI component that allows you to quickly search the Unsplash library\
[CropViewController](https://github.com/TimOliver/TOCropViewController) - UIViewController subclass to crop out sections of UIImage objects, as well as perform basic rotations\
[SwiftyGif](https://github.com/kirualex/SwiftyGif) - High performance and easy to use Gif engine\
[EFQRCode](https://github.com/EFPrefix/EFQRCode) - A lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/OlegAba/InstaQR/blob/master/LICENSE) file for details
