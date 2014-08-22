$(document).ready ->
  VoteAndComment.initialize()

VoteAndComment =
  initialize: ->

    $(document).on "click", ".vote", (event) ->
      event.preventDefault()
      value = $(@).data("votedirection")

      if $(@).hasClass("on-doodle")
        VoteAndComment.doodleId = $(@).parents(".single-doodle").data("doodleid")
        VoteAndComment.postDoodleVote(value)
      else if $(@).hasClass("on-comment")
        VoteAndComment.commentId = $(@).parents(".comment").data("commentid")
        VoteAndComment.postCommentVote(value)

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
        score = $("div[data-doodleid=#{VoteAndComment.doodleId}]").find('.this-score')
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
        score = $("div[data-commentid=#{VoteAndComment.commentId}]").find('.this-score')
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

