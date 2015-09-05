class @Problem extends EventEmitter2
  OPERATORS = [ '+', '-' ]
  TEMPLATE = """
    mixin component(idx, answerIdx)
      - if (answerIdx == idx)
        input.answer(type='number', pattern='[0-9]+(?:\\\\.[0-9]+)?')
      - else
        span \#{quantities[idx]}
    .problem 
      .pull-right
        .timer
      +component(0, answerIdx)
      span= operator
      +component(1, answerIdx)
      span \=
      +component(2, answerIdx)
      span.answerStatus
  """
  CORRECT_TMPL = """
    h1 Correct!
  """
  INCORRECT_TMPL = """
    h1 Sorry try again
  """

  MIN: 0
  MAX: 50

  constructor: (@$root) ->
    @setupEquation()
    @render()
    
  setupEquation: () ->
    operands = [
      Utils.randomInt(@MIN, @MAX),
      Utils.randomInt(@MIN, @MAX)
    ]
    @operator = @getRandOperator()
    @answerIdx = Utils.randomInt(1,3) - 1
    if @operator == '-'
      if (operands[0] < operands[1])
        operands.reverse()
      result = operands[0] - operands[1]
    else if @operator == '+'
      result = operands[0] + operands[1]
    @quantities = [
      operands[0],
      operands[1],
      result
    ]
    @answer = @quantities[@answerIdx]

  markAnswer: (correct) ->
    @emit('incorrect') if !correct

    $answerField = @$html.find('.answerStatus')
    $answerField.removeClass('incorrect correct')

    if correct
      $answerField.html("Correct").addClass('correct')
      time = @timer.getTime()
      @timer.stop()
      @emit('correct', { time: time }) if correct
    else if !correct
      $answerField.html("Sorry try again").addClass('incorrect')

  checkAnswer: (target) ->
    val = parseInt($(target).val())
    correct = (val == @answer)
    @markAnswer(correct)
  
  getRandOperator: () ->
    return OPERATORS[Utils.randomInt(0,1)]

  attachEvents: () ->
    @timer.start()
    @$input.on 'keypress', (e) =>
      if e.keyCode == 13
        @checkAnswer(e.target)

  render: () ->
    html = jade.compile(TEMPLATE)({
      quantities: @quantities,
      answerIdx: @answerIdx,
      operator: @operator
    })
    @$html  = $(html)
    @$input = @$html.find('input')
    @$root.append(@$html)
    @$input.focus()
    @timer = new Timer()
    @timer.render(@$html.find('.timer'))
    @attachEvents()
