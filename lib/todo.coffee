TextSearch = require('rx-text-search')

class Todo
  file: null
  line: null
  text: null

  constructor: (file, line, text) ->
    @file = file
    @line = line
    @text = text

  @findInDirectories: (directories = atom.project.getPaths(), onComplete) ->
    skipFiles = atom.config.get('organized.searchSkipFiles')
    @_findInDirectories directories, skipFiles, [], onComplete

  @_findInDirectories: (directories, skipFiles, todos, onComplete) ->
    if directories.length is 0
      onComplete(todos)
    else
      path = directories.pop()
      TextSearch.findAsPromise("(\\[TODO\\].*)$", "**/*.org", {cwd: path})
        .then (results) =>
          for result in results
            skip = false
            for partial in skipFiles
              if result.file.indexOf(partial) > -1
                skip = true
                break;
            if skip
              continue

            text = result.text
            if match = result.text.match(/(\[TODO\])\s+(.*)$/)
                text = match[2]
            todos.push(new Todo(path + "/" + result.file, result.line, text))
          @_findInDirectories(directories, skipFiles, todos, onComplete)

module.exports = Todo
