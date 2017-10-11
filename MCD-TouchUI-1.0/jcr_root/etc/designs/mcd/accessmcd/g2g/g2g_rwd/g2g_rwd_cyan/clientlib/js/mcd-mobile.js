$(document).ready(function () {

/* Added to achieve fluid layout */

//START

    var left_sec_height= $('#left-widgets-column').height();  
    if (left_sec_height == null || left_sec_height == 0)
    {
        $('#right-results-column').css('min-width','0');
        $('#right-results-column').css('max-width','100%');        
    }else
    {
        $('#left-widgets-column').css('width','25%');
        $('#right-results-column').css('min-width','0');
        $('#right-results-column').css('max-width','72%');        

        
    }
    
    //$('#left-widgets-column').css('margin','0 2% 0 0');
    //$('#left-widgets-column').css('width','25%');
    //$('#right-results-column').removeAttr('style');    
    //$('#right-results-column').css('max-width','73%');
    //$('#right-results-column').css('float','left');
    $('#content_txt').removeAttr('style');      
    //$('#pagecontentwrapper').css('width','72%');
    
//END



    //$('#nav a:first').addClass('menuLeft');
    //$('#nav a:last').addClass('menuRight');

    //$( "li" ).last().css( "background-color", "red" );
 
});








