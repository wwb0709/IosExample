waxClass{"AppDelegate2", protocols = {"UIApplicationDelegate"}}

-- Well done! You are almost ready to run a lua app on your iPhone!
--
-- Just run the app (⌘↵) in the simulator or on a device! 
-- You will see a dull, bland "hello world" app (it is your job to spice it up.)
--
-- If your prefer using TextMate to edit the Lua code just type 
-- 'rake tm' from the command line to setup a wax TextMate project.
--
-- What's next?
-- 1. Check out some of the example apps to learn how to do
--    more complicated apps.
-- 2. Then you start writing your app!
-- 3. Let us know if you need any help at http://groups.google.com/group/iphonewax

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(0.196, 0.725, 0.702, 1))

  -- label
  local label = UILabel:initWithFrame(CGRect(0, 100, 320, 40))
  label:setFont(UIFont:boldSystemFontOfSize(30))
  label:setColor(UIColor:whiteColor())
  label:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(0.173, 0.651, 0.627, 1))
  label:setText("Hello Lua!")
  label:setTextAlignment(UITextAlignmentCenter)    
  self.window:addSubview(label)
  
  -- button
  local button = UIButton:buttonWithType(UIButtonTypeContactAdd)
  button:setFrame(CGRect(100, 200, 75, 46))
  button:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(0.173, 0.651, 0.627, 1))  
  self.window:addSubview(button)  
  
  -- view
  local view = UIView:initWithFrame(CGRect(0, 300, 320, 40))
  view:setBackgroundColor(UIColor:colorWithRed_green_blue_alpha(0.8, 0.2, 0.3, 1))
  self.window:addSubview(view)
  
  -- imageview
  local imageview = UIImageView:initWithFrame(CGRectZero)
  imageview:setBackgroundColor(clearColor)
  imageview:setImage(UIImage:imageNamed("home_edit.png"))
  imageview:setFrame(CGRect(100, 400, 75, 46))
  self.window:addSubview(imageview)
  
  self.window:makeKeyAndVisible()
  
  puts("")
  puts("-------------------------------------------------")
  puts("- You can print stuff to the console like this! -")
  puts("-------------------------------------------------")  
end