class @Timer

  seconds: 0
  minutes: 0
  hours: 0

  constructor: () ->
    @static = true
    @hasDisplay = false

  render: (@$root) ->
    @hasDisplay = true
    @$root.html("00:00:00")

  start: () ->
    @static = false
    @tick()

  getTime: () ->
    return @seconds + (60 * @minutes) + (3600 * @hours)

  stop: () ->
    clearTimeout(@t)

  tick: () ->
    @t = setTimeout(() =>
      @add()
    , 1000)
    if @hasDisplay
      @$root.html(@getReadout())

  add: (n=1) ->
    @seconds+=n
    if (@seconds >= 60)
      @seconds = 0
      @minutes++
      if (@minutes >= 60)
        @minutes = 0
        @hours++
    unless @static
      @tick()

  pad: (num) ->
    return '00' if num == 0
    if (num < 10) then '0' + num else num

  getReadout: () ->
    return "#{@pad(@hours)}:#{@pad(@minutes)}:#{@pad(@seconds)}"

