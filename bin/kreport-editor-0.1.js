//@ sourceMappingURL=kreport-editor-0.1.map
// Generated by CoffeeScript 1.6.1
(function() {
  var KReportEditor, PropertiesPanel, _ref, _ref1, _ref2, _ref3,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.KReportEditor = KReportEditor = (function(_super) {
    var cm2px, px2cm;

    __extends(KReportEditor, _super);

    KReportEditor.include(Cafeine.Plugin, Cafeine.Editable, Cafeine.Observable);

    KReportEditor.jquery_plugin("kreport");

    KReportEditor.FORMATS = {
      A6: ['10.5cm', '14.8cm'],
      A5: ['14.8cm', '21cm'],
      A4: ['21cm', '29.7cm'],
      A3: ['29.7cm', '42cm']
    };

    KReportEditor.KNOWN_FORMATS = ['A3', 'A4', 'A5', 'A6'];

    KReportEditor.UPDATE_KNOWN_FORMATS = function() {
      var k, v, _i, _len, _ref, _results;
      this.KNOWN_FORMATS = [];
      _ref = this.FORMATS;
      _results = [];
      for (v = _i = 0, _len = _ref.length; _i < _len; v = ++_i) {
        k = _ref[v];
        _results.push(this.KNOWN_FORMATS.push(k));
      }
      return _results;
    };

    KReportEditor.MENUS = {
      Report: {
        Save: "save",
        hr1: '***',
        'Properties...': 'properties'
      },
      Edit: {
        Undo: 'undo',
        Redo: 'redo'
      }
    };

    KReportEditor.CONTEXTUAL_MENU = {};

    KReportEditor.observable('save');

    KReportEditor.prototype.margin_top = '1cm';

    KReportEditor.prototype.margin_bottom = '1cm';

    KReportEditor.prototype.margin_left = '1cm';

    KReportEditor.prototype.margin_right = '1cm';

    KReportEditor.prototype.name = 'untitled report';

    KReportEditor.prototype._format = 'A4';

    KReportEditor.prototype.width = KReportEditor.FORMATS['A4'][0];

    KReportEditor.prototype.height = KReportEditor.FORMATS['A4'][1];

    KReportEditor.prototype.landscape = false;

    KReportEditor.editable({
      'name': {
        label: 'Name',
        type: 'string'
      },
      'format': {
        label: 'Format',
        type: KReportEditor.KNOWN_FORMATS
      },
      'landscape': {
        label: 'Landscape',
        type: 'boolean'
      },
      'margin_top': {
        label: 'Margin Top (cm)',
        type: 'string'
      },
      'margin_bottom': {
        label: 'Margin Bottom (cm)',
        type: 'string'
      },
      'margin_left': {
        label: 'Margin Left some azfazfazfazf text (cm)',
        type: 'string'
      },
      'margin_right': {
        label: 'Margin Right (cm)',
        type: 'string'
      }
    });

    cm2px = KReportEditor.cm2px = function(cm) {
      return parseFloat(cm) * 37.795275590551181102362204724409;
    };

    px2cm = KReportEditor.px2cm = function(px) {
      return (parseFloat(px) / 37.795275590551181102362204724409).round(0.01) + 'cm';
    };

    KReportEditor.attr('format', {
      get: function() {
        return this._format;
      },
      set: function(value) {
        var vals;
        vals = KReportEditor.FORMATS[value];
        if (vals != null) {
          this._format = value;
        } else {
          this._format = 'A4';
          vals = KReportEditor.FORMATS[this._format];
        }
        this.width = vals[0];
        return this.height = vals[1];
      }
    });

    KReportEditor.prototype.when_action = function(name) {
      if (this["_when_action_" + name] != null) {
        this["_when_action_" + name]();
        return true;
      } else {
        console.log("UNIMPLEMENTED ACTION: " + name);
        return false;
      }
    };

    KReportEditor.prototype._when_action_save = function() {
      var self;
      self = this;
      this.properties.propertiesPanel(function() {
        return this.set(self);
      });
      return true;
    };

    KReportEditor.prototype._when_action_properties = function() {
      var form,
        _this = this;
      form = this.create_edit_form({
        "class": 'form-horizontal',
        decoration: function(label, control) {
          var control_wrapper, group_wrapper;
          $(label).attr({
            "class": 'control-label'
          });
          control_wrapper = $(document.createElement('div')).attr({
            "class": 'controls'
          });
          control_wrapper.append(control);
          group_wrapper = $(document.createElement('div')).attr({
            "class": 'control-group'
          });
          group_wrapper.append([label, control_wrapper]);
          return group_wrapper[0];
        }
      });
      return this.show_dialog("Document properties", {
        content: form,
        buttons: {
          "Apply": {
            "class": "btn-primary",
            click: function() {
              form.apply_to_object();
              return _this.hide_dialog();
            }
          },
          "Cancel": {
            click: function() {
              return _this.hide_dialog();
            }
          }
        }
      });
    };

    KReportEditor.prototype.generate_menu_bar = function() {
      var brand, dd, dd_ul, k, k2, nav, navbar_inner, v, v2, _fn, _ref,
        _this = this;
      this.navbar = $(document.createElement('div')).attr({
        "class": 'navbar kreport-navbar'
      });
      navbar_inner = $(document.createElement('div')).attr({
        "class": 'navbar-inner'
      });
      this.navbar.append(navbar_inner);
      brand = $(document.createElement('a')).attr({
        "class": 'brand',
        href: '#'
      }).text('KReport');
      nav = $(document.createElement('ul')).attr({
        "class": 'nav'
      });
      $(navbar_inner).append([brand, nav]);
      _ref = KReportEditor.MENUS;
      for (k in _ref) {
        v = _ref[k];
        dd = $(document.createElement('li')).attr({
          "class": 'dropdown'
        });
        nav.append(dd);
        dd.append($(document.createElement('a')).attr({
          "class": 'dropdown-toggle',
          'data-toggle': 'dropdown',
          'href': '#'
        }).html(k + '<b class="caret"></b>'));
        dd_ul = $(document.createElement('ul')).attr({
          "class": 'dropdown-menu',
          role: 'menu',
          'aria-labelledby': 'dLabel'
        });
        dd.append(dd_ul);
        if (typeof v === 'object') {
          _fn = function(k, v, k2, v2) {
            var dd_li;
            if (v2 === '***') {
              dd_li = $(document.createElement('li')).attr({
                "class": 'divider'
              });
              return dd_ul.append(dd_li);
            } else {
              dd_li = $(document.createElement('li')).append($(document.createElement('a')).attr({
                tabindex: '-1',
                href: '#'
              }).click((function() {
                return function() {
                  return _this.when_action(v2);
                };
              })()).text(k2));
              return dd_ul.append(dd_li);
            }
          };
          for (k2 in v) {
            v2 = v[k2];
            _fn(k, v, k2, v2);
          }
        }
      }
      return this.navbar;
    };

    KReportEditor.prototype.resize = function() {
      return this.content.css({
        height: this.element.height() - this.navbar.height()
      });
    };

    KReportEditor.prototype.init_dialog = function() {
      this.dialog_title = $(document.createElement('h3'));
      this.dialog_header = $(document.createElement('div')).attr({
        "class": 'modal-header'
      }).append([
        $(document.createElement('button')).attr({
          type: 'button',
          "class": 'close',
          'data-dismiss': 'modal',
          'aria-hidden': 'true'
        }).html("&times;"), this.dialog_title
      ]);
      this.dialog_content = $(document.createElement('div')).attr({
        "class": 'modal-body'
      });
      this.dialog_footer = $(document.createElement('div')).attr({
        "class": 'modal-footer'
      });
      this.dialog = $(document.createElement('div')).attr({
        "class": 'modal fade'
      }).css({
        display: 'none'
      });
      this.dialog.append([this.dialog_header, this.dialog_content, this.dialog_footer]);
      return this.dialog;
    };

    KReportEditor.prototype.show_dialog = function(title, opts) {
      var button, name, parameters, _ref, _ref1, _ref2, _results;
      if (opts == null) {
        opts = {};
      }
      this.dialog_title.text(title);
      this.dialog.css({
        display: 'block'
      }).modal();
      opts = Cafeine.merge({
        content: '',
        buttons: {}
      }, opts);
      this.dialog_content.empty().append(opts.content);
      this.dialog_footer.empty();
      _ref = opts.buttons;
      _results = [];
      for (name in _ref) {
        parameters = _ref[name];
        button = $(document.createElement('a')).attr({
          "class": "btn " + ((_ref2 = parameters["class"]) != null ? _ref2 : '')
        }).click((_ref1 = parameters.click) != null ? _ref1 : function() {}).text(name);
        _results.push(this.dialog_footer.append(button));
      }
      return _results;
    };

    KReportEditor.prototype.hide_dialog = function() {
      return this.dialog.modal('hide');
    };

    KReportEditor.prototype.add_component = function(clazz) {
      var component;
      component = Cafeine.invoke(clazz, [$(document.createElement('div')), this]);
      this.page_content.append(component.element);
      return component.element.trigger('click');
    };

    KReportEditor.prototype.refresh_page = function() {
      var height, inner_height, inner_width, width, _ref;
      inner_width = px2cm(cm2px(this.width) - (cm2px(this.margin_left) + cm2px(this.margin_right)));
      inner_height = px2cm(cm2px(this.height) - (cm2px(this.margin_top) + cm2px(this.margin_bottom)));
      width = this.width;
      height = this.height;
      if (this.landscape) {
        _ref = [inner_height, inner_width, height, width], inner_width = _ref[0], inner_height = _ref[1], width = _ref[2], height = _ref[3];
      }
      this.page = $("#kreport-page").css({
        width: width,
        height: height
      });
      return this.page_content.css({
        'margin-left': this.margin_left,
        'margin-right': this.margin_right,
        'margin-top': this.margin_top,
        'margin-bottom': this.margin_bottom,
        width: inner_width,
        height: inner_height
      });
    };

    KReportEditor.prototype.generate_sub_menu = function(obj) {
      var in_link, k, li, ul, v, _ref;
      ul = $(document.createElement("ul")).attr({
        "class": "dropdown-menu",
        role: "menu",
        "aria-labelledby": "dLabel"
      });
      for (k in obj) {
        v = obj[k];
        li = $(document.createElement("li"));
        if (typeof v === 'undefined') {
          li.addClass('divider');
        } else if ((_ref = typeof v) === 'function' || _ref === 'string') {
          in_link = $(document.createElement("a")).attr({
            tabindex: '-1',
            href: '#'
          }).text(k);
          (function(k, v, in_link, self) {
            return in_link.on('click', function() {
              if (typeof v === 'function') {
                return v.call(self);
              } else {
                return self.when_action(v);
              }
            });
          })(k, v, in_link, this);
          li.append(in_link);
        } else {
          li.addClass('dropdown-submenu');
          li.append($(document.createElement("a")).attr({
            tabindex: '-1',
            href: '#'
          }).text(k));
          li.append(this.generate_sub_menu(v));
        }
        ul.append(li);
      }
      return ul;
    };

    KReportEditor.prototype.generate_contextual_menu = function(target) {
      var ul, _ref;
      if (target == null) {
        target = KReportEditor.CONTEXTUAL_MENU;
      }
      if ((_ref = this.contextual_menu) == null) {
        this.contextual_menu = $(document.createElement('div')).attr({
          id: "kreport-document-context-menu"
        });
      }
      this.contextual_menu.empty();
      ul = this.generate_sub_menu(target);
      return this.contextual_menu.append(ul);
    };

    KReportEditor.prototype.select = function(selectable) {
      $(".selected", this.element).removeClass("selected");
      return $(selectable).addClass("selected");
    };

    function KReportEditor(element) {
      var self,
        _this = this;
      this.element = $(element);
      this.element.empty();
      this.element.append(this.generate_menu_bar());
      this.content = $(document.createElement('div')).attr({
        id: 'kreport-content'
      });
      this.element.append(this.content);
      this.canvas = $(document.createElement('div')).attr({
        id: 'kreport-canvas'
      });
      this.toolbox = $(document.createElement('div')).attr({
        id: 'kreport-toolbox'
      });
      this.properties = $(document.createElement('div')).attr({
        id: 'kreport-properties-panel'
      });
      this.properties.propertiesPanel();
      this.toolbox.append(this.properties);
      this.content.append([this.toolbox, this.canvas]);
      this.element.append(this.content);
      this.page = $(document.createElement('div')).attr({
        id: 'kreport-page',
        'data-target': "#kreport-document-context-menu"
      });
      this.page_content = $(document.createElement('div')).attr({
        id: 'kreport-page-content'
      });
      this.element.append(this.init_dialog());
      this.page.append(this.page_content);
      this.canvas.append(this.page);
      this.element.append(this.generate_contextual_menu());
      self = this;
      this.page.contextmenu();
      this.page.data('contextmenu', KReportEditor.CONTEXTUAL_MENU);
      this.page.on('context', function(evt) {
        var item_path, menu, x, _i, _len, _results;
        item_path = [evt.mouseTarget];
        $(evt.mouseTarget).parents().each(function() {
          return item_path.push(this);
        });
        _results = [];
        for (_i = 0, _len = item_path.length; _i < _len; _i++) {
          x = item_path[_i];
          menu = $(x).data('contextmenu');
          if (typeof menu === 'object') {
            self.generate_contextual_menu(menu);
            break;
          } else if (typeof menu === 'function') {
            self.generate_contextual_menu(menu());
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }).on('click', function(evt) {
        self.select(self.page);
        return self.properties.propertiesPanel('set', self);
      });
      $('.dropdown-toggle').dropdown();
      this.resize();
      $(window).resize(function() {
        return _this.resize();
      });
      $('body').on('mousemove', function(evt) {
        _this.mouseX = evt.pageX;
        return _this.mouseY = evt.pageY;
      });
      this.when_edition_done(this.refresh_page);
    }

    return KReportEditor;

  })(Cafeine.ActiveObject);

  if ((_ref = this.KReport) == null) {
    this.KReport = {};
  }

  this.KReport.Component = (function(_super) {
    var OID, _OID;

    __extends(Component, _super);

    _OID = 0;

    OID = function() {
      return _OID++;
    };

    Component.prototype.height = 0;

    Component.prototype.remove = function() {
      return this.element.remove();
    };

    function Component(element, report) {
      var self,
        _this = this;
      this.element = element;
      this.report = report;
      this._oid = OID();
      this.element.attr({
        id: "kreport-" + this.constructor.INFO.id + "-" + this._oid,
        "class": 'kreport-component'
      });
      this.element.data('contextmenu', function(evt) {
        return typeof _this.sub_menu === "function" ? _this.sub_menu(evt) : void 0;
      });
      self = this;
      this.element.on('click', function(evt) {
        self.report.select(element);
        self.report.properties.propertiesPanel(function() {
          return this.set(self);
        });
        return evt.stopPropagation();
      });
      this.title = $(document.createElement('div')).attr({
        "class": 'kreport-component-title label label-info'
      }).html(this.constructor.INFO.name + ' <a href="#" class="remove"><i class="icon-remove icon-white"></i></a>');
      this.content = $(document.createElement('div')).attr({
        "class": 'kreport-component-content'
      });
      this.element.append([this.title, this.content]);
      this.title.find('a.remove').on('click', function() {
        if (confirm('Are you sure?')) {
          return _this.remove();
        }
      });
    }

    Component.prototype.sub_menu = function() {
      return {};
    };

    return Component;

  })(Cafeine.ActiveObject);

  if ((_ref1 = this.KReport) == null) {
    this.KReport = {};
  }

  this.KReport.StripeReportItem = (function(_super) {
    var HEIGHT, LEFT, TOP, WIDTH, X, Y;

    __extends(StripeReportItem, _super);

    X = 0;

    Y = 1;

    LEFT = 0;

    TOP = 1;

    WIDTH = 2;

    HEIGHT = 3;

    StripeReportItem.include(Cafeine.Editable);

    StripeReportItem.prototype.content = '';

    StripeReportItem.prototype.height = '0.5cm';

    StripeReportItem.prototype.width = '1.5cm';

    StripeReportItem.prototype.top = '0.5cm';

    StripeReportItem.prototype.left = '0.5cm';

    StripeReportItem.prototype.text = '';

    StripeReportItem.editable({
      content: {
        type: 'text',
        label: 'Content'
      },
      height: {
        type: 'number',
        label: 'Height'
      },
      width: {
        type: 'number',
        label: 'Width'
      },
      left: {
        type: 'number',
        label: 'Left Offset'
      },
      top: {
        type: 'number',
        label: 'Top Offset'
      },
      style: {
        type: function() {
          return ['Title', 'Content Header', 'Content Small'];
        },
        label: 'Font style'
      }
    });

    StripeReportItem.prototype.remove = function() {
      return alert('todo: remove');
    };

    StripeReportItem.prototype.refresh_element = function() {
      return this.element.css({
        width: this.width,
        height: this.height
      });
    };

    StripeReportItem.prototype.contextmenu = function() {
      var _this = this;
      return {
        'Remove item': function() {
          return _this.remove();
        }
      };
    };

    StripeReportItem.prototype.prepare_handling = function() {
      var anchor, anchors, drag_anchor, has_started_drag, k, self, start_coords, start_offset, v, _i, _len, _ref2;
      self = this;
      anchors = [this.element];
      _ref2 = this.anchors;
      for (k in _ref2) {
        v = _ref2[k];
        anchors.push(v);
      }
      has_started_drag = false;
      start_offset = [0, 0];
      start_coords = [0, 0, 0, 0];
      drag_anchor = 'center';
      for (_i = 0, _len = anchors.length; _i < _len; _i++) {
        anchor = anchors[_i];
        anchor.on('mousedown', function(evt) {
          has_started_drag = true;
          start_offset = [evt.pageX, evt.pageY];
          start_coords = [self.element.position().left, self.element.position().top, self.element.width(), self.element.height()];
          drag_anchor = $(this).attr('class').split(' ').filter(function(c) {
            return c.match(/^anchor-/);
          });
          if (drag_anchor.length > 0) {
            drag_anchor = drag_anchor[0];
            drag_anchor = drag_anchor.slice(7, +drag_anchor.length + 1 || 9e9);
          } else {
            drag_anchor = 'x';
          }
          return evt.stopPropagation();
        });
      }
      return $('body').on('mousemove', function(evt) {
        var coords, decal;
        if (!has_started_drag) {
          return;
        }
        decal = [start_offset[X] - evt.pageX, start_offset[Y] - evt.pageY];
        coords = [].concat(start_coords);
        if (~drag_anchor.indexOf('x')) {
          coords[LEFT] -= decal[X];
          coords[TOP] -= decal[Y];
        } else {
          if (~drag_anchor.indexOf('n')) {
            coords[TOP] -= decal[Y];
            coords[HEIGHT] += decal[Y];
          } else if (~drag_anchor.indexOf('s')) {
            coords[HEIGHT] -= decal[Y];
          }
          if (~drag_anchor.indexOf('e')) {
            coords[WIDTH] -= decal[X];
          } else if (~drag_anchor.indexOf('w')) {
            coords[LEFT] -= decal[X];
            coords[WIDTH] += decal[X];
          }
        }
        return self.element.css({
          left: coords[LEFT],
          top: coords[TOP],
          width: coords[WIDTH],
          height: coords[HEIGHT]
        });
      }).on('mouseup', function() {
        return has_started_drag = false;
      });
    };

    function StripeReportItem(element, band) {
      var _this = this;
      this.element = element;
      this.band = band;
      this.report = band.report;
      this.element.attr({
        "class": 'stripereport-item'
      });
      this.element.data('contextmenu', this.contextmenu());
      this.band.element.append(this.element);
      this.anchors = {};
      ['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw'].each(function(pos) {
        var anchor;
        anchor = $(document.createElement('div')).attr({
          "class": "stripe-item anchor anchor-" + pos
        });
        _this.anchors[pos] = anchor;
        return _this.element.append(anchor);
      });
      this.prepare_handling();
      this.refresh_element();
    }

    return StripeReportItem;

  })(Cafeine.ActiveObject);

  if ((_ref2 = this.KReport) == null) {
    this.KReport = {};
  }

  this.KReport.StripeReportStripe = (function(_super) {

    __extends(StripeReportStripe, _super);

    StripeReportStripe.include(Cafeine.Container, Cafeine.Editable);

    StripeReportStripe.contains('items')(function() {
      return this.validates(this.instance_of(KReport.StripeReportItem));
    });

    StripeReportStripe.prototype.position = 'data';

    StripeReportStripe.prototype.group_for = '';

    StripeReportStripe.prototype.height = '1cm';

    StripeReportStripe.editable({
      height: {
        type: 'number',
        label: 'Height'
      },
      group_for: {
        type: 'string',
        label: 'Group'
      },
      position: {
        type: ['header', 'footer', 'data']
      }
    });

    StripeReportStripe.prototype.contextmenu = function() {
      var _this = this;
      return {
        "Add field": function() {
          return _this.add_field();
        },
        "*": void 0,
        "Add stripe above": function() {
          return _this.add_stripe('before');
        },
        "Add stripe below": function() {
          return _this.add_stripe('after');
        },
        "**": void 0,
        "Remove stripe": function() {
          return _this.remove();
        },
        "Edit stripe...": function() {
          return _this.edit();
        }
      };
    };

    StripeReportStripe.prototype.add_stripe = function(position) {
      var stripe, stripe_element;
      stripe_element = $(document.createElement('div'));
      stripe = new KReport.StripeReportStripe(stripe_element, this.parent);
      this.parent.add_stripe(stripe);
      return this.element[position](stripe_element);
    };

    StripeReportStripe.prototype.add_field = function() {
      var field;
      field = new KReport.StripeReportItem($(document.createElement('div')), this);
      return this.content.append(field.element);
    };

    StripeReportStripe.prototype.edit = function() {
      var self;
      self = this;
      return self.parent.report.properties.propertiesPanel(function() {
        return this.set(self);
      });
    };

    StripeReportStripe.prototype.remove = function() {
      if (confirm('Are you sure?')) {
        this.parent.remove_stripe(this);
        return this.element.remove();
      }
    };

    StripeReportStripe.prototype.refresh_element = function() {
      this.element.css({
        height: this.height
      });
      if (this.position === 'data') {
        return this.header.html("data &infin; <small>(" + this.height + ")</small>");
      } else if (this.position === 'header') {
        return this.header.html("&#9650; " + this.group_for + " <small>(" + this.height + ")</small>");
      } else {
        return this.header.html("&#9660; " + this.group_for + " <small>(" + this.height + ")</small>");
      }
    };

    StripeReportStripe.prototype.prepare_resize_handling = function() {
      var resize_offset, resize_started, self, start_size;
      resize_offset = 0;
      resize_started = false;
      start_size = 0;
      self = this;
      this.resize_bottom.on('mousedown', function(evt) {
        resize_offset = evt.pageY;
        resize_started = true;
        return start_size = KReportEditor.cm2px(self.height);
      });
      return $('body').on('mouseup', function(evt) {
        var resize_diff;
        console.log("mouseup?!");
        if (resize_started) {
          console.log("mouse up?");
          resize_started = false;
          return resize_diff = evt.pageY - resize_offset;
        }
      }).on('mousemove', function(evt) {
        var resize_diff;
        if (resize_started) {
          resize_diff = evt.pageY - resize_offset;
          self.height = KReportEditor.px2cm(start_size + resize_diff);
          return self.refresh_element();
        }
      });
    };

    function StripeReportStripe(element, parent) {
      var self,
        _this = this;
      this.element = element;
      this.parent = parent;
      this.element.attr({
        "class": 'stripereport-stripe'
      });
      this.element.data('contextmenu', this.contextmenu());
      this.content = $(document.createElement('div')).attr({
        "class": 'stripereport-stripe-content'
      });
      this.header = $(document.createElement('div')).attr({
        "class": 'stripereport-stripe-header label label-inverse'
      });
      this.resize_bottom = $(document.createElement('div')).attr({
        "class": 'stripereport-stripe-resize'
      });
      this.element.append([this.resize_bottom, this.header, this.content]);
      this.prepare_resize_handling();
      self = this;
      this.element.on('click', function(evt) {
        console.log(self);
        self.parent.report.select(self.element);
        self.parent.report.properties.propertiesPanel(function() {
          return this.set(self);
        });
        return evt.stopPropagation();
      });
      this.when_edition_done(function() {
        return _this.refresh_element();
      });
      this.refresh_element();
    }

    return StripeReportStripe;

  })(Cafeine.ActiveObject);

  if ((_ref3 = this.KReport) == null) {
    this.KReport = {};
  }

  this.KReport.StripeReportComponent = (function(_super) {
    var OID, _OID;

    __extends(StripeReportComponent, _super);

    _OID = 0;

    OID = function() {
      return _OID++;
    };

    StripeReportComponent.INFO = {
      id: 'stripreport',
      name: 'Strip Report',
      version: '1.0'
    };

    StripeReportComponent.include(Cafeine.Editable);

    StripeReportComponent.editable({
      height: {
        type: 'number',
        label: 'Height'
      }
    });

    StripeReportComponent.prototype.sub_menu = function() {
      var _this = this;
      return {
        "Add": {
          Band: function() {
            return _this.create_stripe();
          }
        }
      };
    };

    StripeReportComponent.include(Cafeine.Container);

    StripeReportComponent.contains('stripe')(function() {
      return this.validates(this.instance_of(KReport.StripeReportStripe));
    });

    StripeReportComponent.prototype.create_stripe = function() {
      var stripe, stripe_element;
      stripe_element = $(document.createElement('div'));
      stripe = new KReport.StripeReportStripe(stripe_element, this);
      this.add_stripe(stripe);
      this.content.append(stripe_element);
      return stripe_element.trigger('click');
    };

    function StripeReportComponent(element, report) {
      StripeReportComponent.__super__.constructor.call(this, element, report);
    }

    return StripeReportComponent;

  })(KReport.Component);

  Cafeine.merge(KReportEditor.CONTEXTUAL_MENU, {
    "Add": {
      "Stripe Report": function() {
        return this.add_component(KReport.StripeReportComponent);
      }
    }
  });

  Cafeine.merge(KReportEditor.MENUS, {
    "Add": {
      "Stripe Report": function() {
        return this.add_component(KReport.StripeReportComponent);
      }
    }
  });

  PropertiesPanel = (function(_super) {

    __extends(PropertiesPanel, _super);

    PropertiesPanel.include(Cafeine.Plugin);

    PropertiesPanel.jquery_plugin('propertiesPanel');

    function PropertiesPanel(element) {
      this.element = $(element);
      this.table = $(document.createElement('table'));
      this.tbody = $(document.createElement('tbody'));
      this.table.append(this.tbody);
      this.element.empty().append(this.table).addClass('property-panel');
    }

    PropertiesPanel.prototype.set = function(target) {
      var form;
      if (target.create_edit_form == null) {
        throw new Error("target must be include ActiveObject.Editable");
      }
      form = target.create_edit_form({
        per_field_update: true,
        "class": '',
        decoration: function(label, control) {
          var td_data, td_label, tr;
          tr = $(document.createElement('tr'));
          td_label = $(document.createElement('th'));
          td_data = $(document.createElement('td'));
          $(control).css({
            width: '100%'
          }).addClass('prop-input');
          $(label).addClass('prop-label');
          td_label.append(label);
          td_data.append(control);
          tr.append([td_label, td_data]);
          return tr[0];
        }
      });
      return this.tbody.empty().append(form);
    };

    return PropertiesPanel;

  })(Cafeine.ActiveObject);

}).call(this);
