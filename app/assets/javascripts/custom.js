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
