Pod::Spec.new do |s|
  s.name         = "CodableCache"
  s.version      = "0.1.0"
  s.summary      = "A memory and disk based cache backed by the Swift 4 Codable protocol."
  s.description  = <<-DESC
    What is Codable Cache? It's a framework that allows for seamless memory caching and disk persistence of your plain old Swift structs.
    Simply define a model and conform to Encodable – you're ready to use Codable Cache.
  DESC
  s.homepage     = "https://github.com/asowers1/CodableCache.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Andrew Sowers" => "asow123@gmail.com" }
  s.social_media_url   = "https://twitter.com/andrewsowers"
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/asowers1/CodableCache.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
