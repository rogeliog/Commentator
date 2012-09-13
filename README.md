# Commentator

Comentator is a little widget that helps you to add comments to your
app.

The way to use it is:

```coffeescript
new Commentator
  el: $ "section#comments" 
  url: "/comments"
  comments: array_of_comments
  comment_template: JST["comments/comment"]
  reply_template: JST["comments/form"]
```

This will render the all the comments in the "array_of_comments" with
the "comment_template" and will render comment replies with the
"reply_template". The "url" is where the comments will be sent after submit.

Commentator expects an "array_of_comments" where every comment contains the "replies" and the "replies_url",
all other attributes in the json are attributes that you can use in your "comment_template".

```json
{
  message: "Hello World",
  author: "Norbit",
  replies: [
   { 
     message: "Reply to the world",
     author: "Erviti"
    }  
  ],
  replies_url: "/comments/3/replies"
}
```