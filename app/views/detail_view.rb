class DetailView < UIScrollView
  attr_accessor :delegate, :titleLabel, :contentView

  def init
    super
    self.backgroundColor = UIColor.whiteColor
    self.titleLabel = UILabel.new.tap do |v|
      v.frame = [[20, 20], [280, 50]]
      v.font = UIFont.boldSystemFontOfSize(36)
      v.textAlignment = NSTextAlignmentCenter
    end
    self.addSubview(self.titleLabel)

    self.contentView = UILabel.new.tap do |v|
      v.frame = [[20, 70], [280, 300]]
      v.numberOfLines = 0
    end
    self.addSubview(self.contentView)
    self
  end
end