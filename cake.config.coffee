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
  librairies: [
    'http://code.jquery.com/jquery-1.9.1.min.js'
  ]