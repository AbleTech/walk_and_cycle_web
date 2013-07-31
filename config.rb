activate :directory_indexes

activate :jasmine

activate :livereload

set :css_dir, 'css'

set :js_dir, 'js'

set :images_dir, 'img'

sprockets.append_path 'components'

module RequireJS
  class << self
    def registered(app)
      app.after_build do |builder|
        exec('r.js -o build.js optimize=none');
      end
    end
    alias :included :registered
  end
end

::Middleman::Extensions.register(:requirejs, RequireJS)

# Build-specific configuration
configure :build do
  ignore "components/*"

  activate :requirejs

  activate :minify_css

  activate :minify_javascript

  # activate :asset_hash, ignore: ["components/*", "img/elevation_markers/*", "img/waypoint_markers/*", 'img/poi_markers.png', 'img/white-icon.png']

  activate :relative_assets
end
