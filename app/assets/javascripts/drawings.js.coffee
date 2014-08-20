$(document).ready ->
  Doodler.initialize()


Doodler =
  initialize: ->
    doodlesBox = $('#doodles')
    if doodlesBox.length > 0
      @getDoodles(doodlesBox.data("mission"))

  getDoodles: (missionId) ->

    $.ajax
      url: "/missions/#{missionId}"
      type: 'GET'
      dataType: 'json'
      success: (doodles) ->
        doodles.forEach (doodle) ->
          image = $('<img>').attr("src", "../assets/#{doodle.image_path}")
          $('#doodles').append(image)


