#
# Be sure to run `pod lib lint ucloud-ufile-sdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ucloud-ufile-sdk'
  s.version          = '1.0.3'
  s.summary          = 'SDK for UCloud Ufile'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  UCloud UFile SDK for ios
                       DESC

  s.homepage         = 'https://docs.ucloud.cn/upd-docs/ufile/tools.html'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shaukwu' => 'shauk.wu@ucloud.cn' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/ucloud-ufile-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ucloud-ufile-sdk/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ucloud-ufile-sdk' => ['ucloud-ufile-sdk/Assets/*.png']
  # }

  s.public_header_files = ['ucloud-ufile-sdk/Classes/UFileAPI.h', 'ucloud-ufile-sdk/Classes/UFIleAPIUtils.h']
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
