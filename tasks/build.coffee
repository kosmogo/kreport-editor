# Build operation
fs = require 'fs'
path = require 'path'
{print} = require 'sys'
{exec, spawn} = require 'child_process'
{logger} = require './logger.coffee'

config = global.config

task 'build', 'Build js files from your coffees.', ->
  recursive = (dir, regexp) ->
    items = fs.readdirSync(dir)
    for it in items
      file = [dir, it].join("/")
      do(file=file) ->
        info = fs.statSync file

        if info.isDirectory()
          recursive(file, regexp)
        else if regexp.test file
          files.push file

  files = []
  recursive(config.source_dir, /\.coffee$/)
  files = files.sort (a,b) -> a.split('/').length - b.split('/').length
  exec "coffee -j #{config.output_dir}/#{config.project.name}-#{config.project.version}.js -c #{files.join(" ")}", (err, sout, serr)->
    exerr.apply @, arguments
    logger.success "Build successful `#{config.output_dir}/#{config.project.name}-#{config.project.version}.js`" if not err? and serr is ''

  files = []
  recursive(config.css_dir, /\.scss$/)

  #content = ""
  #for file in files
  #  content += fs.writeFileSync file
  #console.log content

  #sass.render
  #exec "source #{config.sass_fix} && sass #{files} > #{config.output_dir}/#{config.project.name}-#{config.project.version}.css", (err, sout, serr) ->
  #  exerr.apply @, arguments
  #  logger.success "Build successful `#{config.output_dir}/#{config.project.name}-#{config.project.version}.css`" if not err? and serr is ''

task 'sbuild', 'Build for IDE plugged in. Disable coloration on logger.', ->
  logger.colored_log = false
  invoke 'build'
