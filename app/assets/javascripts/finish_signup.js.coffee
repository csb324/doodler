$(document).ready ->
  FinishSignup.initialize()

FinishSignup =
  initialize: ->
    @userId = $('.finish-page').data("userid")

    $('#finish-signup').click (event) =>
      @nickname = $('#yournickname').val()
      if @nickname == ""
        @showError("Input a username")
      else
        @completeProfile()

  completeProfile: ->
    $.ajax
      url: "/users/#{@userId}/finish_signup"
      type: "PATCH"
      dataType: 'json'
      data:
        user:
          nickname: @nickname

      success: ->
        window.location = '/'
      error: ->
        @showError("Something went wrong")

  showError: (message) ->
    error = $('<p>').text(message)
    $('#errors').empty().append(error)
