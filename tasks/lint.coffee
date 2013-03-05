fs = require 'fs'
path = require 'path'
{print} = require 'sys'
{exec, spawn} = require 'child_process'
{logger} = require './logger.coffee'

task 'lint', 'Check project syntax', ->
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

  exec "coffeelint #{if logger.colored_log then "" else "--nocolor"} #{files.join(" ")}", exerr

task 'slint', 'Same as lint but without color', ->
  logger.colored_log = false
  invoke 'lint'