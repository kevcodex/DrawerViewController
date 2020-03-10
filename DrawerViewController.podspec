Pod::Spec.new do |s|
  s.name             = 'DrawerViewController'
  s.version          = '0.0.9'
  s.summary          = 'The drawer view controller is a simple UI used for displaying content over another view controller.'
  s.description      = <<-DESC
  The drawer view controller is a simple UI designed very similarly to what is used in Apple maps and stocks and Google Maps.
                       DESC

  s.homepage         = 'https://github.com/kevcodex/DrawerViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin Chen' => 'kevchen2@gmail.com' }
  s.source           = { :git => 'https://github.com/kevcodex/DrawerViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0', '5.1']

  s.source_files = 'Source/*.swift'
  
  s.frameworks = 'UIKit'
end
