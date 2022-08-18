# react-native-faceid-upay

FaceId Upay
_Requiere Licencias_
_Requiere URL de pruebas y productivas_

## Installation 

```CLONE PROJECT

1. Clonar proyecto en tu sistema
2. en Package.json dejar nueva dependencia vinculada a proyecto descargado

 "react-native-faceid-upay": "https://github.com/emanriquez/react-native-faceid-upay"

4. Ejecuta yarn o npm install

5. Linkea proyecto para Android y IOS
react-native link react-native-faceid-upay
```

## Instalación ANDROID
```

1. ANDROID -  Linkear manualmente en setting.gradle en carpeta Android otras librerias requeridas
include ':deviceSecurity'
project(':deviceSecurity').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-faceid-upay/libs/deviceSecurity')
include ':ubiometrics'
project(':ubiometrics').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-faceid-upay/libs/ubiometrics')
include ':facetec'
project(':facetec').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-faceid-upay/libs/facetec')


2. archivo local.properties agregar:

org.gradle.jvmargs=-XX\:MaxHeapSize\=512m -Xmx512m

3. archivo gradle.properties agregar:

org.gradle.parallel=false
org.gradle.caching=false
org.gradle.configureondemand=false

org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=4096m -XX:+HeapDumpOnOutOfMemoryError


4.  build.gradle agregar nueva dependencia de microblink

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


5. Versiones compatible
        minSdkVersion = 22
        compileSdkVersion = 31
        targetSdkVersion = 30




```
## AndroidManifest.xml  agregar permisos necesarios 
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



## Instalación IOS
```
1. Importa FRAMEWORK siguientes en tu proyecto IOS (folder Libs/IOS)

- CryptoSwift.xcframework
- FaceTecSDK.xcframework
- Microblink.xcframework
- UBiometrics.framework



2. Vincular Framework y Libreria las cuales deben ser con Embed & Sign las 4 librerias

3.  Info.plis debes agregar los permisos siguientes:

SERVICE_KEY
Privacy - Camera Usage Description
Privacy - Location Always and When In Use Usage Description
Privacy - Location Always Usage Description
Privacy - Location When In Use Usage Description



```

## ¿Cómo Usar en ReactNativa?


```js
1. Importa la libreria a tu Vista

import { onBoarding, QR, Barcode } from 'react-native-faceid-upay';

2. Agrega la siguiente sentencia de inicialización

let dataOperation = {
   operacionId: "2222222", //Op interna Cliente
   apikey: "ke_f0f5bfacd9f64341811820f266a9bfad", //apikey privada
   url: "https://api-fct-dev.u-payments.com/bridge", //url privada
   onboarding: true, //flujo onboarding
   loginqr: false, //flujo QR
   login: false, //flujo login
   gov: true, //revisara datos registro civil o gobierno
   other:"" //datos de login u otros
};


3. Inicia llamada de servicios

//ONBOARDING / LOGIN / LOGIN QR
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



let dataOperation = {
   operacionId: "2222222", //Op interna Cliente
};

QR(JSON.stringify(dataOperation))
  .then((result) => {
    if (result) {
      //LOS RESULTADOS VER ANEXO 1. EL RESULTADO VIENE EN FORMATO STRING
      console.log(result);
    }
  })
  .catch((err) => {
    console.log('ERROR ONBOARDING' , err.toString());
  });

let dataOperation = {
   operacionId: "2222222", //Op interna Cliente
};
Barcode(JSON.stringify(dataOperation))
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


## RESPUESTA DE ONBOARDING CALL BACK (* SE RECOMIENDA INTERGRAR BACKEND DE COMPROBACIÓN DE RESULTADOS)
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

## Contribuido
Elias Manriquez <eamanriquez@gmail.com>


## Autor
Elias Manriquez <eamanriquez@gmail.com>

## License
Este proyecto está bajo la Licencia (SaaS) 
