jQuery ->
  $("#event_title").focus()
  $eventTable = $('#events').dataTable
    'dom': "fr<'event-table-info't>ip",
    order: [[3, 'asc']],
    columnDefs: [
                  { orderable: false, targets: -1 },
                  { orderData: 2, targets: 3 },
                  { orderData: 4, targets: 5 },
                  { visible: false, targets: [2,4] }
                ]

# sets checkbox elements within #events dataTable()
  $('.event-table-info caption').append('<a role="button" class="add-btn btn" href="/events/new"><p>+</p></a>
  <div><label>Current:<input type="checkbox" id="js-events-current-checkbox" class="event-filter" value="current"></label>
  <label>Recent:(Last 13 Months)<input type="checkbox" id="js-events-recent-checkbox" class="event-filter" value="recent"></label></div>')

#logic handling checkbox filtering with dataTables()
  $.fn.dataTableExt.afnFiltering.push((settings, data) ->
    # add table ID to array if you would like it to be included in filtering
    allowedTables = ['events'];
    if ( $.inArray( settings.nTable.getAttribute('id'), allowedTables ) == -1 )
       # if not table should be ignored
       return true;
    oneYearAgo = new Date()
    # todays date minus 396 days
    oneYearAgo.setDate(oneYearAgo.getDate() - 396)
    checked = []
    startTime = new Date(data[3])
    status = data[7]
    $('.event-filter').each ->
      $this = $(this)
      if $this.is(':checked')
        checked.push($this)
    if checked.length
      returnValue = false
      $.each(checked, (i, element) ->
        if element.val() is 'current' and (status is "In-session" or status is "Scheduled") or
           element.val() is 'recent' and (startTime > oneYearAgo)
          returnValue = true;
          return false;
          )
    else
      return false
    return returnValue
    )

  #re-draws table after checking or unchecking a filter checkbox
  $('.event-filter').change ->
    $eventTable.fnDraw()

  $("#event_category").change ->
    temp = $("#event_category option:selected").text();
    if temp is "Training"
      $(".training-controls").show()
      $(".training-controls").css("display", "block")
    else
      $(".training-controls").hide()
  $("#event_status").change ->
    status = $("#event_status option:selected").text();
    start_time = $("#event_start_time").text();
    if status is "Completed"
      $("#XXevent_start_time").hide()

  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    $.fn.dataTable.tables(
      visible: true
      api: true).columns.adjust()
    return

  $('#event_start_time').change ->
    eventStartTime = $('#event_start_time').datetimepicker('getValue')
    eventEndTime = $('#event_end_time').datetimepicker('getValue')
    if (not eventEndTime?) or (eventStartTime > eventEndTime)
      $('#event_end_time').datetimepicker('setOptions', {startDate: eventStartTime})

$(document).ready ->
  $("#js-events-current-checkbox").click()
