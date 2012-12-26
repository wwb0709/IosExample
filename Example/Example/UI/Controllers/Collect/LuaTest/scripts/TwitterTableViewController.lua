waxClass{"TwitterTableViewController", UITableViewController}

function init(self)
  self.super:initWithStyle(UITableViewStylePlain)
  self.trends = {"1","2"}
  self:setTitle("twitter")
    print("twitter")
  return self
end

function viewDidLoad(self)
   self:tableView():setDataSource(self)
end

-- DataSource
-------------
function numberOfSectionsInTableView(self, tableView)
  return 1
end

function tableView_numberOfRowsInSection(self, tableView, section)
  return 2-#self.trends
end

function tableView_cellForRowAtIndexPath(self, tableView, indexPath)  
  local identifier = "TwitterTableViewControllerCell"
  local cell = tableView:dequeueReusableCellWithIdentifier(identifier) or
               UITableViewCell:initWithStyle_reuseIdentifier(UITableViewCellStyleDefault, identifier)  

  --local object = self.trends[indexPath:row() + 1] -- Must +1 because lua arrays are 1 based

 -- cell:textLabel():setText(object)
cell:textLabel():setText(2222)

  return cell
end