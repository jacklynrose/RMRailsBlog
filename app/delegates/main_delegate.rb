class MainDelegate < RMRailsDelegate::Base
  def tableView(tableView, numberOfRowsInSection:section)
    self.data[:posts].count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    cell.textLabel.text = self.data[:posts][indexPath.row].title

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigate_to(DetailController, post: self.data[:posts][indexPath.row])
  end
end