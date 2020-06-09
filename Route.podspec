Pod::Spec.new do |spec|

  spec.name         = "Route"
  spec.version      = "0.9.0"
  spec.summary      = "Easy navigation in iOS application"
  spec.description  = "Easy navigation in iOS application"
  spec.homepage     = "https://github.com/timonity/Route"

  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Nikolai Timonin" => "nikki.timonin@yandex.ru" }

  spec.platform     = :ios, "9.0"
  spec.ios.frameworks = 'UIKit'
  spec.swift_version = ['4.2', '5']
  
  spec.source = { :git => 'https://github.com/timonity/Route.git', :tag => spec.version.to_s }
  spec.source_files  = "Source/", "Source/**/*.{swift}"
end
