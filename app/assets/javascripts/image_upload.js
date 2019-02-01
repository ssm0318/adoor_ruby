function readURL(input) {
    console.log(input[0].files)

    if (input[0].files && input[0].files[0]) {
        var reader = new FileReader();
        
        reader.onload = function (e) {

            var image_url= e.target.result
            console.log(e.target.result)

            $.ajax({
                type: "PUT",
                url: input.attr('data-url'),
                data: {image: image_url},
                success: function(data) {
                    console.log("successed!")
                },
                error: function(data) {
                    console.log("error!")
                }
            })
        }

        reader.readAsDataURL(input[0].files[0]);
    }
}

$(document).on('turbolinks:load', function() {
    $("#file-input").change(function() {
        readURL($(this));
    });    
})
