# react-native-faceid-upay

FaceId Upay
_Requiere Licencias_

## Installation

```NPM
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
