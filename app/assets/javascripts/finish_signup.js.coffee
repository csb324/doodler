$(document).ready ->
  FinishSignup.initialize()

FinishSignup =
  initialize: ->
    @userId = $('.finish-page').data("userid")

    $('#finish-signup').click (event) =>
      @nickname = $('#yournickname').val()
      @email = $('#email').val()
      if @nickname == ""
        @showError("Input a username")
      else if @email == "" || @email == "example@example.com"
        @showError("Input a valid email address")
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
          email: @email

      success: ->
        window.location = '/'
      error: ->
        @showError("Something went wrong")

  showError: (message) ->
    error = $('<p>').text(message)
    $('#errors').empty().append(error)
