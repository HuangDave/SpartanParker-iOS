source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
inhibit_all_warnings! # ignore all warnings from all pods
use_frameworks!

target 'SpartanParker-iOS' do
  
  pod 'AWSCognito'
  pod 'AWSCognitoAuth'
  pod 'AWSCognitoIdentityProvider'
  pod 'AWSCore', '~> 2.6.13'
  pod 'AWSDynamoDB'
  pod 'AWSLambda'
  pod 'AWSS3'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'SwiftLint'

  target 'SpartanParker-iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SpartanParker-iOSUITests' do
    inherit! :search_paths
    
    pod 'AWSCognito'
    pod 'AWSCognitoAuth'
    pod 'AWSCognitoIdentityProvider'
    pod 'AWSCore', '~> 2.6.13'
  end

end
