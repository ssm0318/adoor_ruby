function check_channels(element) {
  console.log("hihi")
  element.click(function() {
    checked = $(this).siblings(".channels").find("input[type=checkbox]:checked").length;
  
    if(!checked) {
      alert("공개 범위는 하나 이상 선택해야 합니다!.");
      return false;
    }
  
  });
}
