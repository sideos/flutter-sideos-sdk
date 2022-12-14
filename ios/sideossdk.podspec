#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sideossdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sideossdk'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
  s.xcconfig = { 
    # here on LDFLAG, I had to set -l and then the library name (without lib prefix although the file name has it).
   'OTHER_LDFLAGS' => '-lc++ -lsideos-sdk -lz',
   'USER_HEADER_SEARCH_PATHS' => '"${PROJECT_DIR}/../../ios/Library"',
   "LIBRARY_SEARCH_PATHS" => '"${PROJECT_DIR}/../../ios/Library"',
 }
 s.vendored_libraries = 'libsideos-sdk'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
