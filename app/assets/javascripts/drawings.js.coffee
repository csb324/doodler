$(document).ready ->
  ViewAndCreateDoodles.initialize()

ViewAndCreateDoodles =
  initialize: ->
    doodlesBox = $('#doodles')
    if doodlesBox.length > 0
      @missionId = doodlesBox.data("mission")
      @getDoodles()

    $('.buttons').on "click", "#begin-drawing", (event) =>
      event.preventDefault()
      @initializeDrawing()

  getDoodles: ->
    @createDoodleButton()
    thisMission = "/missions/#{@missionId}"
    $.ajax
      url: thisMission
      type: 'GET'
      dataType: 'json'
      success: (doodles) ->
        $('#doodles').empty()

        doodles.forEach (doodle) ->
          oneDoodle = HandlebarsTemplates.doodles(doodle)
          $('#doodles').append(oneDoodle)

  createDoodleButton: ->
    createDoodle = $('<button>').attr("id", "begin-drawing").text("doodle it!")
    $('.buttons').empty()
    $('#doodleit').append(createDoodle)

  initializeDrawing: ->
    console.log("drawing area initialized")
    @paint = false;
    @clickX = []
    @clickY = []
    @clickDrag = []

    if @interval
      clearInterval(@interval)

    @drawingEnvironment()

  drawingEnvironment: ->
    console.log("creating the drawing environment")
    myCanvas = $('<canvas>').attr("id", "my-canvas")
    $('#doodles').empty().append(myCanvas)

    @context = myCanvas[0].getContext('2d')

    showButton = $('<button>').attr("id", "show-this").text("show")
    startOver = $('<button>').attr("id", "start-over").text("start over")
    goBack = $('<button>').attr("id", "go-back").text("go back")
    timer = $('<div>').attr("id", "timer")

    @startTimer()


    $('.buttons').empty()
    $('#finish-doodle')
      .append(showButton)
      .append(startOver)
      .append(goBack)
      .append(timer)

    showButton.click (event) =>
      event.preventDefault()
      @finishDrawing()

    startOver.click (event) =>
      event.preventDefault()
      @initializeDrawing()

    goBack.click (event) =>
      event.preventDefault()
      @getDoodles()


    myCanvas[0].width = 500
    myCanvas[0].height = 500

    myCanvas.mousedown (event) ->
      # $(this).css('cursor', 'none')
      mouseX = event.pageX - this.offsetLeft
      mouseY = event.pageY - this.offsetTop
      ViewAndCreateDoodles.paint = true

      ViewAndCreateDoodles.addClick(mouseX, mouseY)

    myCanvas.mousemove (event) ->
      if ViewAndCreateDoodles.paint
        ViewAndCreateDoodles.addClick(event.pageX - this.offsetLeft, event.pageY - this.offsetTop, true)

    myCanvas.mouseup (event) =>
      @paint = false

    myCanvas.mouseleave (event) =>
      @paint = false


  addClick: (x, y, dragging) ->
    console.log("adding a click")
    this.clickY.push(y)
    this.clickX.push(x)
    this.clickDrag.push(dragging)

  redraw: ->
    this.context.clearRect(0, 0, this.context.canvas.width, this.context.canvas.height)
    this.context.strokeStyle = "#000"
    this.context.lineJoin = "round"
    this.context.lineWidth = 5

    for value, i in this.clickX
      this.context.beginPath()

      if this.clickDrag[i] && i
        this.context.moveTo(this.clickX[i-1], this.clickY[i-1]);
      else
        this.context.moveTo(value-1, this.clickY[i]);

      this.context.lineTo(value, this.clickY[i])
      this.context.closePath()

      this.context.stroke()

  finishDrawing: ->
    clearInterval(@interval)

    window.seconds = 0
    @redraw()
    $('.buttons').empty()
    $('#my-canvas')[0].style.webkitFilter = "blur(25px)"
    @addConfirmButtons()

  addConfirmButtons: ->
    buttonsContainer = $('<div>')
    finishButton = $('<button>').attr("id", "confirm").text("submit!")
    startOverButton = $('<button>').attr("id", "nevermind").text("start over")

    buttonsContainer.append(finishButton).append(startOverButton)

    buttonsContainer.css("position", "absolute").css("left", "200px").css("top", "200px")
    $('#doodles').append(buttonsContainer)

    finishButton.click (event) =>
      event.preventDefault()
      @saveImage()

    startOverButton.click (event) =>
      event.preventDefault()
      @initializeDrawing()

  saveImage: ->
    drawingData = $('#my-canvas')[0].toDataURL()

    $.ajax
      url: "/missions/#{@missionId}/doodles"
      type: "POST"
      dataType: 'json'
      data:
        doodle:
          imagedata: drawingData
          mission_id: @missionId
      error: ->
        errormessage = $('<div>').text("oh no something went wrong")
        $('#doodles').empty().append(errormessage)
      success: (doodle) ->
        ViewAndCreateDoodles.getDoodles()
        newImage = $('<img>').attr('src', drawingData)
        $('#doodles').empty().append(newImage)

  startTimer: ->
    console.log("setting the interval")
    @interval = undefined
    window.seconds = 0
    @interval = setInterval(@addSecond, 1000)
    console.log("the interval id is #{@interval}")

  addSecond: =>
    timerbox = $('#timer')
    @seconds += 1
    timerbox.text(@seconds)

    if @seconds >= 15
      ViewAndCreateDoodles.finishDrawing()







