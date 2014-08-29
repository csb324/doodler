$(document).ready ->
  if $('.drawing-environment').length > 0
    CreateDoodles.initialize()

CreateDoodles =
  initialize: ->
    @doodleableType = $('.drawing-environment').data("doodleable-type")
    @doodleableId = $('.drawing-environment').data("doodleable-id")

    $('#begin-drawing').click (event) =>
      event.preventDefault()
      @initializeDrawing()

  initializeDrawing: ->
    @paint = false;
    @currentColor = "#000"
    @clickX = []
    @clickY = []
    @clickDrag = []
    @colors = []
    if @interval
      clearInterval(@interval)
    @drawingEnvironment()

  drawingButtons: ->
    $('#show-this').click (event) =>
      event.preventDefault()
      @finishDrawing()

    $('#start-over').click (event) =>
      event.preventDefault()
      @initializeDrawing()

    $('#go-back').click (event) =>
      event.preventDefault()
      $('.drawing-environment-hide').show()
      $('.drawing-environment').empty()

    $('#color-picker a').click (event) =>
      event.preventDefault()

      $('#color-picker i').removeClass("current-color")
      $(event.target).addClass("current-color")

      @currentColor = $(event.target).css("color")


  drawingEnvironment: ->
    $('.drawing-environment').empty().append(HandlebarsTemplates.drawingcanvas())
    $('.drawing-environment-hide').hide()

    myCanvas = $('#my-canvas')
    @drawingButtons()
    @context = myCanvas[0].getContext('2d')

    @startTimer()

    myCanvas[0].width = 500
    myCanvas[0].height = 500

    myCanvas.mousedown (event) ->
      # $(this).css('cursor', 'none')
      mouseX = event.pageX - $(this).offset().left
      mouseY = event.pageY - $(this).offset().top
      CreateDoodles.paint = true

      CreateDoodles.addClick(mouseX, mouseY, CreateDoodles.currentColor)

    myCanvas.mousemove (event) ->
      if CreateDoodles.paint
        mouseX = event.pageX - $(this).offset().left
        mouseY = event.pageY - $(this).offset().top
        CreateDoodles.addClick(mouseX, mouseY, CreateDoodles.currentColor, true)

    myCanvas.mouseup (event) =>
      @paint = false

    myCanvas.mouseleave (event) =>
      @paint = false


  addClick: (x, y, color, dragging) ->
    @clickY.push(y)
    @clickX.push(x)
    @colors.push(color)
    @clickDrag.push(dragging)

  redraw: ->
    @context.clearRect(0, 0, @context.canvas.width, @context.canvas.height)
    @context.rect(0, 0, @context.canvas.width, @context.canvas.height)
    @context.fillStyle = '#fff'
    @context.fill()

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
      @context.strokeStyle = @colors[i]
      @context.stroke()

  finishDrawing: ->
    clearInterval(@interval)
    @redraw()
    $('.while-drawing').hide()
    $('.done-drawing').show()
    $('#my-canvas')[0].style.webkitFilter = "blur(25px)"
    @confirmButtons()

  confirmButtons: ->
    $('#confirm').click (event) =>
      event.preventDefault()
      @saveImage()

    $('#nevermind').click (event) =>
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
        window.location = "/doodles/#{data.doodle.id}"

  startTimer: ->
    if @interval
      clearInterval(@interval)
    # for some reason this line is also necessary or the timer goes double speed
    @interval = undefined

    window.seconds = 60
    ## DELETE THIS AFTER YOU FINISH STYLING CLARA
    @interval = setInterval(@countSecond, 1000)

  countSecond: =>
    timerbox = $('#timer')
    @seconds -= 1
    # most basic time-formatting ever bc we're only dealing with 0-60
    if @seconds < 10
      displayseconds = "0:0" + @seconds
    else
      displayseconds = "0:" + @seconds
    timerbox.toggleClass("ticktock")
    timerbox.text(displayseconds)

    if @seconds <= 15
      timerbox.addClass("urgent")

    if @seconds == 0
      CreateDoodles.finishDrawing()


