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