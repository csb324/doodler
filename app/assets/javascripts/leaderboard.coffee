$(document).ready ->
  if $('#leaderboard').length > 0
    Leaderboard.initialize()

Leaderboard = {
  initialize: ->
    @userId = $('#leaderboard').data("userid")
    @getHighScores()
    @userSet = "global_leaderboard"

    $('#global').click =>
      @userSet = "global_leaderboard"
      @redrawGraph()

    $('#friends').click =>
      @userSet = "friends_leaderboard"
      @redrawGraph()

  getHighScores: ->
    $.ajax
      url: "/users/#{@userId}/highscore"
      type: "GET"
      dataType: 'json'

      error: (omg) ->
        console.log(omg)
      success: (response) =>
        @ajaxData = response
        console.log("ajax returned....")
        console.log(@ajaxData)
        @createGraph()

  buildGraphBox: ->
    @chartContainer = d3.select("#leaderboard")
    @margin = {
      top: 20,
      bottom: 20,
      right: 20,
      left: 20
    }

    @width = parseInt(@chartContainer.style("width"), 10) - @margin.left - @margin.right

    @barHeight = 40
    @spacing = 3

    d3.select(window).on("resize", =>
      @setWidths())

  setWidths: ->
    console.log("RESIZING THE HIGH SCORES")
    # find everything width-related and reset its value
    @width = parseInt(@chartContainer.style("width"), 10) - @margin.left - @margin.right

    @svg.attr("width", @width + @margin.left + @margin.right)
    @xScale.range([@barHeight, @width])

    @svg.selectAll(".user rect").attr("width", (d) =>
      @xScale(d.points) + 1)

  createGraph: ->
    @buildGraphBox()

    @svg = d3.select('#highscores')
      .attr("width", @width + @margin.left + @margin.right)
      .attr("transform", "translate(#{@margin.left}, #{@margin.top})")

    @redrawGraph()


  redrawGraph: ->
    oldDatalength = if @data then @data.length else 0
    @data = @ajaxData[@userSet].slice().sort(@sortByPointsDescending)

    @maxValue = d3.max(@data, (d) =>
      d.points)

    @xScale = d3.scale.linear()
      .domain([0, @maxValue])
      .range([0, @width - @barHeight])

    @yScale = d3.scale.ordinal()
      .domain(d3.range(@data.length))
      .rangeBands([0, @data.length * @barHeight])

    @height = @yScale.rangeExtent()[1]

    @svg.attr("height", @height + @margin.top + @margin.bottom)

    user = @svg.selectAll(".user")
      .data(@data, (d) ->
        d.user.id )

    userEnter = user.enter()
      .append("g")
      .attr("class", "user")
      .attr("transform", "translate(0, #{@barHeight * oldDatalength})")

    userEnter.append("rect")
      .style("opacity", "0.4")
      .attr("height", @yScale.rangeBand() - @spacing)
      .attr("x", @barHeight)

    userEnter.append("image")
      .attr("xlink:href", (d) ->
        d.profile_picture_url)
      .attr("height", @yScale.rangeBand() - @spacing)
      .attr("width", @yScale.rangeBand() - @spacing)
      # nice that the profpics are always square huh?

    user.selectAll('rect')
      .transition()
      .attr("width", (d) =>
        @xScale(d.points))
      .style("fill", (d) =>
        if d.points == @maxValue
          "#F4D21F"
        else
          "#00e6b0")

    user.transition().attr("transform", (d, i) =>
      "translate(0, #{@yScale(i)})")

    userEnter.append("a")
      .attr("xlink:href", (d) ->
        "/users/#{d.user.id}" )
      .append("text")
      .attr("class", "person")
      .attr("x", 50)
      .attr("y", @barHeight / 2)
      .style("fill","#000")
      .attr("dominant-baseline", "middle")

    user.selectAll('text')
      .text((d) =>
        d.user.nickname)

    user.exit().remove()


  # freaking javascript with its need for custom sort functions
  sortByPointsDescending: (a, b) =>
    if a.points < b.points
      1
    else if b.points < a.points
      -1
    else
      0

}
