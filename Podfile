# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Meetup' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'SideMenu'
  pod 'OneSignal', '>= 2.5.2', '< 3.0'
  pod 'SDWebImage'
  pod 'Kingfisher', '= 3.10.4'

  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  
  pod 'LifetimeTracker'
  
  target 'MeetupTests' do
      inherit! :search_paths
      pod 'Firebase'
  end
  
end

target 'MeetupServiceExtension' do
  use_frameworks!

  pod 'OneSignal', '>= 2.5.2', '< 3.0'
end
