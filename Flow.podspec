Pod::Spec.new do |spec|

  spec.name         = "Flow"
  spec.version      = "0.1.0"
  spec.summary      = "Simple yet effective navigation library"
  spec.description  = "Simple yet effective navigation library"
  spec.homepage     = "HOME"

  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Nikolai Timonin" => "nikki.timonin@gmail.com" }

  spec.platform     = :ios, "9.0"
  spec.ios.frameworks = 'UIKit'
  spec.swift_version = '4.2'
  
  spec.source = { :git => 'https://github.com/timoninn/Flow.git', :tag => spec.version.to_s }
  spec.source_files  = "Source/", "Source/**/*.{swift}"
end
