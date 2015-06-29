class @Timer

  seconds: 0
  minutes: 0
  hours: 0

  constructor: (@$root) ->
    @$root.html("00:00:00")

  start: () ->
    @tick()

  getTime: () ->
    return @seconds + (60 * @minutes) + (3600 * @hours)
  stop: () ->
    clearTimeout(@t)

  tick: () ->
    @t = setTimeout(() =>
      @add()
    , 1000)
    @$root.html(@getReadout())

  add: () ->
    @seconds++
    if (@seconds >= 60)
      @seconds = 0
      @minutes++
      if (@minutes >= 60)
        @minutes = 0
        @hours++
    @tick()

  pad: (num) ->
    return '00' if num == 0
    if (num < 10) then '0' + num else num

  getReadout: () ->
    return "#{@pad(@hours)}:#{@pad(@minutes)}:#{@pad(@seconds)}"

