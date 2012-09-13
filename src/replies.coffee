class window.Replies

  constructor: (args) ->
    @el = args.el
    @comment = args.comment
    @replies = @comment.replies || []
    @reply_template = args.reply_template
    @replies_form_template = args.replies_form_template
    @url = @comment.replies_url
    @display_form = args.display_form

    @poster  = args.poster || new Commentator.Poster

    @el.delegate "[data-link='reply']", "click", @render_form
    @el.delegate "form", "submit", @add_reply

    @render_replies()

    if @display_form and @url?
      @add_reply_link()

  add_reply_link: ->
    @reply_link = $ "<a data-link='reply' href='#'>Comentar</a>"
    @el.append @reply_link

  remove_reply_link: ->
    @reply_link.remove()
    @reply_link = null

  render_replies: ->
    @replies_view = new Replies.RepliesView(this, @replies)
    @el.append @replies_view.render()

  render_form: (e) =>
    e.preventDefault(e)
    @remove_reply_link()
    @form_view = new Replies.ReplyFormView(this)
    @el.append @form_view.render()

  add_reply: (e) =>
    e.preventDefault()
    if @form_view.is_message_valid()
      @_save_message()

  _save_message: ->
    data =
      message: @form_view.message()

    @poster.post @url, data, (json) =>
      @replies.push json
      @replies_view.add_reply(json)
      @form_view.remove()
      @add_reply_link()

class Replies.RepliesView
  constructor: (@app, @replies) ->
    @el = $ "<div id='replies_list'>"

  render: ->
    for reply in @replies
      @add_reply reply
    @el

  add_reply: (reply) ->
    view = new Replies.ReplyItemView(@app, reply)
    @el.append view.render()

class Replies.ReplyFormView
  constructor: (@app) ->
    @el = $ "<form>"
    @template = @app.replies_form_template
    @el.delegate "textarea", "click", @initialize_text_expander
    @el.delegate "textarea", "keyup", @change_state
    @el.submit @disable

  render: ->
    @el.html @template
    @disable()
    @el

  disable: =>
    @button().attr "disabled", true

  enable: ->
    @button().attr "disabled", false

  change_state: =>
    if @is_message_valid()
      @enable()
    else
      @disable()

  textarea: ->
    @el.find "textarea"

  button: ->
    @el.find "button"

  message: ->
    @textarea().val()

  clean: ->
    @textarea().val("")

  remove: ->
    @el.remove()
    @el = null

  is_message_valid: ->
    @message() != ""

  initialize_text_expander: =>
    MIN_HEIGHT = 18
    @textarea().TextAreaExpander(MIN_HEIGHT)

class Replies.ReplyItemView
  constructor: (@app, @reply) ->
    @el = $ "<div class='reply'>"
    @template = @app.reply_template

  render: ->
    @el.html @template(@reply)
    @el
