Pod::Spec.new do |s|
  s.name         = "MVSlidingSegmentedControl"
  s.version      = "1.0.0"
  s.summary      = "Instagram-style sliding segmented control"

  s.homepage     = "https://github.com/bizz84/MVSlidingSegmentedControl"

  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  s.author       = { "Andrea Bizzotto" => "bizz84@gmail.com" }

  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/bizz84/MVSlidingSegmentedControl.git", :tag => '1.0.0' }

  s.source_files = 'MVSlidingSegmentedControl/*.{h,m}'

  s.screenshots  = ["https://github.com/bizz84/MVSlidingSegmentedControl/raw/master/screenshot.png"]

  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'

  s.requires_arc = true

end
