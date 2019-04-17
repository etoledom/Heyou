#
# Be sure to run `pod lib lint Heyou.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Heyou'
  s.version          = '0.2.3'
  s.summary          = 'Alerts'
  s.swift_version    = '4.2'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Alerts library to replace UIAlertController
                       DESC

  s.homepage         = 'https://github.com/etoledom/Heyou'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'etoledom' => 'etoledom@icloud.com' }
  s.source           = { :git => 'https://github.com/etoledom/Heyou.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Heyou/Classes/**/*'
  
end
