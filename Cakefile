#
#  Cakefile for k-report
#  @author: Yacine Petitprez (yacine@kosmogo.com)
#
fs = require 'fs'
path = require 'path'
{print} = require 'sys'
{exec, spawn} = require 'child_process'

config = global.config = require('./cake.config.coffee').config

# Output errors and console
global.exerr = (err, sout, serr)->
  logger.error err if err? and err!=""
  logger.info sout if sout? and sout!=""
  logger.error serr if serr? and serr!=""

tasks = fs.readdirSync(config.tasks_dir)
require "./#{global.config.tasks_dir}/#{task}" for task in tasks when /\.coffee$/.test task