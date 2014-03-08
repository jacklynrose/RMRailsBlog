# Doing things the "Rails" way

This is a quick and dirty implementation of what I've been trying to describe in this gist: https://gist.github.com/FluffyJack/9409243

This is just a VERY simple blogging application right now which just lists some hardcoded posts

## The controllers

```ruby
# main_controller.rb

class MainController < RMRailsController::Base
  view MainView # not actually needed, will be found be default
  delegate MainDelegate # not actually needed, will be found be default
  stylesheet MainStylesheet # not actually needed, will be found be default
  title "Posts"

  def setup
    self.delegate.data[:posts] = (0..100).map do |n|
      Post.new.tap do |p|
        p.title = "Testing #{n}"
        p.content = "Testing Some Content #{n}\n" * 500
      end
    end
  end
end

# detail_controller.rb

class DetailController < RMRailsController::Base
  attr_accessor :post

  def setup
    self.title = self.post.title
    self.view.titleLabel.text = self.post.title
    self.view.contentView.text = self.post.content
  end
end
```

## The delegates

```ruby
# main_delegate.rb

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

# detail_delegate.rb

class DetailDelegate < RMRailsDelegate::Base
end
```

## The views

```ruby
# main_view.rb

class MainView < UITableView
end

# detail_view.rb

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
```

## The model

```ruby
# post.rb

class Post
  attr_accessor :title, :content
end

```

## Other stuff

I still haven't made stylesheets working yet, but I will likely just bring in [motion-stylez](https://github.com/FluffyJack/motion-stylez).

Also, this is most certainly not a fully working implementation yet, it makes some assumptions that will only work for the most basic of applications, but I'll be working on this regularly to try and push this idea forward.

I'd like to see this turn into a gem for both iOS and OS X that makes developing for both much easier, without killing any chances of accessing the Cocoa side of things.

Please share your thoughts.

## The code that makes this work

```ruby
# base_controller.rb

module RMRailsController
  class Base < UIViewController
    attr_accessor :delegate, :delegate_class, :stylesheet_class, :view_class

    def init
      super
      self.view_class = find_related_class('View')
      self.delegate_class = find_related_class('Delegate')
      self.stylesheet_class = find_related_class('Stylesheet')
      self
    end

    def loadView
      self.view = self.view_class.new
      self.delegate = self.view.delegate = self.delegate_class.new
      if self.view.class.instance_methods.include?(:dataSource)
        self.view.dataSource = self.delegate
      end
    end

    def viewWillAppear(animated)
      if self.class.instance_methods(false).include?(:setup)
        self.setup
      end
    end

    def self.view(klazz)
      send :define_method, :view_class do
        klazz
      end
    end

    def self.delegate(klazz)
      send :define_method, :delegate_class do
        klazz
      end
    end

    def self.stylesheet(klazz)
      send :define_method, :stylesheet_class do
        klazz
      end
    end

    def self.title(title)
      send :define_method, :class_title do
        title
      end
    end

    def title
      self.class_title if self.class.instance_methods(false).include?(:class_title)
    end

    private

    def find_related_class(type)
      class_string = self.class.to_s.gsub('Controller', type)
      if Object.const_defined? class_string
        Object.const_get class_string
      end
    end
  end
end

# base_delegate.rb

module RMRailsDelegate
  class Base
    attr_accessor :data

    def initialize
      self.data = {}
    end

    def navigate_to(controller_klazz, options = {})
      vc = controller_klazz.new
      options.each do |key, value|
        vc.send("#{key}=".to_sym, value)
      end
      UIApplication.sharedApplication.windows[0].rootViewController.pushViewController(vc, animated:true)
    end
  end
end
```