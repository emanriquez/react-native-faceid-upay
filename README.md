# react-native-faceid-upay

FaceId Upay
_Requiere Licencias_

## Installation

```CLONE PROJECT

1. Clonar proyecto en tu sistema
2. en Package.json dejar nueva dependencia vinculada a proyecto descargado

 "react-native-faceid-upay": "file:plugins-upay/react-native-faceid-upay"

4. Ejecuta yarn o npm install

5. Linkea proyecto para Android y IOS
react-native link react-native-faceid-upay

6. Linkear manualmente en setting.gradle en carpeta Android otras librerias requeridas
include ':deviceSecurity'
project(':deviceSecurity').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-faceid-upay/libs/deviceSecurity')
include ':faceIdLibRelease'
project(':faceIdLibRelease').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-faceid-upay/libs/faceIdLibRelease')
include ':facetec'
project(':facetec').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-faceid-upay/libs/facetec')


7. En Android archivo local.properties agregar:

org.gradle.jvmargs=-XX\:MaxHeapSize\=512m -Xmx512m

8. en Android archivo gradle.properties agregar:

org.gradle.parallel=false
org.gradle.caching=false
org.gradle.configureondemand=false

org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=4096m -XX:+HeapDumpOnOutOfMemoryError


9. en Andrio archivo build.gragle agregar nueva dependencia de microblink

allprojects {
    repositories {
        mavenCentral()
        mavenLocal()
        maven {
            // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
            url("$rootDir/../node_modules/react-native/android")
        }
        maven {
            // Android JSC is installed from npm
            url("$rootDir/../node_modules/jsc-android/dist")
        }

        google()
        maven { url 'https://www.jitpack.io' }
         maven { url 'https://maven.microblink.com' }
    }
}


10. Versiones compatible


        minSdkVersion = 22
        compileSdkVersion = 31
        targetSdkVersion = 30





npm install --save https://github.com/emanriquez/react-native-faceid-upay
```

## Usage

```js
import { onBoarding } from 'react-native-faceid-upay';

// ...

let dataOperation = {
  BaseURL,
  deviceKeyIdentifier,
  dLicense,
  projectSecret,
  licenseKey,
  operacionId,
};

onBoarding(JSON.stringify(dataOperation))
  .then((result) => {
    console.log('PROMISE ONBOARDING');
    console.log(result);
  })
  .catch((err) => {
    console.log('ERROR ONBOARDING');
  });
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
