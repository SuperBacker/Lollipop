
Pod::Spec.new do |s|
  s.name             = "Lollipop"
  s.version          = "2.0.0"
  s.summary          = "Syntactic sugar for Auto Layout"
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.homepage         = "https://github.com/Meniny/Lollipop"
  s.social_media_url = 'https://meniny.cn/'
  s.license          = 'MIT'
  s.description      = <<-DESC
                        Lollipop is a syntactic sugar for Auto Layout written in Swift.
                        DESC

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'

  s.source           = { :git => "https://github.com/Meniny/Lollipop.git", :tag => s.version.to_s }
  s.source_files = 'Lollipop/Source/*'
  s.public_header_files = 'Lollipop/Source/*.h'

  s.ios.frameworks = 'Foundation', 'UIKit'
  s.tvos.frameworks = 'Foundation', 'UIKit'
  s.osx.frameworks = 'Foundation', 'AppKit'

  # s.dependency ""
end
