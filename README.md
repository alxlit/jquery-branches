
# jquery.branches

![](https://github.com/alxlit/jquery-branches/raw/master/example.png)

It's a plugin for creating horizontal tree-like navigation widget things. Works
well with [jquery.pjax](https://github.com/defunkt/jquery-pjax). Thoroughly
**untested**.

Call the `$().branches(options)` method on your `<ul>`'s container to set up the widget.
Subsequent calls will just refresh the widget. Here're the available options:

  * **automatic**: Try to style the connector lines automatically by looking
  at a leaf's border-left-color or background-color, in that order (default: `true`)
  * **style**: The [strokeStyles](https://developer.mozilla.org/en/Canvas_tutorial/Applying_styles_and_colors)
  for [on, off] states (default: `['#000', '#000']`)
  * **width**: The line width, same for both states (default: `1.5`)
  * **truncate**: Truncate leafs whose text is longer than this length (default: `12`)

There's a tiny example included (example.html) in the source. See it also in action
[here](http://alxlit.name).

It's MIT licensed. Have fun with it.

