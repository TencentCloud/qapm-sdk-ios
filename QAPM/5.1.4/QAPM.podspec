Pod::Spec.new do |s|
  s.name         = "QAPM"
  s.version      = "5.1.4"
  s.summary      = "QAPM Summary"
  s.description  = <<-DESC
                      QAPM for iOS
                      DESC
  s.homepage     = "https://qapm-ios-sdk-1259741082.cos.ap-guangzhou.myqcloud.com"
  s.source       = { :http => "https://qapm-ios-sdk-1259741082.cos.ap-guangzhou.myqcloud.com/QAPM.framework-5.1.4.zip",:tag => "#{s.version}"}
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "qapm_ios"
  s.ios.deployment_target = "8.0"
  s.source_files = "QAPM.framework/Headers/*.h"
  s.public_header_files  = "QAPM.framework/Headers/*.h"
  s.requires_arc = true
  s.resources    = "QAPM.framework/*.js"
  s.pod_target_xcconfig  = { 
    'ENABLE_BITCODE' => 'NO' ,
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'arm64 x86_64 arm64e i386 armv7' 
  }
  s.frameworks   = "CoreLocation"
  s.libraries    = "c", "c++"
  s.vendored_frameworks  = "QAPM.framework"
  s.user_target_xcconfig = { 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' ,
    'VALID_ARCHS' => 'arm64 x86_64 arm64e i386 armv7' 
  }
end