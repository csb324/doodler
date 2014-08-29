$(document).ready ->
  CommentAndVote.initialize()

CommentAndVote =
  initialize: ->
    $(".vote").on "click", (event) =>
      event.preventDefault()
      value = $(event.target).data("votedirection") || $(event.target).parent().data("votedirection")

      if $(event.target).hasClass("on-doodle") || $(event.target).parent().hasClass("on-doodle")
        @doodleId = $(event.target).parents(".single-doodle").data("doodleid")
        @postDoodleVote(value)

      else if $(event.target).hasClass("on-comment") || $(event.target).parent().hasClass("on-comment")
        @commentId = $(event.target).parents(".comment").data("commentid")
        @postCommentVote(value)

    $('#comment-button').click (event) =>
      event.preventDefault()
      text = $('#comment-input').val()
      @postComment(text) unless text == ""

  postDoodleVote: (value) ->
    $.ajax
      url: '/vote'
      type: 'PUT'
      dataType: 'json'
      data:
        value: value
        doodle_id: @doodleId
        votable_type: "Doodle"
      success: (data) ->
        score = $("div[data-doodleid=#{CommentAndVote.doodleId}]").find('.this-doodle-score')
        score.empty().text(data.doodle.points)

  postCommentVote: (value) ->
    $.ajax
      url: '/vote'
      type: 'PUT'
      dataType: 'json'
      data:
        value: value
        comment_id: @commentId
        votable_type: "Comment"
      success: (data) ->
        score = $("div[data-commentid=#{CommentAndVote.commentId}]").find('.this-comment-score')
        score.empty().text(data.comment.points)

  postComment: (text) =>
    @doodleId = $('.single-doodle').data("doodleid")
    $.ajax
      url: "/doodles/#{@doodleId}/comments"
      type: 'POST'
      dataType: 'json'
      data:
        body: text
        doodle_id: @doodleId
      success: (data) ->
        newComment = HandlebarsTemplates.comments(data)
        $('#comment-area').append(newComment)
        $('#comment-input').val("")

