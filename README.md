# Front end for Walking & Cycling Journey Planner

This is the front end application for journeyplanner.org.nz (on behalf of GWRC)

### Development

## Setup

You'll need to have both [Bundler](http://bundler.io/) and [Bower](http://bower.io/) installed to load development and build dependencies.

  $ bundle install
  $ bower install

## Run

  $ middleman server

Access the running app at localhost:4567

### Production Build

If it's your first time doing a build, you'll need to setup the build directory in your local project.

  $ git clone -b build --single-branch git@github.com:AbleTech/walk_and_cycle_web.git build

This will setup an orphaned branch that contains only the compiled app.

  $ middleman build
  $ cd build
  $ git add .
  $ git commit -m 'msg'
  $ git push

This will compile the project and push it to a separate branch called build.