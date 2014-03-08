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