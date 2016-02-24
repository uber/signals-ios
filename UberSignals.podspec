Pod::Spec.new do |s|
  s.name = 'UberSignals'
  s.version = '2.4.0'
  s.license = { :type => 'MIT' }
  s.summary = 'Signals is an eventing framework that enables you to implement the Observable pattern without using NSNotifications.'
  s.homepage = 'https://github.com/uber/signals-ios'
  s.social_media_url = 'https://twitter.com/UberEng'
  s.authors = { 'Tuomas Artman' => 'tuomas@uber.com' }
  s.source = { :git => 'https://github.com/uber/signals-ios.git', :tag => s.version }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.7'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = "#{s.name}/**/*.{h,m}"
  s.private_header_files = "#{s.name}/**/*+Internal.h"

  s.ios.frameworks = 'Foundation'
  s.osx.frameworks = 'Foundation'

end
