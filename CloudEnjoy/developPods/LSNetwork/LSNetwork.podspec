#
# Be sure to run `pod lib lint LSNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LSNetwork'
  s.version          = '0.1.0'
  s.summary          = '猎声网络请求框架（基于Moya）'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/liubitao/LSNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liubitao' => 'liubitao@haylou.com' }
  s.source           = { :git => 'https://github.com/liubitao/LSNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'LSNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LSNetwork' => ['LSNetwork/Assets/*.png']
  # }
  s.dependency 'Alamofire' , '~> 5.4.4'
  s.dependency 'Moya', '~> 15.0.0'
  s.dependency 'Result', '~> 5.0.0'
  s.dependency 'HandyJSON', '~> 5.0.2'
  s.dependency 'RxSwift', '~> 6.2.0'
  s.dependency 'CocoaLumberjack/Swift' , '3.7.2'
  s.dependency 'SwifterSwift', '~> 5.2.0'

  
  s.dependency 'LSBaseModules'



end
