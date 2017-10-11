 function fsresize(){
        var imageHeight=parseInt($('#bigImage').height());        
        var imageWidth=parseInt($('#bigImage').width());
        $('#secondColumn').css('height',imageHeight+8+'px');
        $('#overlay').css('top',imageHeight-80+'px');
        $('#overlay').css('width',imageWidth+'px');
    }   
    function showDiv(id){    
        $("#"+id).children(".smallImageInfo").css("display","block");
        $("#"+id).children(".sm-text").css("display","block");

    }
    function hideDiv(id){ 
      $("#"+id).children(".smallImageInfo").css("display","none");
      $("#"+id).children(".sm-text").css("display","none");
    }
    
    $(document).ready(function(){
       
        var getLength = $(".sm-text").length;
        for(var i =0 ;i <getLength ;i++)
        {
         var newHeight = $("#small-image"+(i+1)).children(".sm-text").height();
         $("#small-image"+(i+1)).children(".smallImageInfo").css("height",newHeight);
        }
    });