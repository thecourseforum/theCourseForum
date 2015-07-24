var ready;

ready = function() {
	var params, search;
	if (window.location.search != '') {
		search = window.location.search.substring(1);
		params = JSON.parse('{"' + search.replace(/=/g, '":"').replace(/&/g, '","') + '"}');
		if (params['p']) {
			$('#check-' + params['p']).prop('checked', true);
		}
	}

	$('.courses-review-type-switcher').change(function() {
		// Turbolinks.visit('/courses/' + $(this).val());
		window.location.href = '/courses/' + $(this).val();
	});

	$('#save-course').click(function() {
		var course_name = $('#course-name').text().replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		course_name = course_name.split(' - ');
		course_name = course_name[0].split(' ');

		$.ajax('/scheduler/course', {
			method: "POST",
			data: {
				mnemonic: course_name[0],
				course_number: course_name[1]
			},
			success: function(response) {
				alert('Course saved for scheduler!');
			},
			failure: function(response) {
				alert('Could not load corresponding course!');
			}
		});
	});


	$('.skillbar').each(function(){
		$(this).find('.skillbar-bar').animate({
			width:$(this).attr('data-percent')
		},1000);
	});

	try {
		$('.carousel').slick({
	        infinite: true,
	  		slidesToShow: 2,
	  		slidesToScroll: 2,
	  		dots: true,
	  		responsive: [
			    {
			      breakpoint: 1120,
			      settings: {
			        slidesToShow: 1,
			        slidesToScroll: 1,
			        infinite: true,
			        dots: true
			      }
			    },
			    // {
			    //   breakpoint: 00,
			    //   settings: {
			    //     slidesToShow: 1,
			    //     slidesToScroll: 1
			    //   }
			    // },
			    ],
	     });
	} catch(error) {
		console.log(error);
	}


	$("#courses-sidebar").css("height", $("#courses-main").height());
};

$(document).ready(ready);

$(document).on('page:load', ready);