//편집하던거 다 날리기
function channel_edit_clear() {
    $("#channel-nav-div").removeClass("editing")
    $(".friend-box").removeClass("value-changed")
    $(".friend-box").removeClass("editing")
    $(".friend-box-with-edit").removeClass("editing")
    $("#name-edit-form").hide()
    $("#btn-channel-edit-complete").hide()
    $("#name-create-form").hide()
    $("#channel-default-btns").show()
    $("#btn-channel-add").show()
    $("#channel-name").show()
    $(".btn-friend-remove").show()
}

function click_channel_nav(element) {
    element.on('click', function(e) {

        if($("#channel-nav-div").hasClass("editing")) {
            channel_edit_clear();
        } 

        $(".channel-nav").removeClass("active")
        $(this).addClass("active")
        $("#channel-name").html($(this).html())
        $(".friend-box").removeClass("disabled")
        $(".friend-box-with-edit").show()

        if($(this).hasClass("all")) {
            //전체보기
            $("#channel-default-btns").hide()
        }
        else {
            const channelId = $(this).attr('class').split(/\s+/)[1];
            $("#btn-channel-delete").attr('href', `/channels/${channelId}`)
            $("#channel-default-btns").show()

            var htmls = $(".friend-box").filter(function(index) {
                return $(this).has('.' + channelId).length ? false : true
            })

            htmls.addClass("disabled")
            htmls.parents(".friend-box-with-edit").hide()
        }
    })
}



//채널탭 클릭
click_channel_nav($(".channel-nav"))

//인원 편집 시작
$("#btn-channel-edit").on('click', function(e) {

    //채널 추가하고 있었을 경우
    if($("#channel-nav-div").hasClass("editing")) {
        $("#name-create-form").hide()
        $("#btn-channel-add").show()
    }

    $("#channel-nav-div").addClass("editing")
    $(".friend-box-with-edit").addClass("editing")
    $("#channel-nav-div").addClass("editing")
    $(".friend-box-with-edit").show()
    $("#channel-default-btns").hide()
    $(".btn-friend-remove").hide()
    $("#btn-channel-edit-complete").show()
    
})


//인원 편집 완료
$("#btn-channel-edit-complete").on('click', function(e) {
    //TODO friend-box 값들, active한 nav 값 받아서 ajax send
    const channelId = $("#channel-nav-div").find(".active").attr('class').split(/\s+/)[1]
    var friend_ids = []

    //TODO 값 바뀐 friend-box 값들 for문 돌려서 friend id 쌓기
    $(".value-changed").each(function(index, element) {
        friend_ids.push($(element).attr('class').split(/\s+/)[1])
        
        if($(this).hasClass("disabled")) {
            //delete span
            $(this).find('.' + channelId).remove()
        } else {
            //add span
            $(this).append(`<span class="channel-id ${channelId}"></span>`)
        }
    })

    channel_edit_clear();
    $(".friend-box.disabled").parents(".friend-box-with-edit").hide()

    if(friend_ids.length > 0) {
        $.ajax({
            type: "PUT",
            url: `/channels/${channelId}/edit_friendship`,
            data: {"friend_ids": friend_ids},
            success: function(data) {
                console.log("successed!")
            },
            error: function(data) {
                console.log("error!")
            }
        })
    }
})


//box를 클릭해 해당 채널에 친구 추가 또는 삭제
//FIXME: editing인 상태에서만 disabled가 먹히도록!!!ㅠㅠ
// $(".friend-box-with-edit .editing").on('click', function(e) {
$(".friend-box-with-edit").on('click', function(e) {
    if ($(this).hasClass("editing")) {
        $(this).find(".friend-box").toggleClass("disabled")
        $(this).find(".friend-box").toggleClass("value-changed")
    }
})


//채널 이름 수정
$("#btn-channel-name-edit").on('click', function(e) {

    //채널 추가하고 있었을 경우
    if($("#channel-nav-div").hasClass("editing")) {
        $("#name-create-form").hide()
        $("#btn-channel-add").show()
    }

    $("#channel-nav-div").addClass("editing")
    $("#channel-name").hide()
    $("#channel-default-btns").hide()
    $("#name-edit-input").val($("#channel-nav-div").find(".active").html())
    $("#name-edit-form").show()
    $("#name-edit-input").focus()
})


//채널 추가
$("#btn-channel-add").on('click', function(e) {
    //채널 이름 혹은 채널 인원 편집 중이었을 경우
    if($("#channel-nav-div").hasClass("editing")) {
        if($(".value-changed").length > 0) {
            //값 바뀌었던 것들 제자리로
            $(".value-changed").toggleClass("disabled")
        }
        channel_edit_clear();
    }

    $("#channel-nav-div").addClass("editing")
    $(this).hide()
    $("#name-create-form").css('display', 'inline')
    $("#name-create-input").focus()
    $("#name-create-input").keydown(function() {

        if($(this).val().length > 3) {
            $(this).stop().animate({
                width: $(this).val().length*14
            },100)  
        }
    });
})

//채널 이름 수정 완료 or 채널 추가 완료
$("#name-edit-form, #name-create-form").submit( function(e) {
    e.preventDefault();
    
    const channelId = $("#channel-nav-div").find(".active").attr('class').split(/\s+/)[1]
    const form = $(this)
    let method = $(this).is("#name-edit-form") ? "PUT" : "POST"
    let url = $(this).is("#name-edit-form") ? `/channels/${channelId}` : '/channels'
    $.ajax({
        type: method,
        url: url,
        data: form.serialize(),
        success: function(data) {
            console.log("successed!")
            
            if(data.successed == false) {
                if(form.is("#name-edit-form")) {
                    $("#name-edit-input").val('')
                }
                else {
                    $("#name-create-input").val('')
                }
                alert(data.message)
            } else {
                form.hide()
                $("#channel-nav-div").removeClass("editing")

                if(form.is("#name-edit-form")) {
                    $("#channel-name").html($("#name-edit-input").val())
                    $("#channel-nav-div").find(".active").html($("#name-edit-input").val())
                } else {
                    $("#channel-name").html($("#name-create-input").val())
                    $(".channel-nav").removeClass("active")
                    var html = $(`<div class="channel-nav ${data.channel_id} active">${$("#name-create-input").val()}</div>`)
                    $("#channel-nav-div").append(html)
                    click_channel_nav(html)
                    $(".friend-box").addClass("disabled")
                    $("#name-create-input").val('')
                    $("#btn-channel-delete").attr('href', `/channels/${data.channel_id}`)
                    $(".friend-box-with-edit").hide()
                }
                $("#channel-name").show()
                $("#channel-default-btns").show()
                $("#btn-channel-add").show()
            }
        },
        error: function(data) {
            console.log("error!")
        }
    })
})

$(".btn-friend-remove").on('click', function(e) {

    if($("#channel-nav-div").hasClass("editing")) {
        $("#name-create-form").hide()
        $("#btn-channel-add").show()
        $("#name-edit-form").hide()
        $("#channel-name").show()
    }

    if(!confirm("정말 친구를 끊으시겠습니까?")) {
        return;
    }

    form = $(this)
    $.ajax({
        type: "POST",
        url: form.attr('data-url'),
        data: {"from_friend_list": true },
        success: function(data) {
            console.log("successed!")
            form.parents(".friend-box-with-edit").fadeOut(300, function(){ $(this).remove();});
        },
        error: function(data) {
            console.log("error!")
        }
    })


})



