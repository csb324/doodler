$(document).ready ->
  RecentDoodles.initialize()

RecentDoodles =
  initialize: ->
    console.log("HEY")

    $('.recent .single-doodle').mouseenter (event) ->
      info = $(@).find(".doodle-info")
      info.show()

    $('.recent .single-doodle').mouseleave (event) ->
      info = $(@).find(".doodle-info")
      info.hide()
