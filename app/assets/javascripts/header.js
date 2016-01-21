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

    $('#report-bug').click(function() {
        $('#report-bug-modal').modal();
        $('input[name="url"]').val(window.location);
    });

    $('#report').click(function() {
        $.ajax('/bugs', {
            method: "POST",
            data: $('#bug').serialize(),
            success: function(response) {
                $('textarea[name="description"]').val('');
                alert("Thanks for your feedback!");
            }
        });
        $('#report-bug-modal').modal('hide');
    });

    var allBoxes = $("div.home-announcements").children("div");

    transitionBox(null, allBoxes.first());
}

$(document).ready(ready);
$(document).on('page:load', ready);