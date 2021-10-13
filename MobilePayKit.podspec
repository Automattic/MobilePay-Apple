# frozen_string_literal: true

Pod::Spec.new do |s|
  s.name          = 'MobilePayKit'
  s.version       = '0.0.2'

  s.summary       = 'iOS/macOS Mobile Payments library for Automattic'
  s.description   = <<-DESC
                    Client library for making in-app purchases on iOS and macOS Automattic apps
  DESC

  s.homepage      = 'https://github.com/Automattic/MobilePay-Apple.git'
  s.license       = { type: 'GPLv2', file: 'LICENSE' }
  s.author        = { 'Automattic' => 'mobile@automattic.com' }
  s.social_media_url = 'https://twitter.com/automattic'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.swift_version = '5.0'

  s.source        = { git: 'https://github.com/Automattic/MobilePay-Apple.git', tag: s.version.to_s }
  s.source_files = 'Source/**/*.{swift}'
end
