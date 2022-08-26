require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-faceid-upay"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/emanriquez/react-native-faceid-upay.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm}"
  s.preserve_paths         = "package.json", "ios", "index.js"
  s.vendored_frameworks = 'Frameworks/CryptoSwift.xcframework', 'Frameworks/FaceTecSDK.xcframework','Frameworks/Microblink.xcframework','UBiometrics.framework'
  # s.dependency "UBiometrics"
  s.dependency "lottie-ios"
  s.dependency "React-Core"
end
