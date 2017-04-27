#
# Be sure to run `pod lib lint SBTween.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SBTween"
  s.version          = "0.1.1"
  s.summary          = "Tweening library for iOS"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A functional, but work in progress tweening library for iOS. Allows for scrubbable animations. 
                       DESC

  s.homepage         = "https://github.com/SteveBarnegren/SBTween"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Steve Barnegren" => "steve.barnegren@gmail.com" }
  s.source           = { :git => "https://github.com/SteveBarnegren/SBTween.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/SteveBarnegren'

  s.ios.deployment_target = '7.0'

  s.source_files = 'SBTween/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SBTween' => ['SBTween/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
