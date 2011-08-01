#=require jquery.flot
#=require jquery.flot.resize
#=require jquery.flot.symbol
#=require jquery.flot.pie

$.gricer =
  month: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

  colors: [
    "#5a9bd4", "#f9a65b", "#fd8c96", "#ce7058", "#f15961", "#d77eb4", 
    "#9e67ac", "#8cd5f4", "#fede8f", "#fede8f", "#9e67ac", "#b6eea2", 
    #"#edc240", "#afd8f8", "#cb4b4b", "#4da74d", "#9440ed"
  ]
  others_color: '#cccccc'
  unknown_color: '#999999'
  
  last_called: $('a[data-gricer-dashboard]').first()

  loading: ->
    $('#gricer-dashboard').hide()
    $('#gricer-container').html('<div class="loading">Loading ...</div>').show()
    
  formatPercentage: (value) ->
    (value * 100).toFixed(2) + '%'
    
  formatDate: (value, options = {}) ->
    return '' if not value
    
    if options.tb 
      if $.datepicker != null
        return $.datepicker.formatDate('M<br/>dd', value)
      else
        day = value.getDate()
        day = '0' + day if day < 10
        return '' + @month[value.getMonth()] + '<br/>' + day
    else
      if $.datepicker != undefined
        return $.datepicker.formatDate($.datepicker.RFC_1036, value)
      else
        day = value.getDate()
        day = '0' + day if day < 10
        month = value.getMonth() + 1
        month = '0' + month if month < 10
        return '' + value.getFullYear() + '-' + month + '-' + day
      
  formatHour: (value) ->
    return '' if not value

    hour = value.getHours() 
    hour = '0' + hour if hour < 10

    return hour
    
  labelFor: (value) ->
    if value == true or value == 'true'
      return 'Yes'
    if value == false or value == 'false'
      return 'No'
    if value == null or value == ''
      return '(Unknown)'
    
    return value
    
  typeSelector: (alternatives) ->
    container = $('<div class="type-selector">')
    
    for alt in alternatives
      do(alt) ->
        if alt.uri
          container.append($('<a>').attr('href', alt.uri).addClass(alt.type).attr('data-gricer-' + alt.type, true).attr('data-label', alt.type).attr('data-type-selector', true).append(alt.type))
        else
          container.append($('<span>').addClass(alt.type).append(alt.type))
    
    return container
    
    
  blowUpProcessFlotData: (data, from, thru, step) ->
    output = []
    
    for timestamp in [from..thru+86400000] by step
      do(timestamp) ->
        value = 0
        for item in data
          do(item) ->
            value = item[1] if item[0] == timestamp 
        output.push [timestamp, value] 
        
    return output
  
  updateBreadcrumb: (elem) ->
    $.gricer.last_called = $(elem)
    
    label = $(elem).text() || $(elem).attr('data-label')
    
    if $(elem).parents('#gricer-menu').length > 0
      $('#gricer-header .path').empty()
    else if $(elem).parents('#gricer-header .path').length > 0
      $(elem).nextAll().remove()
      return
    else if $(elem).attr('data-type-selector')
      label = $('#gricer-header .path a:last').attr('data-label')
      $('#gricer-header .path a:last').remove()
  
    $('#gricer-header .path').append( $(elem).clone().attr('data-label', label).html(label) )
  
$('a[data-gricer-process]').live 'click', ->
  $.gricer.loading()
  $.gricer.updateBreadcrumb(this)
  
  $.getJSON $(this).attr('href'), {
    from: $('#gricer-from-field').val()
    thru: $('#gricer-thru-field').val()
  }, (data) ->
  
    table = $('<table class="process">')
    plot_data = []
    
    row = $('<tr>')
    if data.thru-data.from == 0
      date = new Date
      date.setTime data.from
      
      row.append( $('<th>').append($.gricer.formatDate(date)) )
    else
      row.append( $('<th>') )
    
    table_step = data.step
    table_step = 86400000 if table_step < 86400000 and data.thru-data.from > 0
    
    # Needs improvement for durations over a month
    
    for timestamp in [data.from..data.thru+86399999] by table_step
      do(timestamp) ->
        date = new Date
        date.setTime timestamp
        
        if table_step >= 86400000
          date_string = $.gricer.formatDate(date, {tb: (data.thru-data.from > 86400000*6)})
        else
          date_string = $.gricer.formatHour(date)

        row.append($('<th>').append($('<span>').append date_string))
        
    table.append row

    $('#gricer-container').html($('<div class="data">').append table)
      
    chart = $('<div class="flot-chart">').append $('<div id="flot-line-chart">')
   
    $('#gricer-container').append(chart).append($.gricer.typeSelector data.alternatives)
  
    i = 0
    for key, value of data.data
      do(key, value) ->        
        detail_link = null
        graph = $.gricer.colors[i]
          
        label = label_row = $('<td>')
        if data.detail_uri
          label = $('<a data-gricer-process="true"></a>').attr('href', data.detail_uri.replace('%25%7Bself%7D', encodeURI(key)))
          label_row.append(label)
      
        if graph
          label.append($('<span class="badge" style="background:' + $.gricer.colors[i] + '">'))
        else
          label.append($('<span class="badge">'))
          
        lable_text = $.gricer.labelFor key
        label.attr('data-label', lable_text)
        label.append(lable_text)
      
        row = $('<tr>').append( label_row )
        
        for timestamp in [data.from..data.thru+86399999] by table_step
          do(timestamp) ->
            count = 0
            for item in value
              do(item) ->
                count += item[1] if item[0] >= timestamp and item[0] < timestamp + table_step
            count = '' if count == 0      
            row.append($('<td class="number">').append(count))
        table.append(row)
        
        if $.gricer.colors[i]
          plot_data.push
            label: $.gricer.labelFor key
            data: $.gricer.blowUpProcessFlotData value, data.from, data.thru, data.step
            color: $.gricer.colors[i]
            lines: 
              show: true
            points:
              show: false     
              symbol: 'cross'
        i++
  
    $.plot $("#flot-line-chart"), plot_data, 
      xaxis:
        mode: 'time',
        min: data.from,
        max: data.thru+86400000
      yaxis:
        min: 0
      legend:
        show: false
      grid:
        color: $("#flot-line-chart").css('color')
        borderColor: 'transparent'
      colors: $.gricer.colors      
        
  return false
  
