$(document).ready ->
  UserGraph.initialize()

UserGraph =
  initialize: ->
    @values = @pointsPerDay
    @buildGraphBox()
    @getHistoryData()

    $("#change-graph").click =>
      @values = @pointsSoFar
      @buildGraph()

  getHistoryData: ->
    @userId = $('#profile-statistics').data("doodleable-id")
    $.ajax
      url: "/users/#{@userId}/history"
      type: "GET"
      dataType: 'json'

      error: (omg) ->
        console.log(omg)
      success: (response) =>
        @ajaxData = response.data
        console.log(@ajaxData)
        @buildGraph()

  pointsPerDay: (d) ->
    d.doodle_points

  pointsSoFar: (d) ->
    d.doodle_points_so_far

  buildGraphBox: ->
    @chartContainer = d3.select("#points-chart")
    @margin = {
      top: 20,
      bottom: 20,
      right: 20,
      left: 20
    }

    @height = 200
    @width = parseInt(@chartContainer.style("width"), 10) - @margin.left - @margin.right

    d3.select(window).on("resize", =>
     @setWidths()
    )

  # I just really want it to be responsive ok
  setWidths: ->
    @width = parseInt(@chartContainer.style("width"), 10) - @margin.left - @margin.right
    @xScale.rangeRoundBands([0, @width], .1)
    @xAxis = d3.svg.axis().scale(@xScale)
      .ticks(d3.time.days, 1)
      .tickFormat(d3.time.format("%b %e"))

    @chart = d3.select("svg")

    @chart.attr("width", @width + @margin.left + @margin.right)
    @chart.selectAll(".day")
      .attr("x", (d) =>
        @xScale(@dateParser(d))
      )
      .attr("width", @xScale.rangeBand())
    @chart.select(".x.axis").call(@xAxis)

  buildGraph: ->
    @data = @ajaxData.slice().sort(@sortByDate)
    @xScale = d3.scale.ordinal()
      .domain(@data.map((d) =>
        @dateParser(d)
      ))
      .rangeRoundBands([0, @width], .1)

    @yScale = d3.scale.linear()
      .range([@height, 0])
      .domain([0, d3.max(@data, (d) =>
        @values(d)
      )])

    @xAxis = d3.svg.axis()
      .scale(@xScale)
      .ticks(d3.time.days, 1)
      .tickFormat(d3.time.format("%b %e"))

    svg = d3.select("svg")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .attr("transform", "translate(#{@margin.left}, #{@margin.top})")

    day = svg.selectAll(".day")
      .data(@data)
      .enter()
      .append("g")


    rectangle = day.append("rect")
      .attr("class", "day")
      .attr("x", (d) =>
        @xScale(@dateParser(d))
      )
      .attr("y", (d) =>
        @yScale(@values(d)) - 1
      )
      .attr("width", @xScale.rangeBand())
      .attr("height", (d) =>
        @height - @yScale(@values(d)) + 1
      )

    value = day.append("text")
      .text((d) =>
        @values(d)
      ).attr("class", "score")
      .attr("x", (d) =>
        @xScale(@dateParser(d)) + (@xScale.rangeBand() / 2))
      .attr("y", (d) =>
        @yScale(@values(d)) - 5
      )


    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0, #{@height})")
      .call(@xAxis)

  # because it's a bar graph, these are treated as ordinals
  # data should arrive in order anyways, but i'm double checking
  # bc d3 won't do it for me
  sortByDate: (a, b) =>
    if UserGraph.dateParser(a) < UserGraph.dateParser(b)
      -1
    else if UserGraph.dateParser(b) < UserGraph.dateParser(a)
      1
    else
      0

  dateParser: (d) ->
    dateFormat = d3.time.format("%Y-%m-%d")
    dateFormat.parse(d.day)
