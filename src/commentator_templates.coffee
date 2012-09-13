window.CommentatorTemplates =

  comment: (comment) ->
    """
      <img src="#{comment.author.thumb_photo_url}">
      <div class="message">
        <p><b>#{comment.author.name} de #{comment.author.area_name} dijo:</b></p>
        <p>#{comment.message}</p>
      </div>
      <div id="replies">
      </div>
    """

  comments_form: """
    <label for="comment">Envía un comentario</label>
    <textarea cols="40" id="comment" name="comment" rows="20">
    </textarea>
    <input class="btn" type="submit" value="Enviar">
    """

  reply: (reply) ->
    """
      <img src="#{reply.author.thumb_photo_url}">
      <div class="message">
        <p><b>#{reply.author.name} de #{reply.author.area_name} dijo:</b></p>
        <p>#{reply.message}</p>
      </div>
    """

  replies_form: """
    <textarea id="message" rows="1"></textarea>
    <button>Enviar</button>
    """
