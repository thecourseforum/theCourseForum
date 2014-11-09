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
	margin: 15
	# Distance from radius to inner arc
	innerRadiusOffset: 65
	# Distance from radius to outer arc
	outerRadiusOffset: 15
	# Minimum % for a slice to have to put its label
	# within the arc...otherwise, not enough space so should
	# go on outside
	labelInSliceMin: 6

	# Set el and height and width
	constructor: (@el, opts) ->
		opts or= {}
		@width = opts.width if opts.width
		@height = opts.height if opts.height

	# Set data to be used in donut
	# curr series is index of data array
	setData: (data, currSeries) ->
		#@data = @makeCumulative(@toPoints(@aggregateBySection sem for sem in @groupBySemester(data)))

		@data = @toPoints(@aggregateBySection sem for sem in @groupBySemester(data))

		console.log "data"
		console.log data
		console.log "Grouped by semester"
		console.log @groupBySemester(data)
		console.log "Aggregate by Section"
		console.log @aggregateBySection sem for sem in @groupBySemester(data)
		console.log "To points"
		console.log @toPoints(@aggregateBySection sem for sem in @groupBySemester(data))
		console.log "Final data"
		console.log @data
		console.log "currSeries"
		console.log currSeries
		console.log @data.length



		@currSeries = @data[currSeries]
		this

	# Render the donut
	render: () ->
		return unless @el and @data

		# set width/height/radius
		@setDimensions()
		# add svg elem to el
		viz = @renderContainer()

		# create pie descriptor
		pie = d3.layout.pie()
			.sort(null)
			.value((d) -> d.value)

		# set slices to match pie values
		slices = viz.selectAll('.slice')
			.data(pie(@currSeries.values))

		# add any new slices (new grades)
		@addNewSlices(slices)

		# update all existing slices to
		# set their current values
		me = this
		slices.each (d) -> me.updateSlices(this)

		# remove old slices (probably won't happen
		# just yet since we always have all grade keys
		# for each section)
		slices.exit().remove()

		# update inner label to show new info
		@updateInnerLabel(viz)

	# Add svg container to el if it hasn't been
	# added already.	Note that we add a g elem
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

		newSlices.append('text')
		slices.select('text').attr('text-anchor', 'middle')

	# Update all slices
	updateSlices: (el) ->
		me = this

		# transition arc for new value
		d3.select(el).select('path').transition()
			.duration(500)
			.attrTween('d', (d) -> me.arcTween(d, this))

		# move text into proper placement
		d3.select(el).select('text')
			.attr('transform', (d) =>
				c = @arc().centroid(d)
				x = c[0]
				y = c[1]
				h = Math.sqrt(x*x + y*y) # pythagorean theorem for hypotenuse
				percent = @getPercent(d)

				# if too small a slice, put label outside the pie
				if percent < me.labelInSliceMin
						x =	x/h * @radius
						y = y/h * @radius

				'translate(' + x +	',' + y +	')'
		)
		.attr('text-anchor', (d) ->
				# if past center, switch orientation
				(d.endAngle + d.startAngle)/2 > Math.PI ? 'end' : 'start'
		)
		.text((d) =>
				percent = @getPercent(d)
				return d.data.id.capitalize()
						.replace('plus', '+').replace('minus', '-') + ' (' + percent + '%)'
		)

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

	# Get percent for given grade
	getPercent: (d) ->
		Math.round((d.data.value / @currSeries.total) * 100)

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

#  makeCumulative: (data) ->

#    gradeSum = {}
#    @gradeKeys.forEach (grade) =>
#      gradeSum[grade] =
#        id: grade
#        value: 0

#      data.forEach (d) =>
#        gradeSum[grade].value += d.values[grade]
