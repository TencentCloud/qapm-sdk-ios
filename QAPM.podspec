Pod::Spec.new do |s|

  s.name         = "QAPM"
  s.version      = "5.1.1"
  s.summary      = "QAPM Summary"
  s.description  = <<-DESC
                      QAPM for iOS 
                      DESC
  s.homepage     = "https://git.code.oa.com/v_wxyawang/qapm_ios_framework"
  s.source       = { :git => "http://git.woa.com/v_wxyawang/qapm_ios_framework.git", :tag => "#{s.version}" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "v_wxyawang"
  s.ios.deployment_target = "8.0"
  s.source_files = "Headers/*.h"
  s.public_header_files  = "Headers/*.h"
  s.requires_arc = true

  s.resources    = "QAPM.framework/*.js"
  s.pod_target_xcconfig  = { 'ENABLE_BITCODE' => 'NO' }
  s.frameworks   = "CoreLocation"
  s.libraries    = "c", "c++"

  s.vendored_frameworks  = "QAPM.framework"
  
end