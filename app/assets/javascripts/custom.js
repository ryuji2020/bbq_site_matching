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
//======================== surplus_land show page ==============================
$(function() {
  $(window).resize(function() {
    var w = $(window).width();
    var x  = 992;
    if (w <= x) {
      $('.apply-btn').addClass('mt30 d-i-block');
    } else {
      $('.apply-btn').removeClass('mt30 d-i-block');
    }
  });
});
//-------------------------------- comment -------------------------------------
$(function() {
  $('.read-more-btn').prevAll().hide();
  $('.read-more-btn').click(function() {
    if ($(this).prevAll().is(':hidden')) {
      $(this).prevAll().slideDown();
      $(this).text('閉じる');
    } else {
      $(this).prevAll().slideUp();
      $(this).text('もっと見る');
    }
  });
});
//-------------------------- 画像表示 slickを使用 ------------------------------
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
//======================== surplus_land index page =============================
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
