#
# Be sure to run `pod lib lint XZNavigationController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#



Pod::Spec.new do |s|
  s.name             = 'XZNavigationController'
  s.version          = '1.2.7'
  s.summary          = 'iOS 支持全屏手势导航、自定义导航栏的协议框架'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  拓展了原生 UINavigationController 以支持自定义导航条、全屏手势导航的面向协议的组件
                       DESC

  s.homepage         = 'https://github.com/Xezun/XZNavigationController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xezun' => 'developer@xezun.com' }
  s.source           = { :git => 'https://github.com/Xezun/XZNavigationController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.pod_target_xcconfig   = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'XZ_FRAMEWORK=1' }
  s.swift_version         = "5.0"
  
  s.default_subspec = 'Code'
  
  s.subspec 'Code' do |ss|
    ss.source_files        = 'XZNavigationController/Code/**/*.{h,m,swift}'
    ss.public_header_files = 'XZNavigationController/Code/**/*.h'
    ss.dependency 'XZDefines/XZRuntime', '>= 1.1.0'
  end
  
 
  # s.resource_bundles = {
  #   'XZNavigationController' => ['XZNavigationController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  
  # def s.defineSubspec(name, dependencies)
  #   self.subspec name do |ss|
  #     ss.public_header_files = "XZNavigationController/Code/#{name}/**/*.h";
  #     ss.source_files        = "XZNavigationController/Code/#{name}/**/*.{h,m}";
  #     for dependency in dependencies
  #       ss.dependency dependency;
  #     end
  #   end
  # end
  
  # s.defineSubspec 'CAAnimation',        [];

end

