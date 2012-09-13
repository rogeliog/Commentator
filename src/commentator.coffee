class window.Commentator

  constructor: (args) ->
    @el  = args.el
    @url = args.url
    @poster   = args.poster || new Commentator.Poster
    @comments = args.comments || @fetch_comments()
    @comment_template = args.comment_template || CommentatorTemplates.comment
    @comments_form_template = args.comments_form_template || CommentatorTemplates.comments_form
    @reply_template = args.reply_template || CommentatorTemplates.reply
    @replies_form_template = args.replies_form_template || CommentatorTemplates.replies_form
    @set_display_form(args.display_form)

    @el.delegate ".comments_form", "submit", @add_comment

    @render_comments()

    if @display_form and @url?
      @render_form()

  set_display_form: (display_form_value) ->
    if display_form_value?
      @display_form = display_form_value
    else
      @display_form = true

  fetch_comments: ->
    @el.data "comments"

  render_comments: ->
    @comments_view = new Commentator.CommentsView(this, @comments)
    @el.append @comments_view.render()

  render_form: ->
    @form_view = new Commentator.CommentFormView(this)
    @el.append @form_view.render()

  add_comment: (e) =>
    e.preventDefault()
    if @form_view.is_comment_valid()
      @_save_comment()

  _save_comment: ()->
    data =
      message: @form_view.comment()

    @poster.post @url, data, (json) =>
      @comments.push json
      @comments_view.add_comment(json)
      @form_view.clean()

class Commentator.CommentFormView
  constructor: (@app) ->
    @el = $ "<form>"
    @el.addClass "comments_form"
    @el.delegate "textarea", "keyup", @change_state
    @el.submit @disable
    @template = @app.comments_form_template

  render: ->
    @el.html @template
    @disable()
    @el

  disable: =>
    @button().attr "disabled", true

  enable: =>
    @button().attr "disabled", false

  change_state: =>
    if @is_comment_valid()
      @enable()
    else
      @disable()

  is_comment_valid: ->
    @comment() != ""

  comment: ->
    @textarea().val()

  clean: ->
    @textarea().val ""

  textarea: ->
    @el.find "textarea"

  button: ->
    @el.find ".btn"

class Commentator.CommentItemView
  constructor: (@app, @comment) ->
    @el = $ "<div class='comment'>"
    @template = @app.comment_template

  render: ->
    @el.html @template(@comment)
    @el

  add_replies: ->
    @replies_app = new Replies
      el: @replies_el()
      comment: @comment
      reply_template: @app.reply_template
      replies_form_template: @app.replies_form_template
      display_form: @app.display_form

  replies_el: ->
    @el.find "#replies"

class Commentator.CommentsView
  constructor: (@app, @comments) ->
    @el = $ "<div id='comments'>"

  render: ->
    for comment in @comments
      @add_comment comment
    @el

  add_comment: (comment) ->
    comment_view = new Commentator.CommentItemView(@app, comment)
    @el.append comment_view.render()
    comment_view.add_replies()

class Commentator.Poster
  post: (url, data, callback) ->
    $.ajax
      type: "POST"
      url: url
      data: data
      success: (json) =>
        callback(json)

