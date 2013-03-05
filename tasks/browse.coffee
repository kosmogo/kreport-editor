# Browse operation
fs = require 'fs'
path = require 'path'
{print} = require 'sys'
{exec, spawn} = require 'child_process'
{logger} = require './logger.coffee'

config = global.config

run = (browser=config.browsers[0], callback) ->
  unless browser?
    logger.fail "No browsers found into config..."
    return

  browser = spawn browser, ['index.html']
  browser.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  browser.stdout.on 'data', (data) ->
    print data.toString()
  browser.on 'exit', (code) ->
    if code is 0
      callback?()
      logger.success "Application ended"

for browser in config.browsers
  do(browser=browser) ->
    task "run:#{browser}", "Helper task to launch browser `#{browser}`", ->
      run(browser)
