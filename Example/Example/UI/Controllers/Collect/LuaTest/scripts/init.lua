-- How does this work?
-- 1.) If you created your wax project from the xcode template, you can skip to
--     step #2.
--     If you are using the wax.framework copy the rakefile into your project 
--     root like this:
--
--     ln -s wax.framework/Resources/project.rake Rakefile
--
-- 2.) Use IBOutlet and IBAction to make variables visible to IB. Look at
--     BlueController.lua and OrangeController.lua for examples of this.
--
-- 3.) From the shell, cd into your project dir and type:
--
--     rake ib
--      
--     This will register your waxClasses and their Outlets and Actions
--     with IB
--
-- 4.) Open up IB and connect the outlets and actions!

--require "StatesTable"
--require "TwitterTableViewController"
print("init")
-- these are global just to make the code smaller... IT'S GENERALLY A BAD IDEA!
--viewController = StatesTable:init(self)
--twitterController = TwitterTableViewController:init(self)

--local window = UIApplication:sharedApplication():keyWindow()
--window:addSubview(viewController:view())
--window:addSubview(twitterController:view())

--self:pushViewController_animated(viewController, true)
require "TestController"

-- these are global just to make the code smaller... IT'S GENERALLY A BAD IDEA!

testController = TestController:init()

local window = UIApplication:sharedApplication():keyWindow()



--local parentView = testController:view():superview()
UIView:beginAnimations_context(nil, nil)
UIView:setAnimationTransition_forView_cache(UIViewAnimationTransitionFlipFromRight, window, true)
window:addSubview(testController:view())
--self:view():setHidden(true)
UIView:commitAnimations()