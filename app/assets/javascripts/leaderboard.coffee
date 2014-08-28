$(document).ready ->
  if $('#leaderboard').length > 0
    Leaderboard.initialize()

Leaderboard = {
  initialize: ->
    @userId = $('#leaderboard').data("userid")
    @getHighScores()
    @userSet = "global_leaderboard"
    # @userSet = "friends_leaderboard"

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
    # find everything width-related and reset its value
    true

  createGraph: ->
    @buildGraphBox()
    @data = @ajaxData[@userSet].slice().sort(@sortByPointsDescending)
    @maxValue = d3.max(@data, (d) =>
      d.points)

    @xScale = d3.scale.linear()
      .range([0, @width])
      .domain([0, @maxValue])

    @yScale = d3.scale.ordinal()
      .domain(d3.range(@data.length))
      .rangeBands([0, @data.length * @barHeight])

    @height = @yScale.rangeExtent()[1]

    svg = d3.select('#highscores')
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .attr("transform", "translate(#{@margin.left}, #{@margin.top})")

    user = svg.selectAll(".user")
      .data(@data)
      .enter()
      .append("g")
      .attr("transform", (d, i) =>
        "translate(0, #{@yScale(i)})")

    @rectangle = user.append("rect")
      .attr("height", @yScale.rangeBand() - @spacing)
      .attr("width", (d) =>
        @xScale(d.points))
      .style("fill", "#00e6b0")
      .style("opacity", "0.4")

    @userName = user.append("text")
      .attr("class", "person")
      .attr("x", 5)
      .attr("y", @barHeight / 2)
      .style("fill","#000")

    @userName
      .text((d) =>
        d.user.nickname)








  # freaking javascript with its need for custom sort functions
  sortByPointsDescending: (a, b) =>
    if a.points < b.points
      1
    else if b.points < a.points
      -1
    else
      0


}
