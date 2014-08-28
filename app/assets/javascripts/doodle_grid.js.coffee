$(document).ready ->
  RecentDoodles.initialize()

RecentDoodles =
  initialize: ->
    console.log("HEY")

    $('.doodle-grid .single-doodle').mouseenter (event) ->
      info = $(@).find(".doodle-info")
      info.show()

    $('.doodle-grid .single-doodle').mouseleave (event) ->
      info = $(@).find(".doodle-info")
      info.hide()
