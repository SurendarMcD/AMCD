var tableIdFlag=parseInt("0");
var traverseBack=parseInt("0");
var traverseNext=tableIdFlag+1;

$('[id^="table_"]').css('display','none');

$(document).ready(function(){

    $('[id^="table_"]').css('display','none');
    $('#table_0').css('display','block'); 
    if($("#table_1").attr('id')){
        $("#next").css('display','block');
    }   
    $("#pre").css('display','none');    
    
});

$("#next").click(function(){    
    pastStoriesNext(tableIdFlag, traverseNext, traverseBack);
    tableIdFlag++;      
    traverseNext++;
    traverseBack++;     
});
$("#pre").click(function(){
    pastStoriesPrev(tableIdFlag, traverseNext, traverseBack);
    traverseBack--;
    tableIdFlag--;
    traverseNext--;    
});