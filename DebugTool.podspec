#
#  Be sure to run `pod spec lint DebugTool.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DebugTool"
  s.version      = "1.0.0"
  s.summary      = "DebugTool for iOS."

  s.homepage         = 'https://github.com/pinkpika/DebugTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pink' => 'tim801217@gmail.com' }
  s.source           = { :git => 'git@github.com:pinkpika/DebugTool.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.source_files = "DebugTool/Classes/*.{h,m,swift}", "DebugTool/Classes/**/*.{h,m,swift}"
  s.swift_version = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7']

end
