// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require bootstrap
//= require grades
//= require course_professors

$(document).ready(function() {
	$('.professor_link').bind('ajax:success', function(xhr, data, status) {
	var target = $(this).data('update-target');
	alert(target);
	$('#' + target).html(data);
	$('#' + target).toggle();
	});

	$('#searchbox').autocomplete({
	source: function( request, response ) {
		$.ajax({
		url: '/search/search',
		dataType: 'json',
		type: 'GET',
		data: {
			query: request.term
		},
		success: function( data ) {
			response( $.map(data, function( item ) {
			return {
				label: item.subdepartment_code + " " + item.course_number + "-" + item.last_name,
				value: "c=" + item.course_id + "&p=" + item.professor_id
			}
			}));
		}
		});
	},
	minLength: 2,
	select: function(event, ui) {
		$('#searchbox').val(ui.item.label);
		window.location = "/course_professors?" + ui.item.value;
	},
	open: function() {
		$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
		$(this).autocomplete('widget').css('z-index', 5000);
	},
	close: function() {
		$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
	}
	});

	$("#subdept_select").bind("change", function(){
		$("#courses").hide();
		$("#course_select").empty();
		$("#professors").hide();
		var value = $(this).find(":selected").val();
		$.ajax({
			url: '/subdepartments/' + value,
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				$("#courses").show();
				$.each(data, function(){
					$('#course_select').append($("<option/>", {
						value: this.id,
						text: this.subdepartment.mnemonic + " " + this.course_number
					}));
				});			
				
				course_select.selectedIndex = -1;			
				
			}
		});

	});

	$("#course_select").bind("change", function(){
		$("#prof_select").empty();
		var value = $(this).find(":selected").val();
		$.ajax({
			url: '/courses/' + value,
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				$("#professors").show();
				$.each(data.professors_list, function(){
					$('#prof_select').append($("<option/>", {
						value: this.id,
						text: this.last_name + ", " + this.first_name
					}));
				});			
				var prof_select = document.getElementById("prof_select");
				if(prof_select.length > 1){
					prof_select.selectedIndex = -1;
				}
			}
		});
		
	});


	$("#prof_name").bind("change", function(){
		$("#prof_list").empty();
		var value = $(this).find(":selected").val();
		$.ajax({
			url: '/professors/',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				$.each(data, function(){
					if(this.last_name[0] == value) {
						$('#prof_list').append($("<a/>", {
							href: "/professors/" + this.id,
							text: this.last_name + ", " + this.first_name
						}));
						$('#prof_list').append($("<br/>", {						
						}));
					}
				});			
			}
		});
	});

});

jQuery.ajaxSetup({
  beforeSend: function() {
    $('#loading').fadeIn();
    $("#second_letter").show();

  },
  complete: function(){
    $('#loading').hide();
  },
  success: function() {}
});