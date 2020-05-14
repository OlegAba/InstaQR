# InstaQR - Share Action Live Wallpaper Maker

InstaQR generates a live wallpaper by combining an image of your choice with a scannable QR code. The QR code stores your share action (any link such as a social media profile) and stays hidden until the live wallpaper is activated by pressing into the screen.Most smartphones nowadays natively support the scanning of QR codes which allows you to share anything, all without leaving your lock screen. Simply ask the person you would like to share your action with to open their camera app and point it at the QR code.

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
