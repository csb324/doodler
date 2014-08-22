$(document).ready ->
  VoteAndComment.initialize()

VoteAndComment =
  initialize: ->

    $(document).on "click", ".vote", (event) ->
      event.preventDefault()
      VoteAndComment.doodleId = $(@).parents(".single-doodle").data("doodleid")
      value = $(@).data("votedirection")
      VoteAndComment.postVote(value)

    $('#comment-button').click (event) =>
      event.preventDefault()
      text = $('#comment-input').val()
      @postComment(text) unless text == ""

  postVote: (value) ->
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

