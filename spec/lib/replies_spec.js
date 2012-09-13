// Generated by CoffeeScript 1.3.3
(function() {

  Replies.TestRepliesPoster = (function() {

    function TestRepliesPoster() {
      this.reply = {
        id: 1,
        message: "Mi Respuesta uno",
        author: {
          name: "Margarito",
          thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229",
          area_name: "Margaritas"
        }
      };
    }

    TestRepliesPoster.prototype.post = function(url, data, callback) {
      this.reply.message = data.message;
      return callback(this.reply);
    };

    return TestRepliesPoster;

  })();

  describe("Replies", function() {
    beforeEach(function() {
      var app, args, comment_one, comment_view, reply_one;
      reply_one = {
        id: 1,
        message: "Mi Respuesta uno",
        author: {
          name: "Margarito",
          thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229",
          area_name: "Margaritas"
        }
      };
      comment_one = {
        id: 1,
        message: "Mi Comentario",
        name: "Margarito",
        author: {
          thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229",
          area_name: "Margaritas"
        },
        replies: [reply_one],
        replies_url: "/replies"
      };
      app = {
        comment_template: CommentatorTemplates.comment
      };
      comment_view = new Commentator.CommentItemView(app, comment_one);
      comment_view.render();
      args = {
        el: comment_view.replies_el(),
        comment: comment_one,
        poster: new Replies.TestRepliesPoster,
        reply_template: CommentatorTemplates.reply,
        replies_form_template: CommentatorTemplates.replies_form,
        display_form: true
      };
      return this.app = new Replies(args);
    });
    describe("at initialization", function() {
      it("should have a link to make a new reply", function() {
        return expect(this.app.el.html()).toContain("Comentar");
      });
      return it("should have replies", function() {
        expect(this.app.replies.length).toEqual(1);
        return expect(this.app.el.text()).toContain("Mi Respuesta uno");
      });
    });
    describe("clicking the reply link", function() {
      beforeEach(function() {
        return this.app.reply_link.trigger("click");
      });
      it("shows the text area to make a reply", function() {
        return expect(this.app.el.html()).toContain("textarea");
      });
      it("has a textarea of one row", function() {
        return expect(this.app.form_view.textarea().attr("rows")).toEqual("1");
      });
      it("shows a button to send the reply", function() {
        return expect(this.app.form_view.button().text()).toEqual("Enviar");
      });
      it("doesn't have a link to make a new replay", function() {
        return expect(this.app.el.html()).not.toContain("Comentar");
      });
      return it("should have a disabled button", function() {
        return expect(this.app.form_view.button().is(":disabled")).toBeTruthy();
      });
    });
    describe("after some words", function() {
      beforeEach(function() {
        this.app.reply_link.trigger("click");
        this.app.form_view.textarea().val("some words");
        return this.app.form_view.textarea().trigger("keyup");
      });
      it("should have a valid message", function() {
        return expect(this.app.form_view.is_message_valid()).toBeTruthy();
      });
      return it("should have an enabled button", function() {
        return expect(this.app.form_view.button().is(":disabled")).toBeFalsy();
      });
    });
    describe("after click send", function() {
      beforeEach(function() {
        var app;
        app = {
          replies_form_template: CommentatorTemplates.replies_form
        };
        this.form = new Replies.ReplyFormView(app);
        this.form.textarea().val("Mi Respuesta dos");
        this.form.textarea().trigger("keyup");
        return this.form.button().trigger("submit");
      });
      return it("should have a disabled button", function() {
        return expect(this.form.button().is(":disabled"));
      });
    });
    describe("send a reply", function() {
      beforeEach(function() {
        this.app.reply_link.trigger("click");
        this.app.form_view.textarea().val("Mi Respuesta dos");
        return this.app.form_view.el.trigger("submit");
      });
      it("should have a new reply", function() {
        expect(this.app.replies.length).toEqual(2);
        return expect(this.app.el.html()).toContain("Mi Respuesta dos");
      });
      it("should have no textarea", function() {
        return expect(this.app.form_view.el).toBeFalsy();
      });
      return it("should have a link to make a new reply", function() {
        return expect(this.app.el.html()).toContain("Comentar");
      });
    });
    return describe("send an empty comment", function() {
      beforeEach(function() {
        this.app.reply_link.trigger("click");
        return this.app.form_view.el.trigger("submit");
      });
      return it("should not ave a new comment", function() {
        return expect(this.app.replies.length).toEqual(1);
      });
    });
  });

}).call(this);