$('a[data-gricer-spread]').live 'click', ->
  $.gricer.loading()
  $.gricer.updateBreadcrumb(this)
  
  $.getJSON $(this).attr('href'), {
    from: $('#gricer-from-field').val()
    thru: $('#gricer-thru-field').val()
  }, (data) ->
    table = $('<table>')
    plot_data = []
    
    row = $('<tr>')
    row.append( $('<th>') )
    row.append( $('<th>').append('Count') )
    row.append( $('<th>').append('Percentage') )
    table.append row
  
    i = 0
    others = 0  
    unknown = 0
    
    for line in data.data
      do(line) ->
        if line[0] == null
          unknown += line[1]
        else
          detail_link = null
          graph = data.data.length < 4 or $.gricer.colors[i] and line[1]/data.total > 0.05 
          label = label_row = $('<td>')
          if data.detail_uri
            label = $('<a data-gricer-spread="true"></a>').attr('href', data.detail_uri.replace('%25%7Bself%7D', encodeURI(line[0])))
            label_row.append(label)
          
          if graph
            label.append($('<span class="badge" style="background:' + $.gricer.colors[i] + '">'))
          else
            label.append($('<span class="badge">'))
          
          label_text = $.gricer.labelFor(line[0])
          label.attr('data-label', label_text)
          label.append(label_text)
                 
          row = $('<tr>')
          .append( label_row )
          .append( $('<td class="number">').append(line[1]) )
          .append( $('<td class="number">').append($.gricer.formatPercentage(line[1]/data.total)) )
        
          table.append row
        
          if graph
            plot_data.push
              label: $.gricer.labelFor line[0]
              data: line[1]
              color: $.gricer.colors[i]
            i++
          else
            others += line[1]
            
    if others > 0
      plot_data.push
        label: 'Others'
        data: others
        color: $.gricer.others_color
    
    if unknown > 0   
      plot_data.push
        label: $.gricer.labelFor null
        data: unknown
        color: $.gricer.unknown_color
        
      row = $('<tr>')
      .append( 
        $('<td>')
        .append($('<span class="badge" style="background:' + $.gricer.unknown_color + '">')) 
        .append($.gricer.labelFor null) 
      )
      .append( $('<td class="number">').append(unknown) )
      .append( $('<td class="number">').append($.gricer.formatPercentage(unknown/data.total)) )
      
      table.append row


    $('#gricer-container').html($('<div class="data">').append table)
    
    chart = $('<div class="flot-chart">').append $('<div id="flot-pie-chart">')
      
    $('#gricer-container').append(chart).append($.gricer.typeSelector(data.alternatives))
  
    $.plot $("#flot-pie-chart"), plot_data, 
      series:
        pie:
          show: true
          stroke:
            color: $("#flot-pie-chart").css('background-color')
          label:
            formatter: (label, slice) ->
              '<div style="font-size:x-small;text-align:center;padding:2px;color:'+slice.color+';">'+label+'</div>'
      legend:
        show: false
      colors: $.gricer.colors

  return false
  
$('a[data-gricer-dashboard]').live 'click', ->
  $.gricer.loading()
  $.gricer.updateBreadcrumb(this)

  $('#gricer-container').load $(this).attr('href'), 
    from: $('#gricer-from-field').val()
    thru: $('#gricer-thru-field').val()

  return false
  
$('#gricer-menu a').live 'click', ->
  $('#gricer-menu a.active').removeClass('active')
  $(this).addClass('active')
  return false
  
jQuery ->
  $('#gricer-menu a:first')?.click();
  
  if $.datepicker != undefined
    dates = $('#gricer-from-field, #gricer-thru-field').datepicker
      defaultDate: "+1w"
      changeMonth: true
      changeYear: true
      numberOfMonths: 1
      dateFormat: 'yy-mm-dd'
      maxDate: new Date
      onSelect: (selectedDate) ->
        if this.id == "gricer-from-field"
          option = 'minDate'
        else
          option = 'maxDate'
      
        instance = $(this).data 'datepicker'
        dateFormat = instance.settings.dateFormat || $.datepicker._defaults.dateFormat
        date = $.datepicker.parseDate dateFormat, selectedDate, instance.settings 
        dates.not(this).datepicker 'option', option, date
      onClose: (dateText, inst) ->
        $.gricer.last_called.click()