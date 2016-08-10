// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ui.touch-punch
//= require jquery.slick
//= require turbolinks
//= require bootstrap
//= require jquery.readyselector
//= require moment
//= require fullcalendar
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require highcharts
//= require highcharts/highcharts-more
// require new_wheel
//= require header
//= require courses
//= require departments
//= require contact_us
//= require sign_up
//= require reviews
//= require textbook_transactions
//= require sidebar

NProgress.configure({ showSpinner: false });

var ready = function() {
	$("#close-notice, #close-alert").click(function() {
		$(this).parent().slideUp();
	});

	var input = [],
		konami = "38,38,40,40,37,39,37,39,66,65";

	//The following function sets a timer that checks for user input. You can change the variation in how long the user has to input by changing the number in ‘setTimeout.’ In this case, it’s set for 500 milliseconds or ½ second.
	$(document).keyup(function(e) {
		input.push(e.keyCode);
		if (input.toString().indexOf(konami) >= 0) {
			$(document).unbind('keydown', arguments.callee);
			alert('What did Alan the plate say to the other plate? Dinners on me.');
			input = [];
		}
	});

	if ('.panel-sort'.length) {

		// Sort panels by stats

		$('.panel-sort').change(function() {

			// get class name of panels and containers
			var panelClass, panelContainer;
			if (this.id == "courses") {
				panelClass = ".course-panel";
				panelContainer = "#department-courses";
			} else {
				panelClass = ".prof-panel";
				panelContainer = ".prof-panel-container";
			}

			// id of stat to sort by		
			var sortString = ".course-" + $(this).find('.active')[0].id,
				// class of which panels are displayed (current semester or all)
				selectorString = $("#all").parent().hasClass("active") ? panelClass.concat(".all") : panelClass.concat("current")
				// how many panels there are (to know when to trigger the next animation)
				numPanels = $(selectorString).length,
				slidPanels = 0,
				// sorted list of professors
				panelList = sortPanels($(panelClass), sortString);			
			// if the number of panels displayed is small enough to have smooth animations, animate the change
			if (numPanels < 50) {
				// slide up all the panels. then, on complete, add the sorted ones and slide down what is needed.
				$(selectorString).slideUp(350, function() {
					slidPanels++;
					if (slidPanels == numPanels) {
						$(panelContainer).empty();
						$(panelContainer).append(panelList);
						$(selectorString).slideDown(350);
					}
				});
			} else {
				// else just pop on the sorted list
				$(panelContainer).empty();
				$(panelContainer).append(panelList);
			}
		});
	}	

	function sortPanels(selector, attrName) {

		return $($(selector).toArray().sort(function(panelA, panelB) {

			// Compare two professors by a given stat
			retVal = comparePanels(panelA, panelB, attrName);

			// Handle tie
			if (retVal == 0) {
				var otherSortOptions = [".course-rating", ".course-difficulty", ".course-gpa"];

				for (var i = 0; i < otherSortOptions.length; i++) {
					// Get another stat
					if (attrName != otherSortOptions[i]) {

						// Compare by that stat
						retVal = comparePanels(panelA, panelB, otherSortOptions[i]);

						// stop if found a tie breaker
						if (retVal != 0) {
							break;
						}
						// if three-way tie, return 0
						if (i == 2 && retVal == 0) {
							return 0;
						}
					}
				}
			}

			return retVal;

		}));
	}

	// Compares two course panel elements by a given stat (id)
	function comparePanels(panelA, panelB, stat) {
		// Get stat to sort by (rating, difficulty, gpa)
		var aVal = parseFloat($(panelA).find(stat).text()),
			bVal = parseFloat($(panelB).find(stat).text()),
			retVal = bVal - aVal;

		// Handle no stat
		if (isNaN(aVal) && !isNaN(bVal)) {
			return 1;
		} else if (isNaN(bVal) && !isNaN(aVal)) {
			return -1;
		} else if (isNaN(bVal) && isNaN(aVal)) {
			retVal = 0;
		}

		// Sort difficulty ascending
		if (stat == ".course-difficulty") {
			retVal = retVal * -1;
		}		
		return retVal;
	}



};
$(document).ready(ready);
$(document).on('page:load', ready);
