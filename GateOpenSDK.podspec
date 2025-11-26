Pod::Spec.new do |spec|
  spec.name         = "GateOpenSDK"
  spec.version      = "1.0.0"
  spec.summary      = "A brief description of GateOpenSDK"
  spec.description  = <<-DESC
                       A longer description of GateOpenSDK framework.
                       This is a binary distribution of the GateOpenSDK SDK.
                       DESC

  spec.homepage     = "https://github.com/gate/gatepay-call-payment-sdk-iOS/GateOpenSDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Your Name" => "gatepay@gate.com" }
  
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = "13.0"
  
  # 二进制分发配置
  spec.source       = { 
    :http => "https://github.com/gate/gatepay-call-payment-sdk-iOS/releases/GateOpenSDK-1.0.0.xcframework.zip",
    :sha256 => "d4f8c8aea079e121bedd48a69ce0e1e664e5d9cd471826eea6f748885735d460"
  }
  
  spec.vendored_frameworks = "GateOpenSDK.xcframework"
  
  # 如果有资源文件
  # spec.resource_bundles = {
  #   'GateOpenSDK' => ['GateOpenSDK.xcframework/GateOpenSDK-Privacy.bundle']
  # }
  
  spec.requires_arc = true
  
  # Swift版本（如适用）
  # spec.swift_version = '5.0'
end
