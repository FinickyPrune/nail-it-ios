 platform :ios, '15.0'

target 'NailIt' do
  use_frameworks!

  pod 'SwiftyBeaver'
  pod 'SwiftLint'
  pod 'ProgressHUD'
  pod 'Alamofire'
  pod 'TinyConstraints'

end

target 'NailItDemo' do
  use_frameworks!

  pod 'SwiftyBeaver'
  pod 'SwiftLint'
  pod 'ProgressHUD'
  pod 'Alamofire'
  pod 'TinyConstraints'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
