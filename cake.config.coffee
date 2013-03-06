exports.config =
  project:
    name: 'kreport-editor'
    version: '0.1'
  browsers: ['firefox', 'chromium-browser']
  output_dir: 'bin'
  source_dir: 'src'
  lib_dir:    'lib'
  doc_dir:    'doc'
  test_dir:   'test'
  spec_dir:   'spec'
  css_dir:  'css'
  tasks_dir: 'tasks'
  sass_fix: '~/.rvm/gems/ruby-1.9.3-p362'
  librairies: [
    'http://code.jquery.com/jquery-1.9.1.min.js'
    'http://methvin.com/splitter/splitter.js'
  ]