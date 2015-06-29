class SimpleTable
  constructor: (@$root, data, options={}) ->
    if options.rowFormatter
      @addRowFormatter(options.rowFormatter)
    @setData(data)

  setData: (@data) ->
    
  render: () ->
    @$tableRoot   = @buildBase()
    @$tableHeader = @buildHeader(@data.headers)
    @$tableRoot.append @$tableHeader
    @buildRows()

  buildBase: () ->
    $table = $('<table></table>')
    @$root.html($table)
    return $table

  buildHeader: (headers) ->
    cells = []
    for cell in headers
      cells.push @addHeaderCell(cell)
    return $("<thead><tr>#{cells.join()}</tr></thead>")

  buildRows: () ->
    $tbody = $('<tbody></tbody>')
    @$tableRoot.append $tbody
    for row in @data.data
      $rowEle = @buildRow(row)
      $tbody.append $rowEle
      if @formatRow and typeof @formatRow == 'function'
        @formatRow($rowEle, row)
      
  addRowFormatter: (fn) ->
    @formatRow = fn

  addCell: (value) ->
    return "<td>#{value}</td>"

  buildRow: (row) ->
    cells = []
    for cell in row
      cells.push @addCell(cell)
    return $("<tr>#{cells.join()}</tr>")

  addHeaderCell: (value) ->
    return "<th>#{value}</th>"
