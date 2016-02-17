# Walking & Cycling Journey Planner front end

This is the front end application for [journeyplanner.org.nz](http://www.journeyplanner.org.nz) (on behalf of GWRC)

## Development

### Setup

You'll need to have the following installed to load development and build dependencies:
* [Bundler](http://bundler.io/)
* [Bower](http://bower.io/)
* [RequireJS](http://requirejs.org/docs/optimization.html)

    $ bundle install
    $ bower install

### Run

    $ bundle exec middleman server

Go to [localhost:4567](http://localhost:4567) in your browser

## Production Build

### First time?

You'll need to setup the build directory in your local project.

      $ git clone -b build --single-branch git@github.com:AbleTech/walk_and_cycle_web.git build

This command will setup an orphaned branch that contains only the compiled app.

### Compile and push

    $ bundle exec middleman build
    $ cd build
    $ git add .
    $ git commit -m 'msg'
    $ git push

This will compile the project and push it to a separate branch called build.

## Deployment

Please refer to the [main app's README](https://github.com/AbleTech/gwrc_walking_and_cycling/blob/master/README.md#deployment) for deployment instructions.
