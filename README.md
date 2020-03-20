
# react-native-my-facepp

## Getting started

`$ yarn add react-native-my-facepp`


### Manual installation


#### iOS

1. cd ios && pod install
2. target link binary with libraries 添加faceId 需要的系统framework


#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNMyFaceppPackage;` to the imports at the top of the file
  - Add `new RNMyFaceppPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-my-facepp'
  	project(':react-native-my-facepp').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-my-facepp/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-my-facepp')
  	```

## Usage
```javascript
import RNMyFacepp from 'react-native-my-facepp';

// TODO: What to do with the module?
//身份证识别
RNMyFacepp.startIdCardDetectShootPage(0,(status,imgstr)=>{
             });
```
