//============== ファイルサイズが5MB以上のときにアラートを出す =================
$(function() {
  $('#surplus_land_images').bind('change', function() {
    $.each(this.files, function(index, file) {
      if (file.size/1024/1024 > 5) {
        alert(`${index+1}枚目のファイルサイズが5MBを超えています`);
      }
    });
  });
});
//============== surplus_land show-pageの画像表示 slickを使用 ==================
$(function() {
  $('.slider-for').slick({
    slidesToShow: 1,
    slidesToScroll: 1,
    arrows: false,
    fade: true,
    asNavFor: '.slider-nav'
  });
  $('.slider-nav').slick({
    slidesToShow: 3,
    slidesToScroll: 1,
    asNavFor: '.slider-for',
    centerMode: true,
    focusOnSelect: true
  });
});
//==== surplus_land index pageのアコーディオンのmargin-topを動的に変更 =========
$(function() {
  $(window).resize(function() {
    var w = $(window).width();
    var x  = 768;
    if (w <= x) {
      $('#prefectureAccordion').removeClass('mt50');
    } else {
      $('#prefectureAccordion').addClass('mt50');
    }
  });
});
