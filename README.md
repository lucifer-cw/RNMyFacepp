
# react-native-my-facepp

## Getting started

`$ npm install react-native-my-facepp --save`

### Mostly automatic installation

`$ react-native link react-native-my-facepp`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-my-facepp` and add `RNMyFacepp.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNMyFacepp.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

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

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNMyFacepp.sln` in `node_modules/react-native-my-facepp/windows/RNMyFacepp.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using My.Facepp.RNMyFacepp;` to the usings at the top of the file
  - Add `new RNMyFaceppPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNMyFacepp from 'react-native-my-facepp';

// TODO: What to do with the module?
RNMyFacepp;
```
  