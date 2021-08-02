Pod::Spec.new do |s|
  s.name          = 'MobilePayKit'
  s.version       = '1.0.0'

  s.summary       = 'A8C iOS Mobile payments'
  s.description   = <<-DESC
                    Handle IAP in your A8C app.
                  DESC

  s.homepage      = 'https://github.com/Automattic/MobilePay-Apple.git'
  s.license       = { :type => 'GPLv2', :file => 'LICENSE' }
  s.author        = { 'The WordPress Mobile Team' => 'mobile@wordpress.org' }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.swift_version = '5.0'

  s.source        = { :git => 'https://github.com/Automattic/MobilePay-Apple.git', :tag => s.version.to_s }
  s.module_name = "MobilePayKit"
  s.source_files = 'Source/**/*.{h,m,swift}'

end
