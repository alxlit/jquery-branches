#
# jquery.branches
#
# It's a plugin for creating horizontal tree-like navigation widget things.
#
# Author: Alex Little
# License: MIT
# Homepage: http://github.com/alxlit/jquery-branches
#

$ = jQuery

canvasSupport = ->
  (elem = $('<canvas>')[0]) and elem.getContext?

defaults =
  automatic: true
  style: ['#000', '#000']
  width: 1.5,

  # Bad way to deal with wrapping text in nodes by limiting the number of
  # letters allowed; set to false to disable.
  truncate: 12

$.fn.branches = (cfg) ->
  root = $.data @, 'root'

  if root
    root.refresh()
  else
    root = new Leaf @
    root.init $.extend {}, defaults, cfg
    $.data @, 'root', root

  return @

class Leaf
  constructor: (item, @parent) ->
    @state = 'preinit'

    @$item = $ item
    @$anchor = $ '> a', @$item

  clear: ->
    if @canvas
      ctx = @canvas.getContext '2d'
      ctx.clearRect 0, 0, @canvas.width, @canvas.height

  connectTo: (other, clear) ->
    return unless @canvas
    @clear() if clear

    ctx = @canvas.getContext '2d'
    ctx.lineWidth = @cfg.width
    ctx.strokeStyle = @cfg.style[ +(other.state in ['on', 'focused']) ]
    ctx.beginPath()
    ctx.moveTo(
      @$anchor.outerWidth(),
      @$anchor.position().top + (@$anchor.outerHeight() / 2)
    )
    ctx.lineTo(
      @canvas.width,
      other.$anchor.position().top + (other.$anchor.outerHeight() / 2)
    )
    ctx.stroke()

  init: (@cfg) ->
    return unless @state is 'preinit'

    @state = 'initialized'

    if @parent
      @cfg = @parent.cfg
      @siblings = @parent.children

      if @cfg.truncate
        text = ''
        s = ''
        for word in @$anchor.text().split ' '
          if (tmp = text + s + word).length > @cfg.truncate
            text += '…'
            break
          text = tmp
          s = ' '
        @$anchor.text text

      @$item.hover(
        (=>
          if @state is 'off'
            @siblings.invoke 'on', 'blur'
            @focus()),
        (=>
          if @state is 'focused'
            @off()
            @siblings.invoke 'blurred', 'on')
      )

      @$anchor.click =>
        (if @state is 'on' then @children else @siblings).invoke 'off'
        @on()

    # If the parent isn't set then it's the 'root' leaf or node, which is
    # actually the top-level <ul>. Here we configure it (if automatic
    # configuration is enabled).
    else if @cfg.automatic
      @$item.addClass 'branches'

      # Pick an item, any of them, from which to take configuration values
      # from (if auto is on)
      $anchor = $ '> a', $item = $ 'li:not(li.on)', @$item

      # Use either the border or the background
      prop = 'border-left-color'
      prop = 'background-color' if $anchor.css(prop) is 'none'

      @cfg.style = []
      @cfg.style.push $anchor.css prop

      # Temporarily turn it on
      $item.addClass 'on'

      @cfg.style.push $anchor.css prop

      $item.removeClass 'on'

      # Pick a line width
      @cfg.width = $anchor.css('border-left-width') or defaults.width
      @cfg.width = parseFloat @cfg.width

    @children = new Tree $('> ul', @$item), @

    if @children.length and canvasSupport() and @parent
      @canvas = $('<canvas>')
        .appendTo(@$item)
        .attr({
          height: Math.max(@siblings.$list.height(), @children.$list.height())
          width:  @siblings.$list.width()
        })
        .get(0)

    @children.invoke 'init'

  on: ->
    if @state isnt 'on'
      @state = 'on'
      @$item.addClass 'on'
      @parent.connectTo @, true if @parent
      @children.$list.show()
      @children.invoke 'blurred', 'on'

  off: ->
    if @state isnt 'off'
      if @parent and @state in ['on', 'focused']
        @parent.clear()

      @state = 'off'

      @$item.removeClass 'on'
      @clear()

      @children.$list.hide()
      @children.invoke 'off'

  focus: ->
    if @state isnt 'focused'
      @state = 'focused'

      @$item.addClass 'on'
      @parent.connectTo @ if @parent

  blur: ->
    if @state isnt 'blurred'
      @state = 'blurred'

      @$item.removeClass 'on'
      @parent.connectTo @, true if @parent

      @children.invoke 'on', 'blur'

  refresh: ->
    @[if not @parent or @$item.hasClass 'on' then 'on' else 'off']()
    @children.invoke 'refresh'

class Tree
  constructor: (list, @parent) ->
    @$list = $ list
    @$items = $ '> li', @$list

    for item, i in @$items
      @[i] = new Leaf item, @parent

    @length = @$items.length

  invoke: (state, fn) ->
    if arguments.length is 1
      [state, fn] = [null, state]

    state = [].concat state if state

    for node, i in @
      node[fn]() if node and (not state or node.state in state)

