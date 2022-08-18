import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-faceid-upay' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const FaceidUpay = NativeModules.FaceidUpay
  ? NativeModules.FaceidUpay
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return FaceidUpay.multiply(a, b);
}

export function Barcode(dataOperation: string) {
  return new Promise((resolve, reject) => {
    let json = JSON.parse(dataOperation);
    try {
      NativeModules.FaceidUpay.Barcode(
        json.operacionId,
        (error: any, resultId: any) => {
          if (error) {
            reject(error);
          } else {
            resolve(resultId);
          }
        }
      );
    } catch (e) {
      reject(e);
    }
  });
}


export function QR(dataOperation: string) {
  return new Promise((resolve, reject) => {
    let json = JSON.parse(dataOperation);
    try {
      NativeModules.FaceidUpay.QR(
        json.operacionId,
        (error: any, resultId: any) => {
          if (error) {
            reject(error);
          } else {
            resolve(resultId);
          }
        }
      );
    } catch (e) {
      reject(e);
    }
  });
}

export function onBoarding(dataOperation: string) {
  return new Promise((resolve, reject) => {
    let json = JSON.parse(dataOperation);
    try {
      NativeModules.FaceidUpay.docLivenessFlow(
        json.operacionId,
        dataOperation,
        (error: any, resultId: any) => {
        //  console.log('[NATIVE ONBOARDING]', resultId, error);

          if (error) {
            //console.log('[NATIVE ONBOARDING ERROR]', error);
            reject(error);
          } else {
            resolve(resultId);
          }
        }
      );
    } catch (e) {
      reject(e);
    }
  });
}
