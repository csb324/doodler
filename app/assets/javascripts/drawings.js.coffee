$(document).ready ->
  ViewAndCreateDoodles.initialize()

ViewAndCreateDoodles =
  initialize: ->
    doodlesBox = $('#doodles')
    if doodlesBox.length > 0
      @missionId = doodlesBox.data("mission")
      @getDoodles()

    $('#submit').click (event) =>
      event.preventDefault()
      @initializeDrawing()

  getDoodles: ->
    thisMission = "/missions/#{@missionId}"
    console.log(thisMission)
    console.log(@missionId)
    $.ajax
      url: thisMission
      type: 'GET'
      dataType: 'json'
      success: (doodles) ->
        console.log(doodles)
        $('#doodles').empty()
        doodles.forEach (doodle) ->
          image = $('<img>').attr("src", doodle.image.url)
          $('#doodles').append(image)

  initializeDrawing: ->
    console.log("drawing area initialized")

    @paint = false;

    @clickX = []
    @clickY = []
    @clickDrag = []

    @drawingEnvironment()

  drawingEnvironment: ->
    console.log("creating the drawing environment")
    myCanvas = $('<canvas>').attr("id", "my-canvas")
    $('#doodles').empty().append(myCanvas)

    @context = myCanvas[0].getContext('2d')

    showButton = $('<button>').attr("id", "show-this").text("show")
    startOver = $('<button>').attr("id", "start-over").text("start over")

    $('#buttons').empty().append(showButton).append(startOver)

    $('#show-this').click (event) =>
      event.preventDefault()
      @finishDrawing()

    $('#start-over').click (event) =>
      event.preventDefault()
      @drawAgain()


    myCanvas[0].width = 600
    myCanvas[0].height = 600

    myCanvas.mousedown (event) ->
      # $(this).css('cursor', 'none')
      mouseX = event.pageX - this.offsetLeft
      mouseY = event.pageY - this.offsetTop
      ViewAndCreateDoodles.paint = true

      ViewAndCreateDoodles.addClick(mouseX, mouseY)

    myCanvas.mousemove (event) ->
      if ViewAndCreateDoodles.paint
        ViewAndCreateDoodles.addClick(event.pageX - this.offsetLeft, event.pageY - this.offsetTop, true)

    myCanvas.mouseup ->
      ViewAndCreateDoodles.paint = false

    myCanvas.mouseleave ->
      ViewAndCreateDoodles.paint = false


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
    this.redraw()
    $('#my-canvas')[0].style.webkitFilter = "blur(25px)"
    finishButton = $('<button>').attr("id", "confirm").text("are you sure?")

    finishButton.css("position", "absolute").css("left", "200px").css("top", "200px")
    $('#doodles').append(finishButton)

    finishButton.click (event) =>
      event.preventDefault()
      @saveImage()

    # this.createImage()

  # # this turns the canvas data into a Blob (large binary object)
  # createBlob: (imageData) ->
  #   binary = atob(imageDAta.split(',')[1]);
  #   array = []
  #   i = 0

  #   while i < binary.length
  #     array.push binary.charCodeAt(i)
  #     i++

  #   new Blob([new Uint8Array(array)],
  #     type: 'image/png'
  #   )

  saveImage: ->
    drawingData = $('#my-canvas')[0].toDataURL()

    newImage = $('<img>').attr('src', drawingData)
    $('#doodles').empty().append(newImage)

    $.ajax
      url: "/missions/#{@missionId}/doodles"
      type: "POST"
      dataType: 'json'
      data:
        doodle:
          imagedata: drawingData
          mission_id: @missionId
      success: (doodle, status) ->
        alert(status)
        console.log(this)
        ViewAndCreateDoodles.getDoodles()

  drawAgain: ->
    this.paint = false;

    this.clickX = []
    this.clickY = []
    this.clickDrag = []

    this.drawingEnvironment()












