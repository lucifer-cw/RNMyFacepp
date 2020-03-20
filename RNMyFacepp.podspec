
Pod::Spec.new do |s|
  s.name         = "RNMyFacepp"
  s.version      = "0.0.1"
  s.summary      = "RNMyFacepp"
  s.description  = <<-DESC
                  RNMyFacepp
                   DESC
  s.homepage     = "https://github.com/lucifer-cw/RNMyFacepp.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "lucifer-cw@domain.cn" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/lucifer-cw/RNMyFacepp.git", :tag => "master" }
  s.source_files  = "ios/**/*.{h,m}"
  s.requires_arc = true
  s.vendored_libraries = 'ios/**/*.a'
  s.vendored_frameworks = 'ios/*.framework'
  s.resource     = 'ios/*.bundle'


  s.dependency "React"
  #s.dependency "others"

end
