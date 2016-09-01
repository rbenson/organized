{View} = require 'space-pen'

class TodoView extends View
  @content: (todo) ->
    @todo = todo
    @li =>
      @a 'data-file': todo.file, 'data-line': todo.line, click: 'todoclick', todo.text

  todoclick: (event) ->
    file=event.target.dataset['file']
    line=event.target.dataset['line']
    console.log("Going to: #{file}[#{line}]")

    options =
      initialLine: (1*line)-1
      initialColumn: 0
      pending: true
    atom.workspace.open file, options



module.exports = TodoView
