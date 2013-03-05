# Build operation
fs = require 'fs'
path = require 'path'
{print} = require 'sys'
{exec, spawn} = require 'child_process'
{logger} = require './logger.coffee'

config = global.config

task 'build', 'Build js files from your coffees.', ->
  files = []
  recursive = (dir) ->
    items = fs.readdirSync(dir)
    for it in items
      file = [dir, it].join("/")
      do(file=file) ->
        info = fs.statSync file

        if info.isDirectory()
          recursive(file)
        else if /\.coffee$/.test file
          files.push file

  recursive(config.source_dir)

  exec "coffee -j bin/#{config.project.name}-#{config.project.version}.js -c #{files.join(" ")}", (err, sout, serr)->
    exerr.apply @, arguments
    logger.success "Build successful `bin/#{config.project.name}-#{config.project.version}.js`" if not err? and serr is ''

task 'sbuild', 'Build for IDE plugged in. Disable coloration on logger.', ->
  logger.colored_log = false
  invoke 'build'
