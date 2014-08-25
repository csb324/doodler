$(document).ready ->
  CreateDoodles.initialize()

CreateDoodles =
  initialize: ->
    @doodleableType = $('.drawing-environment-hide').data("doodleable-type")
    @doodleableId = $('.drawing-environment-hide').data("doodleable-id")

    $('.buttons').on "click", "#begin-drawing", (event) =>
      event.preventDefault()
      @initializeDrawing()

  initializeDrawing: ->
    @paint = false;
    @clickX = []
    @clickY = []
    @clickDrag = []
    if @interval
      clearInterval(@interval)
    @drawingEnvironment()

  buildDrawingButtons: ->
    showButton = $('<button>').attr("id", "show-this").text("show")
    startOver = $('<button>').attr("id", "start-over").text("start over")
    goBack = $('<button>').attr("id", "go-back").text("go back")
    timer = $('<div>').attr("id", "timer").text("1:00")

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

  drawingEnvironment: ->
    console.log("creating the drawing environment")
    myCanvas = $('<canvas>').attr("id", "my-canvas")
    $('.drawing-environment-hide').hide()
    $('.drawing-environment-show').find('canvas').remove()
    $('.drawing-environment-show').append(myCanvas)

    @buildDrawingButtons()
    @context = myCanvas[0].getContext('2d')

    @startTimer()

    myCanvas[0].width = 500
    myCanvas[0].height = 500

    myCanvas.mousedown (event) ->
      # $(this).css('cursor', 'none')
      mouseX = event.pageX - $(this).offset().left
      mouseY = event.pageY - $(this).offset().top
      CreateDoodles.paint = true

      CreateDoodles.addClick(mouseX, mouseY)

    myCanvas.mousemove (event) ->
      if CreateDoodles.paint
        mouseX = event.pageX - $(this).offset().left
        mouseY = event.pageY - $(this).offset().top
        CreateDoodles.addClick(mouseX, mouseY, true)

    myCanvas.mouseup (event) =>
      @paint = false

    myCanvas.mouseleave (event) =>
      @paint = false


  addClick: (x, y, dragging) ->
    console.log("adding a click")
    @clickY.push(y)
    @clickX.push(x)
    @clickDrag.push(dragging)

  redraw: ->
    @context.clearRect(0, 0, @context.canvas.width, @context.canvas.height)
    @context.rect(0, 0, @context.canvas.width, @context.canvas.height)
    @context.fillStyle = '#fff'
    @context.fill()

    @context.strokeStyle = "#000"
    @context.lineJoin = "round"
    @context.lineWidth = 5

    for value, i in @clickX
      @context.beginPath()

      if @clickDrag[i] && i
        @context.moveTo(@clickX[i-1], @clickY[i-1]);
      else
        @context.moveTo(value-1, @clickY[i]);

      @context.lineTo(value, @clickY[i])
      @context.closePath()

      @context.stroke()

  finishDrawing: ->
    clearInterval(@interval)
    @redraw()
    $('.buttons').empty()
    $('#my-canvas')[0].style.webkitFilter = "blur(25px)"
    @addConfirmButtons()

  addConfirmButtons: ->
    buttonsContainer = $('<div>').addClass("buttons")
    finishButton = $('<button>').attr("id", "confirm").text("submit!")
    startOverButton = $('<button>').attr("id", "nevermind").text("start over")

    buttonsContainer.append(finishButton).append(startOverButton)

    buttonsContainer.css("position", "absolute").css("left", "200px").css("top", "200px")
    $('.drawing-environment-show').append(buttonsContainer)

    finishButton.click (event) =>
      event.preventDefault()
      @saveImage()

    startOverButton.click (event) =>
      event.preventDefault()
      @initializeDrawing()

  saveImage: ->
    drawingData = $('#my-canvas')[0].toDataURL()

    $.ajax
      url: "/doodles"
      type: "POST"
      dataType: 'json'
      data:
        doodle:
          imagedata: drawingData
        doodleable_id: @doodleableId
        doodleable_type: @doodleableType

      error: ->
        errormessage = $('<div>').text("oh no something went wrong")
        $('#doodles').empty().append(errormessage)
      success: (data) ->
        console.log(data)
        window.location = "/doodles/#{data.doodle.id}"

  startTimer: ->
    if @interval
      clearInterval(@interval)
    # for some reason this line is also necessary or the timer goes double speed
    @interval = undefined

    window.seconds = 60
    @interval = setInterval(@countSecond, 1000)

  countSecond: =>
    timerbox = $('#timer')
    @seconds -= 1

    # the most basic time-formatting ever bc we're only dealing with 0-60
    if @seconds < 10
      displayseconds = "0:0" + @seconds
    else
      displayseconds = "0:" + @seconds

    timerbox.text(displayseconds)
    if @seconds == 0
      CreateDoodles.finishDrawing()




