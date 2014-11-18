# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Capitalize first letter of string
String::capitalize = ->
		this.charAt(0).toUpperCase() + this.slice(1)

#since coffeescript variables are wrapped in closure,
#need to expose to other areas of the code through window
window.App or= {}

# Grade Donut class for showing grade distributions
class App.GradeDonut
  # Assume for now that users don't care about breakdown after c
  gradeKeys: ['aplus', 'a', 'aminus', 'bplus', 'b', 'bminus', 'c', 'o']
  # Colors per grade key
  colors: ['#5254a3', '#6b6ecf', '#9c9ede', '#31a354', '#74c476', '#a1d99b',
    '#fdae6b', '#969696']
  # Margin around donut
  margin: 0
  # Distance from radius to inner arc
  innerRadiusOffset: 65
  # Distance from radius to outer arc
  outerRadiusOffset: 15
  # Minimum % for a slice to have to put its label
  # within the arc...otherwise, not enough space so should
  # go on outside
  labelInSliceMin: 6

  selected_semeters: []

  letters: ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+/C/C-', 'O*']

  # Set el and height and width
  constructor: (@el, opts) ->
    opts or= {}
    @width = opts.width if opts.width
    @height = opts.height if opts.height

  # Set data to be used in donut
  # curr series is index of data array
  setData: (data) ->
    @data = @toPoints(@aggregateBySection sem for sem in @groupBySemester(data))

    @currSeries = {values: new Array, total: 0, gpa: 0}

    for obj in @data
      @currSeries.total += obj.total
      @currSeries.gpa += obj.gpa

      if (@currSeries.values.length == 0)
        @currSeries.values = obj.values.slice()
        for i of @currSeries.values
          @currSeries.values[i] = $.extend(true, {}, obj.values[i])
      else
        for i of @currSeries.values
          @currSeries.values[i].value += obj.values[i].value

    @currSeries.gpa = (@currSeries.gpa / @data.length).toFixed(2)

    this

  # Render the donut
  render: () ->
    return unless @el and @data

    # set width/height/radius
    @setDimensions()
    # add svg elem to el
    @viz = @renderContainer()

    # create pie descriptor
    @pie = d3.layout.pie()
      .sort(null)
      .value((d) -> d.value)

    # set slices to match pie values
    @slices = @viz.selectAll('.slice')
      .data(@pie(@currSeries.values))

    # add any new slices (new grades)
    @addNewSlices(@slices)

    # update all existing slices to 
    # set their current values
    me = this
    @slices.each (d) -> me.updateSlices(this)

    # remove old slices (probably won't happen 
    # just yet since we always have all grade keys
    # for each section)
    @slices.exit().remove()

    # update inner label to show new info
    @updateInnerLabel(@viz)

    this
    
  add: (semester_id) ->
    @selected_semeters.push(semester_id)

    count = 0
    @currSeries = {values: new Array, total: 0, gpa: 0}

    for obj in @data
      if $.inArray(parseInt(obj.key), @selected_semeters) > -1 || @selected_semeters.length == 0
        count++
        @currSeries.total += obj.total
        @currSeries.gpa += obj.gpa

        if (@currSeries.values.length == 0)
          @currSeries.values = obj.values.slice()
          for i of @currSeries.values
            @currSeries.values[i] = $.extend(true, {}, obj.values[i])
        else
          for i of @currSeries.values
            @currSeries.values[i].value += obj.values[i].value

    @currSeries.gpa = (@currSeries.gpa / count).toFixed(2)

    @updateWheel()

  remove: (semester_id) -> 
    @selected_semeters = $.grep(@selected_semeters, (value) -> 
      return value != semester_id;
    )

    count = 0
    @currSeries = {values: new Array, total: 0, gpa: 0}

    for obj in @data
      if $.inArray(parseInt(obj.key), @selected_semeters) > -1 || @selected_semeters.length == 0
        count++
        @currSeries.total += obj.total
        @currSeries.gpa += obj.gpa

        if (@currSeries.values.length == 0)
          @currSeries.values = obj.values.slice()
          for i of @currSeries.values
            @currSeries.values[i] = $.extend(true, {}, obj.values[i])
        else
          for i of @currSeries.values
            @currSeries.values[i].value += obj.values[i].value

    @currSeries.gpa = (@currSeries.gpa / count).toFixed(2)

    @updateWheel()

  updateWheel: () ->
    # add svg elem to el
    @viz = @renderContainer()

    @pie = d3.layout.pie()
      .sort(null)
      .value((d) -> d.value)

    # set slices to match pie values
    @slices = @viz.selectAll('.slice')
      .data(@pie(@currSeries.values))

    # update all existing slices to 
    # set their current values
    me = this
    @slices.each (d) -> me.updateSlices(this)

    # remove old slices (probably won't happen 
    # just yet since we always have all grade keys
    # for each section)
    @slices.exit().remove()

    # update inner label to show new info
    @updateInnerLabel(@viz)

    this

  # Add svg container to el if it hasn't been 
  # added already.  Note that we add a g elem 
  # to center the donut on center of svg
  renderContainer: () ->
    if d3.select(@el + ' svg').empty()
      d3.select(@el).append('svg')
      d3.select('svg')
        .attr('width', @width)
        .attr('height', @height)
        .append('g')
      d3.select('svg g')
          .attr("transform", "translate(" + (@margin + @width / 2) +
            "," + (@margin + @height / 2) + ")")
    else
      d3.select('svg g')

  # Add new slices
  addNewSlices: (slices) ->
    newSlices = slices.enter().append('g')
      .classed('slice', true)

    newSlices.append('path')
      .attr('fill', (d, i) => @colors[i])
      .attr('d', @arc())
      .each((d) -> this._current = d)

  # Update all slices
  updateSlices: (el) ->
    me = this

    # transition arc for new value
    d3.select(el).select('path').transition()
      .duration(750)
      .attrTween('d', (d) -> me.arcTween(d, this))

    # Set Percentages on page

    for i of @currSeries.values
      grade = @currSeries.values[i]
      number = @currSeries.values[i].value
      percent = Math.round((number / @currSeries.total) * 100)
      $('#' + i + "-percent").html("(" + percent + "%)")

    this


  # Get percent for given grade
  getPercent: (d) ->
    Math.round((d.data.value / @currSeries.total) * 100)

  # Show donut info in middle of donut
  updateInnerLabel: (viz) ->
    # data of [1] makes sure that there's only 
    # ever one inner label
    label = viz.selectAll('.inner-label')
      .data [1]

    newLabel = label.enter().append('g')
      .classed('inner-label', true)

    newLabel.append('text')
      .classed('gpa', true)
      .attr('x', 0)
      .attr('y', -10)
      .attr('text-anchor', 'middle')

    newLabel.append('text')
      .classed('total', true)
      .attr('x', 0)
      .attr('y', 10)
      .attr('text-anchor', 'middle')

    label.select('text.gpa')
      .text(@currSeries.gpa + ' gpa')

    label.select('text.total')
      .text(@currSeries.total + ' students')

  # Generate a d3 arc
  arc: () ->
    d3.svg.arc()
      .outerRadius(@radius - @outerRadiusOffset)
      .innerRadius(@radius - @innerRadiusOffset)

  # Smoothly update arcs
  arcTween: (d, el) ->
    i = d3.interpolate(el._current, d)
    el._current = i(0)

    # returns arc function interpolating from last 
    # position to current
    (t) =>
      @arc()(i(t))

  # Set width, height, and radius of viz
  setDimensions: () ->
    @width = @width || d3.select(@el)[0][0].getBoundingClientRect().width
    @height = @height || d3.select(@el)[0][0].getBoundingClientRect().height
    @radius = (Math.min(@width, @height) - 2 * @margin) / 2


  # Group grade data by semester
  groupBySemester: (data) ->
    nest = d3.nest()
    nest.key (d) -> d.semester_id
    nest.entries data

  # Aggregate all sections during 1 semester down into 1 data point
  aggregateBySection: (data) ->
    data.values = data.values.reduce((prev, curr) ->
      for k, v of prev
        if k.match(/count_/)
          curr[k] = v + curr[k]

      prev.totals.push(curr['total'])
      prev.gpas.push(+curr['gpa'])

      curr.totals = prev.totals
      curr.gpas = prev.gpas

      curr
    , {totals: [], gpas: []})

    data

  # Convert grades by semester into data points that 
  # d3 will understand
  toPoints: (data) ->
    data.forEach (d) =>
      lookup = {}

      for k, v of d.values
        if k is 'gpas'
          # weighted average of gpa amongst sections
          d['gpa'] = d3.round(v.reduce((prev, curr, i) ->
            prev + curr * d.values['totals'][i]
          , 0) / d3.sum(d.values['totals']), 2)
        else if k is 'totals'
          # total amongst sections
          d['total'] = d3.sum(v)
        else if k.match /count_/
          id = k.replace 'count_', ''
          id = switch id
            when 'cplus', 'cminus' then 'c'
            when 'dplus', 'd', 'dminus', 'f', 'drop', 'withdraw', 'other' then 'o'
            else id

          if lookup[id]
            lookup[id].value += v
          else
            lookup[id] =
              id: id
              value: v

      d.values = @gradeKeys.map (g) -> lookup[g]

    data
