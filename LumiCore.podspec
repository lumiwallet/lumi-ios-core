#
#  Be sure to run `pod spec lint LumiCore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LumiCore"
  s.version      = "1.0.1"
  s.summary      = "The LumiCore library is an implementation of tools for working with cryptocurrencies"
  s.homepage	 = "https://github.com/lumiwallet/lumi-ios-core"

  s.license      = "MIT"
  s.author       = "Lumi wallet"

  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/lumiwallet/lumi-ios-core", :tag => "v#{s.version}" }
  s.swift_version = '5.0'

  s.ios.vendored_libraries = 'LumiCore/Crypto/OpenSSLBinaries/libcrypto-ios.a'
  s.osx.vendored_libraries = 'LumiCore/Crypto/OpenSSLBinaries/libcrypto-osx.a'

  s.source_files  = 'LumiCore/LumiCore.h', 'LumiCore/PrivateHeaders/*{h}', 'LumiCore/**/*{m,c,swift}'

  s.module_map    = 'LumiCore/LumiCore.modulemap'

  s.private_header_files = 'LumiCore/PrivateHeaders/**/*{h}'

  s.pod_target_xcconfig = { 'SWIFT_INCLUDE_PATHS' => "#{File.join(File.dirname(__FILE__))}/LumiCore/Crypto/OpenSSLBinaries/**",  
			    'LIBRARY_SEARCH_PATHS' => "#{File.join(File.dirname(__FILE__))}/LumiCore/Crypto/OpenSSLBinaries/**",
			    'HEADER_SEARCH_PATHS' => "#{File.join(File.dirname(__FILE__))}/LumiCore/Crypto/OpenSSLHeaders/**"}

end
