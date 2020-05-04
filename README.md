

<!--
Title: Image Styler
Description: A curated list of machine learning models in Core ML format.
Author: Kedan Li
-->
<p align="center">
<img src="ImageStyler/Supporting Files/Assets.xcassets/AppIcon.appiconset/1024.png" width="329" height="295"/>
</p>


[![codebeat badge](https://codebeat.co/badges/3f467f54-941b-46b2-9197-6a900ddee267)](https://codebeat.co/projects/github-com-romanmazeev-imagestyler-master)
# Image Styler
Image Styler changes the image selected by the user by applying one of the proposed styles to it using a neural network.

[![App Store](https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg)](https://apps.apple.com/us/app/image-styler/id1506490993)

## Screenshots
| iOS  | MacOS |
| ---- | ----- |
| <img src="https://i.imgur.com/06KbqVK.jpg" width="282" height="609"/>  | <img src="https://i.imgur.com/4Qz8WUd.jpg" width="550" height="609"/>  |

## Requirements
- Xcode 11
- Swift 5
- iOS 13
- MacOS 10.15

### For model training
- Python 3.6
- [TuriCreate](https://github.com/apple/turicreate)

## How to train own model
For training, the TuriCreate framework is used. To train your own model you need:
1. Move your styles images to [style](https://github.com/romanmazeev/ImageStyler/tree/master/Model/Dataset/style) folder.
2. Move the training dataset into [content](https://github.com/romanmazeev/ImageStyler/tree/master/Model/Dataset/content) folder. Photos should be similar to those that you will use in the application to apply style. I used for training a [selfie dataset](https://www.crcv.ucf.edu/data/Selfie/).
3. *[Optional]* Move the test dataset into [test](https://github.com/romanmazeev/ImageStyler/tree/master/Model/Dataset/test) folder.
4. Run [model_creator.py](https://github.com/romanmazeev/ImageStyler/blob/master/Model/model_creator.py) script to start training.

*Remember to change the styles data in the application.*
