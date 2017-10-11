 $(document).ready(function(){
    $(".image_gallery a").hover(
        function(){
            $('#hover_plus').remove();
            var _i = $('<div></div>');
            $(_i).attr('id', 'hover_plus');
            $(this).append(_i);
        },
        function(){
            $('#hover_plus').remove();
        });
 });