$(document).ready(function() {
    var $nav = $('#main-nav ul');
    var isNavVisible = $nav.is(':visible');

    $('#toggle-menu').on('click', function() {
        $nav.slideToggle();
        isNavVisible = !isNavVisible;
        $(this).html('<small>' + (isNavVisible ? '&#9652;' : '&#9662;') + '</small> Menu');
    });

    $("form#signup").submit(function() {
        var email = $("#signup_email").val();
        $(".signup_field").hide()
        $(".signup_loading").show();
        $.ajax("/signup", {
            type: "POST",
            data: "signup_email="+email,
            success: function(data) {
                $(".signup_loading").hide();
                $(".signup_field").show();
                if (data.error == null) {
                    var html = $("<div class='success'>Yay! It's nice to hear that you like the project! Stay tuned!</div>");
                    $("#signup_beta .vessel").html(html);
                } else {
                    var html = $("<div class='error'>"+data.error+"</div>");
                    $("#signup_flash").html(html);
                }
            }
        });
        return false;
    })
});
