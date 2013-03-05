class Logger
  colors: new class
    combinate: (foreground=@white, bold=0, background)->
      "#{if background? then "\x1B[0;#{@background+background}m" else "" }\x1B[#{bold};#{@foreground+foreground}m"
    reset: "\x1B[0m"
    normal: 0
    bold: 1
    background: 40
    foreground: 30
    black: 0
    red: 1
    green: 2
    yellow: 3
    blue: 4
    magenta: 5
    cyan: 6
    white: 7
  chars:
    tick: '\u2713'
    cross: '\u2613'
  warn_count: 0
  error_count: 0
  colored_log: true
  disable_colors:  ->
    @colored_log = false
  log: (message='', type=undefined, color=undefined, text_color=undefined) ->
    if type?
      if @colored_log
        console.log "[#{color || ''}#{type}#{@colors.reset}]\t#{text_color||''}#{message}#{@colors.reset}"
      else
        console.log "[#{type}]\t#{message}"
    else
      console.log "#{message}"

  # Output errors and console
  @exerr: (err, sout, serr)->
    Logger.instance.error err if err? and err!=""
    Logger.instance.info sout if sout? and sout!=""
    Logger.instance.error serr if serr? and serr!=""

  #Simple helper to get this static function by class instance object.
  exerr: -> Logger.exerr.apply(Logger, arguments)

  info: (message) ->
    @log message, "INFO", @colors.combinate(@colors.green, 1),
    @colors.combinate(@colors.gray)
  warn: (message) ->
    @warn_count+=1
    @log message, "WARN", @colors.combinate(@colors.yellow, 1),
    @colors.combinate(@colors.white)
  error: (message) ->
    @error_count+=1
    @log message, "ERROR", @colors.combinate(@colors.red, 1),
    @colors.combinate(@colors.white, 1)
  success: (message) ->
    @log message, @chars.tick, @colors.combinate(@colors.green, 1) ,
    @colors.combinate(@colors.white, 1)
  fail: (message) ->
    @error_count+=1
    @log message, @chars.cross, @colors.combinate(@colors.red, 1) ,
    @colors.combinate(@colors.white, 1)

Logger.instance = new Logger
exports.logger = global.logger = Logger.instance
