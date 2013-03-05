fs = require 'fs'
path = require 'path'
{print} = require 'sys'
{exec, spawn} = require 'child_process'
{logger} = require './logger.coffee'

config = global.config

task 'docs', 'Generate documentation files.', ->
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

  for file in files
    do(file=file) ->
      output_file = file.replace new RegExp("^#{config.source_dir}"), config.doc_dir
      output_file = output_file[0..output_file.lastIndexOf("/")]

      exec "docco #{file} -o #{output_file}", (err, sout, serr)->
        exerr.apply @, arguments
        logger.success "#{output_file} fully generated." if not err? and serr is ''

  output = """<html>
      <head>
        <title>#{config.project.name} v#{config.project.version} documentation</title>
        <link href="docco.css" type="text/css" rel="stylesheet">
      </head>
      <body><div id="container"><table cellspacing="0" cellpadding="0"><thead><tr><th class="docs">Browse the documentation</th></tr></thead><tbody>"""

  for file in files
    link = file.replace(new RegExp("^#{config.source_dir}/"), "").replace(/\.coffee$/, ".html")
    output +=  """<tr><td class="docs"><a href="#{link}">#{file}</a></td></tr>"""

  output += "</tbody></table></div></body></html>"
  fs.writeFileSync "#{config.doc_dir}/index.html", output