#
# Be sure to run `pod lib lint LSBaseModules.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LSBaseModules'
  s.version          = '0.1.0'
  s.summary          = '猎声项目基础模块（所以的模块都依赖）'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/liubitao/LSBaseModules'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liubitao' => 'liubitao@haylou.com' }
  s.source           = { :git => 'https://github.com/liubitao/LSBaseModules.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'LSBaseModules/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LSBaseModules' => ['LSBaseModules/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'SwifterSwift', '~> 5.2.0'
  s.dependency 'HandyJSON', '~> 5.0.2'
  s.dependency 'RxSwift', '~> 6.2.0'
  s.dependency 'CocoaLumberjack/Swift' , '3.7.2'
  s.dependency 'SwifterSwift', '~> 5.2.0'
  s.dependency 'RxCocoa', '~> 6.2.0'

end
