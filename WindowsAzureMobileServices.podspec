Pod::Spec.new do |s|
  s.name         = "WindowsAzureMobileServices"
  s.version      = "0.0.2"
  s.summary      = "Client SDKs and Samples for Windows Azure Mobile Services"
  s.homepage     = "https://www.windowsazure.com/en-us/develop/mobile/"
  s.license      = 'Apache 2'

  s.author       = 'Windows Azure Team'

  s.source       = { :git => "https://github.com/WindowsAzure/azure-mobile-services.git"}
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.source_files = 'sdk/iOS/src/**/*.{h,m}'

  s.requires_arc = true
end
