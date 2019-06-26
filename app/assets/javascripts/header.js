var ready = function() {

    function transitionBox(from, to) {
        function next() {
            var nextTo;
            if (to.is(":last-child")) {
                nextTo = to.closest("div.home-announcements").children("div").first();
            } else {
                nextTo = to.next();
            }
            to.fadeIn(1500, function() {
                setTimeout(function() {
                    transitionBox(to, nextTo);
                }, 3000);
            });
        }
        if (from) {
            from.fadeOut(1500, next);
        } else {
            next();
        }
    }

   /*
    * Listens for FEEDBACK link press in _header.html.slim
    */
    $('#feedback').click(function() {
        $('#feedback-modal').modal();
    });

   /*
    * calls 'create' method in feedback_controller.rb
    */
    $('#submitFeedback').click(function() {
        $.ajax('/feedback', {
            method: "POST",
            data: $('#feedbackData').serialize(),
            success: function(response) {
                $('textarea[name="description"]').val('');
                $('input[name="title"]').val('');
                alert("Thanks for your feedback!");
            }
        });
        $('#feedback-modal').modal('hide');
    });

    var allBoxes = $("div.home-announcements").children("div");

    transitionBox(null, allBoxes.first());
}

$(document).ready(ready);
$(document).on('page:load', ready);
