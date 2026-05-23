Pod::Spec.new do |s|
  s.name             = 'gatiflow_flutter'
  s.version          = '1.0.0'
  s.summary          = 'GatiFlow Flutter SDK'
  s.homepage         = 'https://github.com/dmsyudha/gatiflow-flutter'
  s.license          = { :type => 'MIT' }
  s.author           = 'GatiFlow'
  s.source           = { :git => 'https://github.com/dmsyudha/gatiflow-flutter.git', :tag => s.version }
  s.source_files     = 'Classes/**/*.swift'
  s.ios.deployment_target = '16.0'
  s.swift_versions   = ['5.9']

  s.dependency 'Flutter'
  s.dependency 'GatiFlow'
end
