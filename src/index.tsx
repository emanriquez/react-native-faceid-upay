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

export function onBoarding(dataOperation: string) {
  return new Promise((resolve, reject) => {
    console.log('[NATIVE ONBOARDING CALL DOCLIVESSFLOW]');
    let json = JSON.parse(dataOperation);
    console.log('[NATIVE ONBOARDING PARAM]', dataOperation);
    try {
      FaceidUpay.docLivenessFlow(
        json.operacionId,
        dataOperation,
        (error: any, resultId: any) => {
          console.log('[NATIVE ONBOARDING]', resultId, error);

          if (error) {
            console.log('[NATIVE ONBOARDING ERROR]', error);
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
