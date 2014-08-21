$(document).ready ->
  VoteAndComment.initialize()

VoteAndComment =
  initialize: ->
    $(document).on "click", ".vote", (event) ->
      event.preventDefault()
      VoteAndComment.doodleId = $(@).parents(".single-doodle").data("doodleid")
      value = $(@).data("votedirection")
      VoteAndComment.giveVote(value)

  giveVote: (value) ->
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



