$(document).ready ->
  RecentDoodles.initialize()

RecentDoodles =
  initialize: ->
    console.log("HEY")

    $('.recent .small-6').mouseenter (event) ->
      info = $(@).find(".doodle-info")
      info.show()

    $('.recent .small-6').mouseleave (event) ->
      info = $(@).find(".doodle-info")
      info.hide()
