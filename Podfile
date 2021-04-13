# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FirestorePractice' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FirestorePractice
pod 'Firebase/Firestore'
pod 'FirebaseFirestoreSwift', '~> 7.3-beta'
pod 'Firebase/Auth'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/Google'
pod 'FirebaseUI/Facebook'
pod 'FirebaseUI/OAuth'
pod 'FirebaseUI/Email'


  target 'FirestorePracticeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FirestorePracticeUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
