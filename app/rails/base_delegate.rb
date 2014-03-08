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