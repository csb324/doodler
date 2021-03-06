$(document).ready ->
  if $('#profile-statistics').length > 0
    UserGraph.initialize()

UserGraph =
  initialize: ->
    @values = @startedAtTheBottomNowWereHere
    @buildGraphBox()
    @getHistoryData()

    $("#stats-options button").click (event) =>
      $("#stats-options button").removeClass("current")
      event.preventDefault()
      $(event.target).addClass("current")
      if $(event.target).is("#doodles-per-day")
        @values = @doodlesPerDay
      else if $(event.target).is("#points-per-day")
        @values = @pointsPerDay
      else if $(event.target).is("#points-over-time")
        @values = @pointsSoFar
      @redrawGraph()

  getHistoryData: ->
    @userId = $('#profile-statistics').data("doodleable-id")
    $.ajax
      url: "/users/#{@userId}/history"
      type: "GET"
      dataType: 'json'

      error: (omg) ->
        console.log(omg)
      success: (response) =>
        @ajaxData = response.history
        console.log(@ajaxData)
        @buildGraph()
        $('#doodles-per-day').click()

  startedAtTheBottomNowWereHere: (d) ->
    0

  pointsPerDay: (d) ->
    d.points_per_day

  pointsSoFar: (d) ->
    d.points_so_far

  doodlesPerDay: (d) ->
    d.doodles_per_day

  buildGraphBox: ->
    @chartContainer = d3.selectAll("#points-chart")
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

    @chart = d3.select("#userstats")

    @chart.attr("width", @width + @margin.left + @margin.right)
    @chart.selectAll(".day")
      .attr("x", (d) =>
        @xScale(@dateParser(d))
      )
      .attr("width", @xScale.rangeBand())
    @chart.select(".x.axis").call(@xAxis)

    @chart.selectAll(".score")
      .attr("x", (d) =>
        @xScale(@dateParser(d)) + (@xScale.rangeBand() / 2))

  buildGraph: ->
    @data = @ajaxData.slice().sort(@sortByDate)
    @maxValue = d3.max(@data, (d) =>
      @values(d))

    @xScale = d3.scale.ordinal()
      .domain(@data.map((d) =>
        @dateParser(d)
      ))
      .rangeRoundBands([0, @width], .1)

    @yScale = d3.scale.linear()
      .range([@height, 0])
      .domain([0, @maxValue])

    @xAxis = d3.svg.axis()
      .scale(@xScale)
      .ticks(d3.time.days, 1)
      .tickFormat(d3.time.format("%b %e"))

    svg = d3.select("#userstats")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .attr("transform", "translate(#{@margin.left}, #{@margin.top})")

    day = svg.selectAll(".day")
      .data(@data)
      .enter()
      .append("g")

    @rectangle = day.append("rect")
      .attr("class", "day")

    @rectangle
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

    @valueLabel = day.append("text")
      .attr("class", "score")
      .attr("text-anchor", "middle")

    @valueLabel
      .text((d) =>
        @values(d)
      ).attr("class", "score")
      .attr("x", (d) =>
        @xScale(@dateParser(d)) + (@xScale.rangeBand() / 2))
      .attr("y", (d) =>
        if @values(d) == @maxValue
          @yScale(@values(d)) + 20
        else
          @yScale(@values(d)) - 5
      )
      .style("fill", (d) =>
        if @values(d) == @maxValue
          "#fff"
        else
          "#000"
        )

    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0, #{@height})")
      .call(@xAxis)

  redrawGraph: ->
    @maxValue = d3.max(@data, (d) =>
      @values(d))

    @yScale = d3.scale.linear()
      .range([@height, 0])
      .domain([0, @maxValue])

    @rectangle.transition()
      .attr("y", (d) =>
        @yScale(@values(d)) - 1
      )
      .attr("height", (d) =>
        @height - @yScale(@values(d)) + 1
      )

    @valueLabel.text((d) =>
      @values(d))

    @valueLabel.transition()
      .attr("y", (d) =>
        if @values(d) == @maxValue
          @yScale(@values(d)) + 20
        else
          @yScale(@values(d)) - 5
      )
      .style("fill", (d) =>
        if @values(d) == @maxValue
          "#fff"
        else
          "#000"
        )


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
