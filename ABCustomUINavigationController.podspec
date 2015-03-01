Pod::Spec.new do |s|
 
  s.name         = "ABCustomUINavigationController"
  s.version      = "1.2.0"
  s.summary      = "Custom UINavigationController. SquaresFlips and Cube effects"
 
  s.description  = <<-DESC
                   Subclass of UINavigationController that overwrite push and pop methods to create new transitions effects. Currently it has been implemented two transition animations:
 
                    SquaresFlip
                    The screen is split in squares and each one rotates until showing the new controller. It has two animation variation: Randomly and Horizontally
 
                    Cube effect
                    The views are shown in differents sides of a cube. It has two animation variation: Horizontal and Vertical

                    Pixelate
                    The screen is split in pixels and randomly change to show the nex screen. It has two animation variation: Horizontal and Vertical
                   DESC
 
  s.homepage     = "https://github.com/andresbrun/ABCustomUINavigationController"
 
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Andres Brun" => "andresbrunmoreno@gmail.com" }
 
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/andresbrun/ABCustomUINavigationController.git", :tag => s.version }
 
  s.source_files  = 'CustomUINavigationController/**/*.{h,m}'
 
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  s.requires_arc = true
 
end