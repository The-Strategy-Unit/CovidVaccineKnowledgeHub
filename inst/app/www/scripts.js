
$(function() {
  $("body").on('show.bs.collapse hidden.bs.collapse', ".collapse", function () {
    $(this).prev().find('.fa').toggleClass('fa-chevron-down fa-chevron-up');
  });
});
