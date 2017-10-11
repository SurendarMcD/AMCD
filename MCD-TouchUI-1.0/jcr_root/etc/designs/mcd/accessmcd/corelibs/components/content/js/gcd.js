  
    
function cancel()
 {
  var currentHost = window.location.hostname;
  var prevURL =  document.referrer;   
  if(prevURL.indexOf(currentHost) > -1 || prevURL == '' )
  {
  // window.location.href = document.referrer;
 // window.open(document.referrer,"_self");
 window.history.back();
  }
  else      
  {
   window.location.href =window.location.protocol + "//" + window.location.host
  }
 }
 
   
function openWindow(url,helpheight,helpwidth)
{
 window.open(url,"Help",'width=' + helpwidth + ',height=' + helpheight + ',scrollbars=yes,resizable=yes');
}  
    
     

// regular expression representing valid building code(s)
var validBldgCd1 = /^\d+$/; 

// regular expressions representing valid phone numbers
var validPhone1 = /^\d\d\d\d\d\d\d\d\d\d$/; 
var validPhone6 = /^\(\d\d\d\)\d\d\d-\d\d\d\d$/; 
var validPhone7 = /^\d\d\d-\d\d\d-\d\d\d\d$/; 
var validPhone8 = /^\(\d\d\d\) \d\d\d-\d\d\d\d$/; 

// validate the format of all phone numbers


// Functions to remove space from begining and end of the string.

function LTrim( value ) {

    var re = /\s*((\S+\s*)*)/;
    return value.replace(re, "$1");

}

// Removes ending whitespaces
function RTrim( value ) {

    var re = /((\s*\S+)*)\s*/;
    return value.replace(re, "$1");

}

// Removes leading and ending whitespaces
function trim( value ) {

    return LTrim(RTrim(value));

}


// reformat bldg codes
function formatBldgCode( fieldObject )
{
    var oldBldgCd = fieldObject.value;
    
    if( oldBldgCd==null || oldBldgCd=="" || oldBldgCd.length==0 || oldBldgCd=="0" || oldBldgCd==0)
    {
       return false;
    }
    
      // this check for the a case of "00000" etc.
 /*   if( parseInt(oldBldgCd) == 0 )
    {
     return false;
    }*/

    // valid format is one or more digits
    if( validBldgCd1.test(oldBldgCd))
    {
        fieldObject.value = oldBldgCd;
        return true;
    }

    return false;
}

//format bldg names
function formatBldgName( fieldObject)
{
    var oldBldgName = fieldObject.value;

    if( oldBldgName==null || trim(oldBldgName)=="")
    {
        return false;
    }



}
    
// reformat phone numbers
function formatPhoneNumber( fieldObject )
{
    var oldPhoneNumber = fieldObject.value;

    if( oldPhoneNumber==null || oldPhoneNumber=="" || oldPhoneNumber.length==0)
    {
        return true;
    }

// valid format is: 7777777777
if( validPhone1.test(oldPhoneNumber))
{
    // reformat the number for display
    fieldObject.value = "(" + oldPhoneNumber.substring(0,3) + ") " +
                        oldPhoneNumber.substring(3,6) + "-" +
                        oldPhoneNumber.substring(6,10);
            
    return true;
}   

// valid format is: (777)777-7777
if( validPhone6.test(oldPhoneNumber))
{
    // reformat the number for display
    fieldObject.value = "(" + oldPhoneNumber.substring(1,4) + ") " +
                        oldPhoneNumber.substring(5,8) + "-" +
                        oldPhoneNumber.substring(9,13);
                        
    return true;
}

// valid format is: 777-777-7777
if( validPhone7.test(oldPhoneNumber))
{
    // reformat the number for display
    fieldObject.value = "(" + oldPhoneNumber.substring(0,3) + ") " +
                        oldPhoneNumber.substring(4,7) + "-" +
                        oldPhoneNumber.substring(8,12);
                
    return true;
}       

// valid format is: (777) 777-7777
if( validPhone8.test(oldPhoneNumber))
{
    return true;
}

return false;                   
} 

    
    

      
