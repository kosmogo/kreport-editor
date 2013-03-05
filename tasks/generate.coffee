# Generate function.
# It will generate the directory of the app.
fs = require 'fs'
path = require 'path'
{print} = require 'sys'
{exec, spawn} = require 'child_process'
{logger} = require './logger.coffee'

exerr = global.exerr

mkdir_p = (dir) ->
  if path.existsSync(dir)
    logger.warn "#{dir} directory already exists."
    return

  exec "mkdir -p #{dir}", ->
    exerr.apply @, arguments

    if path.existsSync(dir)
      logger.success "Created directory `#{dir}`"
    else
      logger.fail "Unable to make `#{dir}`"

wget = (lib) ->
  libname = lib[lib.lastIndexOf('/')+1..-1].split('?')[0]

  if path.existsSync("#{config.lib_dir}/#{libname}")
    logger.warn "#{config.lib_dir}/#{libname} already exists."
    return
  exec "curl -s #{lib} > #{config.lib_dir}/#{libname}", ->
    exerr.apply @, arguments
    logger.success "Lib successfully saved to #{config.lib_dir}/#{libname}"

config.has_browser = config.browsers && config.browsers.length > 0
config.default_browser ?= config.browsers[0] if config.has_browser

gen_dir = ->
  #generate folders
  logger.info "Generate folders..."

  for dir in ['output_dir', 'source_dir', 'lib_dir', 'doc_dir',
    'test_dir', 'spec_dir', 'css_dir']
    if (file_path = config[dir])?
      file_path = "./#{config[dir]}" unless file_path[0] in ['.', '/']
      mkdir_p(file_path)
    else
      logger.warning "Unset config.#{dir}. We ignore."

gen_lib = ->
  logger.info "Downloading librairies"
  wget(l) for l in config.librairies

gen_index = ->
  scripts = config.librairies.slice().map (x) ->
    config.lib_dir + "/" + x[x.lastIndexOf('/')+1..-1].split('?')[0]
  scripts.push "#{config.output_dir}/#{config.project.name}-#{config.project.version}.js"
  scripts = scripts.map((x)->"""<script src="#{x}" type="text/javascript"></script>""").join("\n")
  css = """<link href="#{config.css_dir}/#{config.project.name}-#{config.project.version}.css" type="text/css" rel="stylesheet">"""

  if !path.existsSync("./index.html")
    fs.writeFileSync("./index.html",
      """<html>
        <head>
          #{scripts}
          #{css}
        </head>
        <body>
        </body>
      </html>""");
    logger.success "index.html"
  else
    logger.warn "index.html already exists."

gen_src = ->
  if !path.existsSync "#{config.source_dir}/main.coffee"
    fs.writeFileSync "#{config.source_dir}/main.coffee",
      """
      # This is the main file of your application.
      # For now you can just add your coffee code here.
      # run `cake build` after changes, and reload `index.html`
      # to enjoy your app!
      # Good luck!

      alert "Hello word!"
      """
    logger.success "#{config.source_dir}/main.coffee created"
  else
    logger.warn "#{config.source_dir}/main.coffee already exists"

gen_css = ->
  css_file = "#{config.css_dir}/#{config.project.name}.css.scss"
  if !path.existsSync css_file
    fs.writeFileSync css_file,
    """
      //Here stand your scss files.
      //scss will automaticaly build to css when you run "cake build"
    """
    logger.success "#{css_file} created"
  else
    logger.warn "#{css_file} already exists"
# Scaffolding generation
generate = (args, callback) ->
  logger.info "Generating project `#{config.project.name} v#{config.project.version}`..."
  logger.info "Using cake.config..."

  gen_dir()
  gen_lib()
  gen_index()
  gen_src()
  gen_css()

  if logger.error_count
    logger.fail "#{logger.error_count} error(s), #{logger.warn_count} warning(s)"
  else
    logger.success "success, #{logger.warn_count} warning(s)";


task 'generate', 'Generate directory architecture of your application.', generate