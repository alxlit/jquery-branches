
# jquery.branches

It's a plugin for creating horizontal tree-like navigation widget things. Works
well with [jquery.pjax](https://github.com/defunkt/jquery-pjax). Thoroughly
**un**tested.

Call the `branches(opt)` method on your `<ul>`'s container to set up the widget.
Subsequent calls will just refresh the widget. Here 's the config:

  * **automatic**: Try to style the connector lines automatically by looking
  at a leaf's border-left-color or background-color, in that order (default: `true`)
  * **style**: The strokeStyles for [on, off] states (default: `['#000', '#000']`)
  * **width**: The line width, same for both states (default: `1.5`)
  * **truncate**: Truncate leafs whose text is longer than this length (default: `12`)

Have fun with it.

