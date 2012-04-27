$(document).ready(function() {
    var $nav = $('#main-nav ul');
    var isNavVisible = $nav.is(':visible');

    $('#toggle-menu').on('click', function() {
        $nav.slideToggle();
        isNavVisible = !isNavVisible;
        $(this).html((isNavVisible ? '&#9652;' : '&#9662;') + ' Menu');
    });
});
