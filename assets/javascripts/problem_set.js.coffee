class @ProblemSet
  DEFAULT_COUNT = 10
  SETUP_FORM = """
    form.form-inline
      .form-group
        label How many problems should we setup?
        input.form-control.input-lg
      button.btn.btn-success.btn-lg.btn-start 
        span.fa.fa-paper-plane
        span Go
  """

  constructor: (@$root) ->
    @totalCount = 0
    @currentProblemIdx = 0
    @setupForm()
    @registerEvents()

  setupForm: () ->
    @$formRoot = @$root.find('.problem-set-setup:first')
    html = jade.compile(SETUP_FORM)()
    @$formRoot.html(html)
    @$problemCountInput = @$formRoot.find('input')
    @$btn-start = @$formRoot.find('.btn-start')

  showFinished: () ->
    @stats.getTotalTime()

  nextProblem: () ->
    if @currentProblemIdx == @totalCount
      return @showFinished()
    p = new Problem(@$root)
    p.on 'correct', (problemData) =>
      @currentProblemIdx++
      @stats.correct++
      @stats.time += problemData.time
      @stats.render()
      @nextProblem()
    p.on 'incorrect', () =>
      @stats.incorrect++
      @stats.render()

  registerEvents: () ->
    @$root.find('.btn-start').click (e) =>
      e.preventDefault()
      @$formRoot.hide()
      @totalCount = parseInt(@$problemCountInput.val())
      @stats = new Stats($('.stats-section'))
      @nextProblem()

class Stats
  template: jade.compile """
    span Correct: \#{correct}
    span &nbsp;|&nbsp;
    span Incorrect: \#{incorrect}
  """

  constructor: (@$root) ->
    @correct = 0
    @incorrect = 0
    @time = 0
    @render()

  getTotalTime: () ->
    return @time

  render: () ->
    stats = {@correct, @incorrect}
    @$root.html(@template(stats))
