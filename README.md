KReport editor
==============

<div style="color: #880000; font-weight:bold; font-size: big">
  <p>The project is not yet finalized!
  <p>This document show only the futures specs of the projet.
The project will tend to be used like that!
  <p>Coming Soon!
</div>


A day we were looking for a useful stripes report generator, with editor written in html/javascript.
It should provides **RAD edition tool**, would be easy to interface with **back-end**, and easy to use for rendering PDF files both in ruby and php.

We looked *LONG TIME*... and finally we built ours.

KReport is a powerful html5 stripes report edition tool, with back-end implementation in [ruby](http://github.com/kosmogo/kreport-ruby) and [php](http://github.com/kosmogo/kreport-php)

Requirement
===========

KReport Editor use theses libraries:

- (jQuery)[http://jquery.com]
- (Bootstrap)[http://twitter.github.com/bootstrap]
- (cafeine)[http://github.com/anykeyh/cafeine]

It's fully written in coffeescript, and you also need [coffeescript](http://www.coffescript.org) to build project and docco to generate the documentation. And `coffeelint` for check source as needed.

Installation
=============

1. copy `bin/` and `lib/` into your javascript folder, `css/` into your css folder
2. include lib into your webpage

        <script src="jquery-1.9.1.min.js" type="text/javascript"></script>
        <script src="bootstrap.js" type="text/javascript"></script>
        <script src="cafeine.js" type="text/javascript"></script>
        <script src="kreport-editor-0.1.js" type="text/javascript"></script>
        <link href="bootstrap.css" type="text/css" rel="stylesheet">
        <link href="kreport-editor.css" type="text/css" rel="stylesheet">

3. put this in your < body >:

        <div id="editor" style="width: 100%; height: 600px;"></div>
        <script>
          $(function() {
            $("#editor").kreport();
          });
        </script>

4. do a barrel roll!

Quick start
===========

`kreport` is bundled as a jQuery plugin.
So `$('...').kreport` will build the editor at the first call.

The selected container will be empty and fullfilled with editor component.

You can access to all editor tweak with function argument into the kreport call:

    $('...').kreport(function(){
      //Here the current scope is KReportEditor current instance!
      this.set_data_view({/* see below the data view format */})
      this.load({ /* see below the report format */ })
    })

Save/load data
==============

Of course, it's easy to integrate save/load function with the plugin:

Handle the save report action:

    $('...').kreport(function() {
      //Plug a listener onto save_called event...
      this.when_save_called(function(object){
        alert("We will save " + object)
        //Here: do your ajax call, post method etc...
      });
    });

This will be triggered every time the user click on "Report>Save"

Force the save now:

    $('...').kreport(function() {
        this.save();
    });

... Questions?

Load a report:

    someJsonData = {}
    $('...').kreport(function() {
      if(!this.load(someJsonData)) {
        alert "Ooops. Your json looks like corrupted :("
      }
    }

... Really, no questions?

Create extension
================

We built kreport for stripe reports.
But we love fun, fork and community, so we built it to be extended with other report type easily.

Take a look at our basic `Component` class, extend it, tweak and plug it!

    KReportEditor.COMPONENT.push(YourOwnComponentReport)

You can also tweak this fields:

    KReportEditor.MENUS //Menu hierarchy of the soft.
    //To add action (ex: Tools/doSomeCoolThing ):
    KReportEditor.MENUS.Tools = KReportEditor.MENUS.Tools || {}
    KReportEditor.MENUS.Tools.doSomeCoolThing = 'do_something_cool'
    KReportEditor.prototype._when_action_do_something_cool = function() {
      //Here your action.
    }


I/O Format
==========

Note all input and output data are JSON formatted.

##1. Report descriptor

TODO

##2. Data view descriptor

Data view describes the format of data for this report.
It's a simple json object formatted like this:

    {
      'data_group': {
        'field1': 'type',
        'field2': 'type2',
        'field3': 'type3'
      },
      'data_group2': {
        'field1': 'type',
        /* ... */
        'field2': 'type2'
      }
    }

The editor will use this to get informations about variables, and provides tools for making the report.

### Typical case:

We make a data view with this sql request:

    SELECT u.id as user_id, u.name as user_name, b.name as book_name, c.name as book_category FROM users u
    INNER JOIN books b ON (b.id = u.book_id)
    INNER JOIN categories c ON (c.id = b.category_id)

The JSON should be:

    {
      'user_book': {
        'user_id': 'number',
        'user_name': 'string',
        'book_name': 'string',
        'book_category': 'string'
      }
    }

Note than ours back-end implementation generate automatically a data view description for each DataView.