{ScrollView} = require 'atom-space-pen-views'
Todo = require './todo'
TodoView = require './todo-view'

module.exports =
class SidebarView extends ScrollView
  searchDirectories: null
  view: null

  @content: ->
    @div class: 'organized-sidebar', =>
      @div class: 'organized-sidebar-todo', =>
        @div class: 'organized-sidebar-todo-header', =>
          @h1 'Todo Items'
          @span class: 'close-button icon icon-remove-close', click: 'minimize'
        @div class: 'organized-sidebar-todo-items', =>
          @ul class: 'organized-sidebar-todo-list', tabindex: -1, outlet: 'todolist'


  # Activate is called by the main activate functionality so it can control it's
  # own interaction with the rest of the system.
  activate: (subscriptions) ->
      @subscriptions.add atom.config.observe 'organized.searchDirectories', (newValue) => @searchDirectories = newValue
      @subscriptions.add atom.config.observe 'organized.searchSkipFiles', (newValue) =>
        newValue.filter (value) =>
          not value.isEmpty()
        @searchSkipFiles = newValue

  destroy: ->
    @view.hide()
    @view.destroy()

  initialize: () ->
    super
    @view ?= atom.workspace.addRightPanel(item: @, visible: true)
    @refreshTodos()

  minimize: () ->
    @addClass 'minimize'
    @.hide 'fast'

  refreshTodos: () ->
    directories = if @searchDirectories then @searchDirectories else atom.project.getPaths()
    if @todolist
        Todo.findInDirectories directories, (todos) =>
          for todo in todos
            todoView = new TodoView(todo)
            todoView.appendTo(@todolist)
