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
include ':ubiometrics'
project(':ubiometrics').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-faceid-upay/libs/ubiometrics')
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

## AndroidManifest.xml

```
 <uses-permission android:name="android.permission.INTERNET" />

 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.WRITE_CONTACTS" />
    <uses-permission android:name="android.permission.GET_ACCOUNTS" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="com.amazon.device.messaging.permission.RECEIVE" />
    <permission android:name="com.upayments.saborescard.permission.RECEIVE_ADM_MESSAGE" android:protectionLevel="signature" />
    <uses-permission android:name="com.upayments.saborescard.permission.RECEIVE_ADM_MESSAGE" />
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
```

## Usage

```js
import { onBoarding } from 'react-native-faceid-upay';

// ...

let dataOperation = {
   operacionId: "2222222", //numero de operacion interna
   apikey: "ke_f0f5bfacd9f64341811820f266a9bfad", //apikey privada solitiar a upayments
   url: "https://api-fct-dev.u-payments.com/bridge", //url privada, solicitar a upayments
   onboarding: true, //flujo onboarding
   gov: true, //revisara datos registro civil o gobierno
};

onBoarding(JSON.stringify(dataOperation))
  .then((result) => {
    if (result) {
      //LOS RESULTADOS VER ANEXO 1. EL RESULTADO VIENE EN FORMATO STRING
      console.log(result);
    }
  })
  .catch((err) => {
    console.log('ERROR ONBOARDING' , err.toString());
  });
```


## RESPUESTA RESULTADOS
```
{
    "token": "to_ff1ea89768e245ffb4e3fbdc3f7422ab",
    "score": "3", //MAXIMO 3
    "status": "Compare Finish", //ESTATUS FINAL
    "approbe": true, //RESULTADO GENERAL DE ONBOARDING
    "datauser": { //DATOS DE PERSONA
        "nombre": "XXXXX",
        "apellido": "XXXXX",
        "dateOfBirth": "May 28, 1985 00:00:00",
        "rut": "11.111.111-K",
        "documentNumber": "520879999",
        "profesion": "XXXXX",
        "nationality": "XXXX",
        "dateOfExpiry": "May 28, 2025 00:00:00",
        "sexo": "M" //M O F
    },
    "dataliveness": { //PRUEBAS DE VIDA RESULTADOS OBTENIDOS
        "externalDatabaseRefID": "05547212-13fc-11ed-a820-6339ebbe8c81",
        "ageEstimateGroupEnumInt": 4,
        "success": true,
        "wasProcessed": true,
        "callData": "15e79c67-a643-4055-ad0c-d2684c1cf965"
    },
    "dataregister": {. // REGISTRO DE USUARIO EN BASE PARA LOGIN
        "matchLevel": 5,
        "success": true,
        "wasProcessed": true,
        "error": false
    },
    "spoofy": { //FALSEDAD DEL DOCUMENTO
        "DIGITAL": {
            "status": true,
            "score": 0.1,
            "th": 0.99
        },
        "COPY": {
            "status": true,
            "score": 0.1,
            "th": 0.99
        },
        "FAKE": {
            "status": true,
            "score": 0.1,
            "th": 0.99
        }
    },
    "gov": { // RESULTADOS DE GOBIERNO
        "CodigoRetorno": "10000",
        "ExisteDetalle": "S",
        "CedulaVigente": "SI", //SI VIGENTE / NO BLOQUEADA
        "NumeroRegistros": "1",
        "Detalles": {
            "Detalle": [
                {
                    "RutConsultado": "011111111",
                    "DigitoVerificador": "1",
                    "TipoDocumento": "CEDUL",
                    "NumeroSerie": "520874447",
                    "Razon": "DOCUMENTO VIGENTE",
                    "Fecha": "28-05-2025 00:00:00",
                    "Fuente": "REGISTRO CIVIL"
                }
            ]
        }
    },
    "location": { //LUGAR DE ONBOARDING
        "latitude": "-33.4250626",
        "longitude": "-70.6210114"
    }
}
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
