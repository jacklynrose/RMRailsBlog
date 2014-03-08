class DetailController < RMRailsController::Base
  attr_accessor :post

  def setup
    self.title = self.post.title
    self.view.titleLabel.text = self.post.title
    self.view.contentView.text = self.post.content
  end
end