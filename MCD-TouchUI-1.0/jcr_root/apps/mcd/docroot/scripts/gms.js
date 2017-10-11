
function isProductNameValid(){

    var h= document.getElementById("TR_Product_Name").value.length;
    var x= document.getElementById("TR_Product_Name").value;
    var flag = 0;
        
    for( i=0;i<h;i++) { 
        vAscii = x.charCodeAt(i);
        if((vAscii == 34) || (vAscii == 37) || (vAscii == 60)) {
          flag =1;          
        }       
    } 
    
    if(flag ==1) {
        return false;
    } else {
        return true;
    }   
}

var sInvalidChars
sInvalidChars="1234567890";
var iTotalChecked=0;
var errorMessages = new Array();
function checkNumericVals(objV,  msg)
{
    for(var i=0;i<sInvalidChars.length;i++)
    {
        if(objV.value.indexOf(sInvalidChars.charAt(i))!=-1)
        {
            //alert(msg);
            objV.focus();
            return false;
        }
    }
    return true;
}

function objChecked(obj)
{
    if(obj.checked)
        iTotalChecked = iTotalChecked + 1
    else
        iTotalChecked = iTotalChecked - 1
}


//Desc      : This function is used to check that Password contains minimum valid characters(numbers & alphabets only) 
//Arguments : password field name ,minimum characters to check.
function CheckPasswordForValidStringAndLength(fldPass,minChars)
{
    
    h = fldPass.value.length;
    x = fldPass.value;
    if (  h < minChars )
    {
                    alert(" Password can't be less than " + minChars + " characters");
                    fldPass.focus();
                    fldPass.select();
                    return false;
    }
    for( i=0;i<h;i++)
    {
        vAscii = x.charCodeAt(i)
        if((vAscii >= 65 && vAscii <= 90) || (vAscii >= 97 && vAscii <= 122) || (vAscii >= 45 && vAscii <= 57))
        {
        flag = 1;
        }
        else
        {
                    alert("Only alphabets and numbers are allowed in Password field");
                    fldPass.focus();
                    fldPass.select();
                    return false;
        }
    }
    return true;
}


//Purpose   : This function is used to check that Password contains minimum characters and confirm Password matches the password. 
//Arguments : password field name , confirm password field name, minimum characters to check.
function CheckConfirmPassword(fldPass,fldConPass,minChars)
{
        if(fldPass.value.length == 0)
        {
            alert("Please enter your password");
            fldPass.focus();
            fldPass.select();
            return false;
        }
        h = fldPass.value.length;
        x = fldPass.value.value;

            for( i=0;i<h;i++)
            {
             
                if (  h < minChars )
                {
                                alert(" Password can't be less than " + minChars + " characters");
                                fldPass.focus();
                                fldPass.select();
                                return false;
                }


            }
        //=============================


        if(fldConPass.value.length == 0)
        {
            alert("Please re-enter your password");
            fldConPass.focus();
            fldConPass.select();
            return false;
        }
    
        if(fldPass.value != fldConPass.value)
        {
            alert("Please ensure that you have entered the same password twice");
            fldConPass.focus();
            fldConPass.select();
            return false;
        }
    return true;

}



//Purpose   : This function is used to check that username does not contain any spaces. 
//Arguments : field name object, field alias to be used, character to be checked
function CheckCharWithinField(fldName, fldAlias, chkChar)
{
        b= fldName.value.length
        x= fldName.value
        
        if (x == "")
        {
            alert ("Please Enter Your " + fldAlias)
            fldName.focus();
            fldName.select();
            return false;
        }

        for( i=0;i<b;i++)
        {
            z = x.substring(i,i+1);
            if(z== chkChar)
            {
                alert("Please enter valid " + fldAlias + " without any '" + chkChar + "' in-between");
                fldName.focus();
                fldName.select();
                return false;
            }
        }
        //------------------------------
        return true;
}


//Purpose   : This function is used to check all the checkboxes basedon state of chk checkbox. 
//Arguments : checkbox object
function CheckAll(chk)
{
    for (var i=0;i < document.forms[0].elements.length;i++)
    {
        var e = document.forms[0].elements[i];
        if (e.type == "checkbox")
        {
            e.checked = chk.checked;
        }
    }
}

function fnRemoveSpaces(sFldval)
{
    var sTemp=sFldval;
  var sNewval=sTemp;
  //remove spaces from the front
  for(var i=0;i<sTemp.length;i++)
  { 
        if(sTemp.charAt(i)!=" ")
            break;
        else
            sNewval = sTemp.substring(i+1);
    }
    return sNewval;
}

//Purpose   : This function is used to remove spaces. 
//Arguments : text field object value
function fnFixSpace(sFldval)
{
  var sTemp=sFldval;
  var sReversedString="";
  var sTemp1;
  
  //remove spaces from the front
  sNewval = fnRemoveSpaces(sTemp);
  
  // reverse n remove spaces from the front
  for(var i=sNewval.length-1;i>=0;i--)
        sReversedString = sReversedString + sNewval.charAt(i);
    sTemp1 = fnRemoveSpaces(sReversedString);
    //reverse again
    sReversedString="";
    for(var i=sTemp1.length-1;i>=0;i--)
        sReversedString = sReversedString + sTemp1.charAt(i);
    sNewval = sReversedString;
    return sNewval;
}


//Purpose   : This function is used to validate email. 
//Arguments : Email object
function ValidateEMail(objName)
{
    var sobjValue;
    var iobjLength;
    
    sobjValue=objName;
    iobjLength=sobjValue.length;
    iFposition=sobjValue.indexOf("@");
    iSposition=sobjValue.indexOf("."); 
    iTmp=sobjValue.lastIndexOf(".");    
    iPosition=sobjValue.indexOf(",");
    iPos=sobjValue.indexOf(";");
    
    if (iobjLength!=0)
    {
        if ((iFposition == -1)||(iSposition == -1))
        {
            return false;
        }
        else if(sobjValue.charAt(0) == "@" || sobjValue.charAt(0)==".")
        {
            return false;               
        }
        else if(sobjValue.charAt(iobjLength) == "@" ||
sobjValue.charAt(iobjLength)==".")
        {
            return false;               
        }   
        else if((sobjValue.indexOf("@",(iFposition+1)))!=-1)
        {   
            return false;
        }
        else if ((iobjLength-(iTmp+1)<2)||(iobjLength-(iTmp+1)>4))
        {
            return false;
        }
        else if ((iPosition!=-1) || (iPos!=-1))
        {
            return false;
        }
        else
        {
            return true;
        }       
    }       
}


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}


/*--------------------------------------------------------------------------------------
    this sub routine checks for the mandatory fields, their data types and maximum length
    also validates valid email entered or not
    Return : True/False
    Input : objFrm ( form object name)
    Programmer : 
----------------------------------------------------------------------------------------*/
function ValidateForm(objFrm)
{
    
    var iConventionPos;
    var sChangedName;
    for( var i =0; i< objFrm.length;i++)
    {
        //alert(i + "th form element: " + objFrm[i].type + "\n" + objFrm[i].name);
        /// Generic Coding Begins Here
        if(objFrm[i].type=='text' || objFrm[i].type=='textarea' || objFrm[i].type=='select-one' || objFrm[i].type=='select-multiple' || objFrm[i].type=='password')
        { //alert("first"+objFrm[i].type);
            if(objFrm[i].type=='text' || objFrm[i].type=='textarea' || objFrm[i].type=='password'){
                //alert("inside first if "+ "\n" + objFrm[i].type + "\n" + objFrm[i].name + "\n" + objFrm[i].style.display);
                // For all the text fields that are mandatory, but not displayed
                if(objFrm[i].type=='text' && objFrm[i].style.display == 'none'){
                    continue;
                }
                if(objFrm[i].type=='text' && objFrm[i].disabled == true){
                    //alert('Inside type==text && disabled == true');
                    continue;
                }
                objFrm[i].value = fnFixSpace(objFrm[i].value);
            }
            
            var objDataTypeHolder = objFrm[i].name.substring(0,3);

            if(objFrm[i].name.substring(0,5)=='TREF_' || objFrm[i].name.substring(0,5)=='TNEF_')
                objDataTypeHolder = objFrm[i].name.substring(0,5);

            if(objFrm[i].name.substring(0,4)=='TRC_' || objFrm[i].name.substring(0,5)=='TNC_')
                objDataTypeHolder = objFrm[i].name.substring(0,4);
            
            if(objFrm[i].name.substring(0,6)=='TRURL_')
                objDataTypeHolder = objFrm[i].name.substring(0,6);

            if(objFrm[i].name.substring(0,6)=='TNURL_')
                objDataTypeHolder = objFrm[i].name.substring(0,6);

            /*
            If the first option("helper text") is selected, it has a value==''; Alert the user to select an option in list.
            */
            if((objFrm[i].type=='select-one' && (objFrm[i].options[objFrm[i].selectedIndex].value=='default' || objFrm[i].options[objFrm[i].selectedIndex].value=='') && objDataTypeHolder=="TR_"))
            {//alert("checking dropdowns");
                sChangedName = objFrm[i].name.substring(3);
                //alert(sChangedName );
                sChangedName = getFormattedmsg(sChangedName)
                //alert(sChangedName );
                if(errorMessages[objFrm[i].name+'_BLANK']){
                    alert(errorMessages[objFrm[i].name+'_BLANK']);
                } else {
                    alert("Please select "+ sChangedName +".");
                }
                objFrm[i].focus();
                return false; 
                break;
            }

            if((objDataTypeHolder=="TNURL_") )
            {
                sChangedName = objFrm[i].name.substring(6);
                sChangedName = getFormattedmsg(sChangedName)
                if(objFrm[i].value!="")
                {
                    if(!isURL(objFrm[i].value,sChangedName))
                    {
                        objFrm[i].focus();
                        objFrm[i].select();
                        return false;
                        break;
                    }
                }
            }

            if((objDataTypeHolder=="TRURL_") )
            {
                sChangedName = objFrm[i].name.substring(6);
                sChangedName = getFormattedmsg(sChangedName)
                if(objFrm[i].value=="")
                {
                    if(errorMessages[objFrm[i].name+'_BLANK']){
                        alert(errorMessages[objFrm[i].name+'_BLANK']);
                    } else {
                        alert("Please enter "+ sChangedName +".");
                    }

                    objFrm[i].focus();
                    objFrm[i].select();
                    return false;
                    break;
                }
                //alert(isURL(objFrm[i].value));
                if(!isURL(objFrm[i].value,sChangedName))
                {
                    objFrm[i].focus();
                    objFrm[i].select();
                    return false;
                    break; 
                }
            }

            if((objDataTypeHolder=="TR_" || objDataTypeHolder=="IR_" || objDataTypeHolder=="MR_"  )&& (objFrm[i].value==''))
            {   //alert("checking dropdownsTr_/MR_");
                //alert(objFrm[i].type);
                sChangedName = objFrm[i].name.substring(3);
                //alert(sChangedName);
                sChangedName = getFormattedmsg(sChangedName)
                //alert(sChangedName);
                if(errorMessages[objFrm[i].name+'_BLANK']){
                    alert(errorMessages[objFrm[i].name+'_BLANK']);
                } else {
                        alert("Please enter "+ sChangedName +".");
                }
                objFrm[i].focus();
                return false;
                break;
            }
            if((objDataTypeHolder=="TRC_")&& (objFrm[i].value==''))
            {   
                sChangedName = objFrm[i].name.substring(4);
                sChangedName = getFormattedmsg(sChangedName)
                if(errorMessages[objFrm[i].name+'_BLANK']){
                    alert(errorMessages[objFrm[i].name+'_BLANK']);
                } else {
                    alert("Please enter "+ sChangedName +".");
                }
                objFrm[i].focus();
                return false;
                break;
            }
            if(objDataTypeHolder=="TREF_" && objFrm[i].value=='')
            {
                sChangedName = objFrm[i].name.substring(5);
                sChangedName = getFormattedmsg(sChangedName)
                if(errorMessages[objFrm[i].name+'_BLANK']){
                    alert(errorMessages[objFrm[i].name+'_BLANK']);
                } else {
                    alert("Please enter "+ sChangedName +".");
                }
                objFrm[i].focus();
                objFrm[i].select();
                return false; 
                break;
            }

            if(objFrm[i].type=='password' && objFrm[i].value!='' && objFrm[i].value.indexOf(" ")!=-1)
            {
                alert("Spaces are not allowed in password.");
                objFrm[i].select();
                return false;
                break;
            }

            if(objFrm[i].type=='password' && objFrm[i].value!='' && objFrm[i].name=='TR_Password')
            {
                
                if(!CheckPasswordForValidStringAndLength(objFrm[i],6))
                    return false;
                
            }
            
            if(objFrm[i].type=='password' && objFrm[i].name=='TR_Confirm_Password' && objFrm[i].value!=objFrm.TR_Password.value)
            {
                alert("Password and Confirm password fields are not matching.");
                objFrm[i].select();
                return false;
                break;
            }
            
            if(objFrm[i].type=='password' && objFrm[i].name=='TN_Confirm_password' && objFrm[i].value!=objFrm.TN_Password_temp.value)
            {
                alert("Password and Confirm password fields are not matching.");
                objFrm[i].select();
                return false;
                break;
            }

            if(objFrm[i].type=='text' && objFrm[i].name=='TREF_Confirm_Email_address' && objFrm[i].value!=objFrm.TREF_Email_address.value)
            {
                alert("Email address and Confirm Email address fields are not matching.");
                objFrm[i].select();
                return false;
                break;
            }

            if((objDataTypeHolder=="IR_" || objDataTypeHolder=="MR_" )&& (isNaN(objFrm[i].value)))
            {
                sChangedName = objFrm[i].name.substring(3);
                sChangedName = getFormattedmsg(sChangedName)
                alert("Please enter numeric "+ sChangedName +".");
                objFrm[i].focus();
                objFrm[i].select();
                return false;
                break;
            }
            if((objDataTypeHolder=="IR_" || objDataTypeHolder=="MR_" )&& (objFrm[i].value<=0))
            {
                sChangedName = objFrm[i].name.substring(3);
                sChangedName = getFormattedmsg(sChangedName)
                alert("Please enter valid "+ sChangedName +".");
                objFrm[i].focus();
                objFrm[i].select();
                return false;
                break;
            }
            if((objDataTypeHolder=="IN_" || objDataTypeHolder=="MN_" )&& (isNaN(objFrm[i].value) && objFrm[i].value!='' ))
            {
                sChangedName = objFrm[i].name.substring(3);
                sChangedName = getFormattedmsg(sChangedName)
                alert("Please enter numeric "+ sChangedName +".");
                objFrm[i].focus();
                objFrm[i].select();
                return false;
                break;
            }
            if((objDataTypeHolder=="IN_" || objDataTypeHolder=="MN_" )&& (objFrm[i].value<=0 && objFrm[i].value!=''))
            {
                sChangedName = objFrm[i].name.substring(3);
                sChangedName = getFormattedmsg(sChangedName)
                alert("Please enter valid "+ sChangedName +".");
                objFrm[i].focus();
                objFrm[i].select();
                return false;
                break;
            }
            if((objDataTypeHolder=="IR_" || objDataTypeHolder=="IN_" ) && (objFrm[i].value.indexOf(".")!=-1))
            {
                sChangedName = objFrm[i].name.substring(3);
                sChangedName = getFormattedmsg(sChangedName)
                alert("Please enter valid "+ sChangedName +".");
                objFrm[i].focus();
                objFrm[i].select();
                return false;
                break;
            }
            if((objDataTypeHolder=="TREF_") || (objDataTypeHolder=="TNEF_" && objFrm[i].value!='' ))
            {
                if(!ValidateEMail(objFrm[i].value))
                {
                    sChangedName = objFrm[i].name.substring(5);
                    sChangedName = getFormattedmsg(sChangedName)
                    alert("Please enter valid "+ sChangedName +".");
                    objFrm[i].focus();
                    objFrm[i].select();
                    return false;
                    break;
                }
            }
            if(objDataTypeHolder=="TRC_" && objFrm[i].value!='')
            {
                bb11= objFrm[i].value.length;
                x= objFrm[i].value;
                for( p=0;p<bb11;p++)
                {
                    z = x.substring(p,p+1);
                    if (  (z >="1" && z <= "9") || (bb11 > 30 )||z=='"' || z=="'")
                        {
                            sChangedName = objFrm[i].name.substring(4);
                            sChangedName = getFormattedmsg(sChangedName)
                            alert("Please enter correct "+ sChangedName +".");
                            objFrm[i].focus();
                            objFrm[i].select();
                            return false;
                        }
                }
            }

            if(objDataTypeHolder=="TNC_" && objFrm[i].value!='')
            {
                bb11= objFrm[i].value.length;
                x= objFrm[i].value;
                for( p=0;p<bb11;p++)
                {
                    z = x.substring(p,p+1);
                    if (  (z >="1" && z <= "9") || (bb11 > 30 )||z=='"' || z=="'")
                        {
                            sChangedName = objFrm[i].name.substring(4);
                            sChangedName = getFormattedmsg(sChangedName)
                            alert("Please enter correct "+ sChangedName +".");
                            objFrm[i].focus();
                            objFrm[i].select();
                            return false;
                        }
                }
            }

            //ValidateNumber(objName)
            if((objDataTypeHolder=="NR_"))
            {
                if(!ValidateNumber(objFrm[i].value))
                {
                    objFrm[i].focus();
                    return false;
                    break;
                }
            }           
            if(objDataTypeHolder=="PHR")
            {
                var val=objFrm[i].value;
                if (val!="")
                {
                    for(var j=0; j < val.length;j++)
                    {
                        if((val.charAt(j)!='(')&&(val.charAt(j)!=')')&&(val.charAt(j)!=' ')&&(val.charAt(j)!="-")&& !((val.charAt(j)>=0)&&(val.charAt(j)<=9)))
                        {
                            alert("Please enter valid Phone Number");
                            objFrm[i].focus();
                            objFrm[i].select();
                            return false;
                            break;
                        }
                    }
                }
                else
                {
                    if(errorMessages[objFrm[i].name+'_BLANK']){
                        alert(errorMessages[objFrm[i].name+'_BLANK']);
                    } else {
                        alert("Please Enter Phone Number");
                    }
                    objFrm[i].focus();
                    objFrm[i].select();
                    return false;
                    break;
                }
            }
            //ValidateNumber(objName)
            if((objDataTypeHolder=="NR_"))
            {
                if(!ValidateNumber(objFrm[i].value))
                {
                    objFrm[i].focus();
                    return false;
                    break;
                }
                if(parseFloat(objFrm[i].value)<=0)
                {
                    objFrm[i].focus();  
                    alert('Price should be greater then 0');
                    return false;
                }
            }
            if(objDataTypeHolder=="PHN")
            {
                var val=objFrm[i].value;
                if (val!="")
                {
                    for(var j=0; j < val.length;j++)
                    {
                        if((val.charAt(j)!='(')&&(val.charAt(j)!=')')&&(val.charAt(j)!=' ')&&(val.charAt(j)!="-")&& !((val.charAt(j)>=0)&&(val.charAt(j)<=9)))
                        {
                            alert("Please enter valid Fax Number");
                            objFrm[i].focus();
                            objFrm[i].select();
                            return false;
                            break;
                        }
                    }
                }               
            }
        }
        // validation for radio buttons begins
        if(objFrm[i].type == 'radio'){
            var radioButtonObjArray = document.getElementsByName(objFrm[i].name);
            if(checkRadio(radioButtonObjArray) == null){
                sChangedName = objFrm[i].name;
                sChangedName = objFrm[i].name.substring(3);
                sChangedName = getFormattedmsg(sChangedName)
                i = i + (radioButtonObjArray.length-1);
                alert("Please select one of the option for: " + sChangedName); 
                return false;
                break;
            }
            i = i + (radioButtonObjArray.length-1);
        }// validation for radio buttons ends
        
        // validation for checkbox buttons begins
        
        if(objFrm[i].type == 'checkbox' && objFrm[i].name.indexOf('CHR_' == 0) && objFrm[i].name!='Archieve_Item'){
            var checkboxObjArray = document.getElementsByName(objFrm[i].name);
            var checkBoxeValue = "";
            var atLeastOneIsChecked = false;
            
            for(var counter = 0; counter < checkboxObjArray.length; counter++){ 
                if(checkboxObjArray[counter].checked){
                    atLeastOneIsChecked = true;
                    /*//check for value - OTHER_
                    checkBoxeValue = checkboxObjArray[counter].value;
                    if(checkBoxeValue.indexOf('other') == 0 && objFrm[i+counter+1] != null){
                        if(objFrm[i+counter+1].type == 'text'){
                            //alert("arrived here");
                            alert("HellosPlease enter " + objFrm[i+counter+1].name.substring(3) + "\n" + objFrm[i+counter+1].style.display);
                            return false;
                            break;
                        }
                    }
                    */
                }
            }
            if(!atLeastOneIsChecked){
                sChangedName = objFrm[i].name.substring('CHR_'.length);
                sChangedName = getFormattedmsg(sChangedName);
                alert("Please select one of the option for: " + sChangedName); 
                return false;
                break;
            }
            
            i = i + (checkboxObjArray.length-1);        
        } // validation for checkbox buttons ends
        /// Generic Coding Ends Here
    }
   
    if( checkMaxLngth(document.getElementById('TR_Product_Description'), 1500) == false) 
        return false;
        
        
    if( checkMaxLngth(document.getElementById('TR_Sales_Information'), 1500) == false)
        return false;
        
    if( checkMaxLngth(document.getElementById('Consumer_Objective'), 1500) == false)
        return false;
         
    if( checkMaxLngth(document.getElementById('Key_Learnings'), 1500) == false)
        return false;
        
        
    if( checkMaxLngth(document.getElementById('TR_Keywords'), 300) == false)
        return false;
         
        
    /*if( checkMaxLngth(document.getElementById('Multiple_Versions_/ Variations'), 1000) == false)
        return false;
          alert('Multiple');*/
          
    if( checkMaxLngth(document.getElementById('TR_Business_Objective'), 2000) == false) 
        return false;
      
    if(checkEmail(document.getElementById('TR_Contact_Email'))==false)
        return false;
     
    if(validateLaunchDate(document.getElementById('TR_Launch_Date'), document.getElementById('TR_Date_Off_Menu'))==false )
        return false;
        
    if(validateProductPhoto(document.getElementById('TR_Product_Photo') ) == false )
        return false;
      
    if(ValidatePriceValue(document.getElementById('TR_Menu_Item_Price') ) == false )
        return false;
       
    if(ValidatePriceValue(document.getElementById('TR_Menu_Price_of_a_Cheeseburger') ) == false )
        return false;
       
    if(ValidatePriceValue(document.getElementById('TR_Menu_Price_of_a_Big_Mac') ) == false )
        return false;

    return true; 
} 

function validateProductPhoto(productPhotoObj){
    var productPhotoObjName = productPhotoObj.name;
    if(document.getElementById('Product_Photo_DIV') == null){ // No Img div is there, for ADD Product Form
        if(productPhotoObj.value == ''){
                productPhotoObjName = productPhotoObjName.substring(3);
                productPhotoObjName = getFormattedmsg(productPhotoObjName);
                alert("Please upload the image for: " + productPhotoObjName);
                return false;
            } else{
            
            var extensionPos = productPhotoObj.value.lastIndexOf(".");
            var productPhotoExtension = productPhotoObj.value.substring(extensionPos + 1, productPhotoObj.value.length);

            var validExtensionNames = new Array();
            validExtensionNames[0] = "jpg";
            validExtensionNames[1] = "jpeg";
            validExtensionNames[2] = "gif";
            validExtensionNames[3] = "png";
            validExtensionNames[4] = "bmp";

            var extensionValid = false;         

            for (var count = 0; count < validExtensionNames.length; count++) {
                if(validExtensionNames[count] == productPhotoExtension) {
                    extensionValid = true;  
                }
            }
            if(extensionValid != true){
                productPhotoObjName = productPhotoObjName.substring(3);
                productPhotoObjName = getFormattedmsg(productPhotoObjName);
                alert("Please upload an image file for " + productPhotoObjName + " with one of the following extensions: \n"+ validExtensionNames.join(', ') +".");
                productPhotoObj.value = '';
                productPhotoObj.focus();
                return false;
            }
        }   
    }
    return true;
}




function validateLaunchDate(launchDateObj,OffMenuDateObj){
        
    if(OffMenuDateObj.style.display == "none"){

        return true;
    }
    
    //var launchDate = new Date(eval(launchDateObj.value.substring(0,2)),eval(launchDateObj.value.substring(3,5)),eval(launchDateObj.value.substring(6))); 
    //var offMenuDate = new Date(eval(OffMenuDateObj.value.substring(0,2)),eval(OffMenuDateObj.value.substring(3,5)),eval(OffMenuDateObj.value.substring(6))); 
    var launchDatetr = launchDateObj.value;
    var OffMenuDateStr = OffMenuDateObj.value;
    //alert("Launch Date: " + launchDatetr + "\nOff Menu Date: " + OffMenuDateStr);

//  var launchDate = new Date(ldStr);
//  var offMenuDate = new Date(ofdStr);
    
    var dt1 = new Number(launchDatetr.substring(0,2));
    var dt2 = new Number(OffMenuDateStr.substring(0,2));
    var mon1 = new Number(launchDatetr.substring(3,5));
    var mon2  = new Number(OffMenuDateStr.substring(3,5));
    var yy1 = new Number(launchDatetr.substring(8));
    var yy2 = new Number(OffMenuDateStr.substring(8));

    
    //alert(dt1+"\n"+mon1 +"\n"+yy1);
    //alert(dt2+"\n"+mon2 +"\n"+yy2);
    
    var launchDate = new Date(yy1,(mon1-1),dt1,00,00,00,00);
    //launchDate.setFullYear(yy1,(mon1-1),dt1);
    var offMenuDate = new Date(yy2,(mon2-1),dt2,00,00,00,00);
    //offMenuDate.setFullYear(yy2,(mon2-1),dt2);
    //alert("Launch Date: " + launchDate +  "\n" + offMenuDate);


    if(launchDate > offMenuDate ){
        var launchDateStr = launchDateObj.name.substring('TR_'.length);
        var offMenuDateStr = OffMenuDateObj.name.substring('TR_'.length);
        //alert(launchDateStr );
       // alert(offMenuDateStr );
        launchDateStr = getFormattedmsg(launchDateStr);
        offMenuDateStr = getFormattedmsg(offMenuDateStr);
        
        alert(launchDateStr + " should be an earlier date than " + offMenuDateStr);
        return false;
    }
    return true;
    
    
}

function FormatDate(d)
{
        var dd,mm;
        var l;
        l=d.indexOf("/");
        dd=d.substring(0,l);
        d=d.substring(l+1);
        l=d.indexOf("/");
        mm=d.substring(0,l);
        yy=d.substring(l+1);
        
        if (parseInt(dd) < 10)
            dd="0" + dd;
        if (parseInt(mm) < 10)
            mm="0" + mm;
        d= dd + "/" + mm + "/" + yy
        return d;
}

function ValidateImg(objImg, isRequired)
{
    if(isRequired ==1 && objImg.value=='')
    {
        alert("Please enter image.");
        objImg.focus();
        return false;
    }
    if(objImg.value.length!=0)
    {
        if(objImg.value.length<5)
        {
            alert("Please enter valid image.");
            objImg.focus();
            objImg.select();
            return false;
        }
        var iPos = objImg.value.lastIndexOf(".")
        var sExt = objImg.value.substring(iPos);
        if((sExt.toUpperCase()=='.JPEG') || (sExt.toUpperCase()=='.JPG') || (sExt.toUpperCase()=='.GIF') || (sExt.toUpperCase()=='.BMP') )
        {
            return true;
        }
        else
        {
            alert("Please enter valid image.");
            objImg.focus();
            objImg.select();
            return false;
        }
    }
    return true;
}

function ValidateNumber(objName)
{
   
    //Purpose   : This function is used to validate email. 
    //Arguments : Email object
        
    var h;
    var x;
    
    h=objName.length;
    x = objName;
    /*if (h==0)
    {
        alert("arrived here - h == 0");
        alert("Price Can be numeric only");
        return false;
    }
    */          
    for( i=0;i<h;i++)
    {
        z = x.substring(i,i+1);
        if ( z=="'"||z=='"' || (z >= "a" && z <= "z" ) || (z >= "A" && z <= "Z") )
        {
            alert("Price Can be numeric only");
            return false;
        }           
    }
    jj=x.indexOf(".");
    if (jj != "-1") 
        {
        hh=x.substring(jj);
        ll=hh.length;
        if (ll > 3) 
            {
            alert("Price Can have upto 2 decimal places");
            return false;
            }
        }
    x = objName;
    return true;
    
}

function ValidatePriceValue(numericElementObj)
{
    
        
    //var h;
    //var x;
    var objValue = numericElementObj.value;
    objValLength = objValue.length;
    //x = objName;
    /*if (h==0)
    {
        alert("arrived here - h == 0");
        alert("Price Can be numeric only");
        return false;
    }
    */      
    //added
    var countryValSelected = '';
    countryValSelected=document.productForm.TR_Country.value;
   // alert(countryValSelected);
    if(countryValSelected == ''){
   
        sChangedName = numericElementObj.name.substring(3);
        //alert(sChangedName);
        sChangedName = getFormattedmsg(sChangedName);
        alert('Please select a country before providing the value for ' + sChangedName);
        //numericElementObj.value = "";
        document.productForm.TR_Country.focus();
        return false;
    }
    else{ 
            //alert("There was some value in country drop down: " + countryValSelected);
            if(objValLength > 0){
                        for( count=0;count < objValLength;count++){
                            tempSubString = objValue.substring(count,count+1);
                            if ( tempSubString=="'"||tempSubString=='"' || (tempSubString >= "a" && tempSubString <= "z" ) || (tempSubString >= "A" && tempSubString <= "Z") )
                            {
                                sChangedName = numericElementObj.name.substring(3);
                                sChangedName = getFormattedmsg(sChangedName);
                                alert("Please enter a numeric value for " + sChangedName + "\n Example: 10.11");
                //              numericElementObj.value = "";
                                numericElementObj.focus();
                                numericElementObj.select();
                                return false;
                    }           
                }
            } 
            var currLabelelements = document.getElementsByName("currencyLabel");
            
            //alert(trim(currLabelelements[0].innerHTML));
            if( trim(currLabelelements[0].innerHTML).indexOf('EUR') >-1 ){
                //put in formatting check for EUR
                            
                commaIndex = objValue.indexOf(",");
               // alert("objValue: "+objValue + "\n commaIndex " + commaIndex);
                if (commaIndex != -1) {
                    commaSubString = objValue.substring(commaIndex + 1);
                    //alert("commaSubString is : " + commaSubString);
                    //alert("Found one or more Decimal points; the value after first Decimal point is: " + decimalSubString);
        
                    if(commaSubString.indexOf(",") > -1){
            
                        alert("Found one more Comma Symbol");
                        //numericElementObj.value = numericElementObj.value.substring(0,commaIndex + (commaSubString.indexOf(",")+1));
                        sChangedName = numericElementObj.name.substring(3);
                        sChangedName = getFormattedmsg(sChangedName);
                        alert("There can be only one comma (decimal-seperator) - \',\' symbol in: " + sChangedName);
                        numericElementObj.focus();
                        numericElementObj.select();
                        return false;
                    }

                    commaSubStringLength = commaSubString.length;
                    
                    if (commaSubStringLength > 2){
                        sChangedName = numericElementObj.name.substring(3);
                        sChangedName = getFormattedmsg(sChangedName);
                        alert("There can be only 2 digits after - \',\' symbol in: " + sChangedName);
                        numericElementObj.focus();
                        numericElementObj.select();
                        return false;
                        }
                }
            }
            else {
                        
                decimalIndex = objValue.indexOf("."); 
                if (decimalIndex != -1) {
                    decimalSubString = objValue.substring(decimalIndex + 1);
                    //alert("Found one or more Decimal points; the value after first Decimal point is: " + decimalSubString);
        
                    if(decimalSubString.indexOf(".") > -1){
            
                        //alert("Found one more Decimal point");
                        numericElementObj.value = numericElementObj.value.substring(0,decimalIndex + (decimalSubString.indexOf(".")+1));
                        sChangedName = numericElementObj.name.substring(3);
                        sChangedName = getFormattedmsg(sChangedName);
                        alert("There can be only one decimal - \'.\' symbol in: " + sChangedName);
                        numericElementObj.focus();
                        numericElementObj.select();
                        return false;
                    }

                    decimalSubStringLength = decimalSubString.length;
                    if (decimalSubStringLength > 3){
                        sChangedName = numericElementObj.name.substring(3);
                        sChangedName = getFormattedmsg(sChangedName);
                        alert("There can be only 2 digits after - \'.\' symbol in: " + sChangedName);
                        numericElementObj.focus();
                        numericElementObj.select();
                        return false;
                        }
                }
            
            }
    }

    return true;
    
}

function trim(strTemp)
{
    return strTemp.replace(/^\s*/, "").replace(/\s*$/, ""); 
}

function checkname(pn, dipname)
{
        var n,s,z;
        n=0;
        s=0;
        z=pn.value.length;
        alert(pn.name + z);
        for(var i=0;i<z;i++)
        {       
            alert(pn.charCodeAt(i));
            if((pn.charCodeAt(i)>=48 && pn.charCodeAt(i)<=57))
                n=n+1;
            else
                s=s+1;
        }
        alert(pn.name + ' '+ n + ' ' + s);
        if (s==0)
        {
            alert(dipname + ' cannot be just numbers!!');
            return false;
        }
        else
        {
            return true;
        }
}

function getFormattedmsg(sVal)
{
    while(sVal.indexOf("_")!=-1)
    {
        sVal = sVal.replace("_", " ")
    }
    return sVal;
    
}


function isURL(argvalue,urlname)
{
    if (argvalue.indexOf(" ") != -1)
 {
  alert("Spaces not allowed in "+ urlname +"!");
     return false;
 }
  else if (argvalue.indexOf("http://") == -1)
    {
  alert(urlname +" must begin with a http://");
     return false;
 }
  else if (argvalue == "http://")
    {
  alert("Please enter complete "+ urlname +"!");
     return false;
 }
  else if (argvalue.indexOf("http://") > 0)
    {
  alert("http:// must come in the beginning of a "+ urlname);
     return false;
 }
 
  argvalue = argvalue.substring(7, argvalue.length);
  if (argvalue.indexOf(".") == -1)
   {
  alert("Please enter an extension like .com, .edu(etc) for "+ urlname +"!");
     return false;
 }
  else if (argvalue.indexOf(".") == 0)
   {
  alert("Please enter correct "+ urlname +"!");
     return false;
 }
  else if (argvalue.charAt(argvalue.length - 1) == ".")
    {
  alert("Please enter an extension after . like com, edu(etc) for "+ urlname +"!");
     return false;
 }
 
  if (argvalue.indexOf("/") != -1) {
    argvalue = argvalue.substring(0, argvalue.indexOf("/"));
    if (argvalue.charAt(argvalue.length - 1) == ".")
      {
  alert("Please enter correct "+ urlname +"!");
     return false;
 }
  }
 
if (argvalue.indexOf(":") != -1) {
    if (argvalue.indexOf(":") == (argvalue.length - 1))
     {
  alert("Please enter correct "+ urlname +"!");
     return false;
 }
    else if (argvalue.charAt(argvalue.indexOf(":") + 1) == ".")
      {
  alert("Please enter correct "+ urlname +"!");
     return false;
 }
    argvalue = argvalue.substring(0, argvalue.indexOf(":"));
    if (argvalue.charAt(argvalue.length - 1) == ".")
      {
  alert("Please enter correct "+ urlname +"!");
     return false;
 }
  }
 return true;
}
//




function check_other(val,obj1,obj2,ctrl_type,other_ctrl_name)
{
                /*


                function used to check that if other oprion is selected
                then the other text field also filled in and vice versa 

                Arguments Description:
                1.val ->value assigned to the other control
                2.obj1 -> other control reference
                3.obj2 -> reference for the control where user will enter other choices
                4.ctrl_type -> type of control i.e select or checkbox
                5.other_ctrl_name -> Caption of other control used in alert message 
                */
                
                if(ctrl_type=="chkbox")
                {
                    len=obj1.length;
                    
                    for(i=0;i<len;i++)
                    {
                        if(obj1[i].value==val && obj1[i].checked==true)
                        {
                            if(obj2.value=="")
                            {
                                
                                if(errorMessages[obj2.name+'_BLANK']){
                                    alert(errorMessages[obj2.name+'_BLANK']);
                                } else {
                                    alert("Please enter value");
                                }
                                obj2.focus();
                                return false;
                            }
                        }
                        else
                        {
                            if(obj2.value!="")
                            {
                                if(obj1[i].value==val)
                                {
                                    alert("Please select "+other_ctrl_name);
                                    obj1[i].focus();
                                    return false;
                                }
                            }
                        }
                    }


                }   //if(ctrl_type=="chkbox") ends
                else if(ctrl_type=="slct")
                {
                    if(obj1.value==val)
                    {
                        if(obj2.value=="")
                        {
                            if(errorMessages[obj2.name+'_BLANK']){
                                    alert(errorMessages[obj2.name+'_BLANK']);
                            } else {
                                alert("Please enter value");
                            }
                            obj2.focus();
                            return false;
                        }
                    }
                    else
                    {
                        if(obj2.value!="")
                        {
                            alert("Please select "+other_ctrl_name);
                            obj1.focus();
                            return false;
                        }
                        
                    }

                }   //else if(ctrl_type=="slct") ends
            
            
            return true;    
}   //end of function check_other





function chkMaxLngth(obj,num,caption)
{
    /*
   
    function used to check that object value length should no exceed num
    */

    if(obj.value.length>num)
    {
        alert(caption + " should not exceed "+ num + " characters ");
        obj.select();
        return false
    }

return true;
}   //chkMaxLngth() ends 




/* Function: formValidation
 * Author: Hemant Bellani
 * Description: This function is invoked to validate inputs on the Product Input Form when the user submits the form onChange        *              event is executed for the Country Drop Down List.
 */

function formValidation(formObj){ 

    // validate all the "Required" text fields for blank input
    if(ValidateForm(formObj) == false){
    // if one of the required fields was blank, return to the product form
        return false;
    } 
    else{
        // check for max-length
        
    }
}


//function checkMaxLngth(textFieldObj, maxLength, textFiledCaption)
function checkMaxLngth(textFieldObj, maxLength)
{
    var alertPrompt;
    var sChangedName = textFieldObj.name;
    //alert(sChangedName);
    if(sChangedName.substring(0,3)=='TR_'){
        //alert("Inside If for substring(0,3)==\'TR_\'" + sChangedName);
        sChangedName = sChangedName.substring(3);
    }
    
    sChangedName = getFormattedmsg(sChangedName);
    //alert(sChangedName);

    if(maxLength > 1 ){
        alertPrompt = "The maximum character length allowed for " + sChangedName + " is: " + maxLength + " characters.";
    }
    else {
        alertPrompt = "The maximum character length allowed for " + sChangedName + " is: " + maxLength + " character.";
    }
    if(textFieldObj.value.length > maxLength)
    {
        alert(alertPrompt);
        textFieldObj.select();
        return false;
    }

return true;
}   //checkMaxLngth() ends 


function checkRadio(radioButtonObjArray) { 
            
            var myOption = -1; 
            for (count = radioButtonObjArray.length-1; count > -1; count--) { 
                if (radioButtonObjArray[count].checked) { 
                    myOption = count; count = -1; 
                }
            } 
            if(myOption == -1) { 
                return null; 
            } 
            else 
                return radioButtonObjArray[myOption].value; 
}

function toggleOtherMenuItem(checkboxObj,textBoxID) {
     if(checkboxObj.value=='other'){
    document.getElementById(textBoxID).style.display = (checkboxObj.checked) ? 'block' : 'none';
    return;
    } 
} 


function toggleOtherMenu(textBoxID) {
    document.getElementById(textBoxID).style.display = 'block';
    return;
}


function validateCheckBox(checkboxObjArray){
    var myOption = -1; 
    for (count = checkboxObjArray.length-1; count > -1; count--) { 
    if (checkboxObjArray[count].checked) { 
        myOption = count; count = -1; 
        }
    } 
    if(myOption == -1) { 
        return null;
    } 
    else 
        return checkboxObjArray[myOption].value; 
}


function ShowDatePicker(obj) {    
    document.getElementById('date_txt').style.display="block";
    document.getElementById('TR_Date_Off_Menu').style.display="block";
}

function HideDatePicker(obj){    
    document.getElementById('date_txt').style.display="none";
    document.getElementById('TR_Date_Off_Menu').style.display="none";
    document.getElementById('TR_Date_Off_Menu').value="";
}

function showMenuID()
{ 

document.getElementById('TR_Menu_Item_ID').disabled=false;
document.getElementById('TR_Menu_Item_ID').value='';
document.getElementById('menuItemIdAsterisk').style.display="inline-block";
$("#merlinErrorDiv").css("display","none"); 
} 

function hideMenuID()
{
 
document.getElementById('TR_Menu_Item_ID').disabled=true;
document.getElementById('TR_Menu_Item_ID').value='NA';
document.getElementById('menuItemIdAsterisk').style.display="none";
$("#merlinErrorDiv").css("display","none"); 
}


function showMenuIDFilled()
{

document.getElementById('TR_Menu_Item_ID').disabled=false;
document.getElementById('menuItemIdAsterisk').style.display="block";
}


function checkEmail(emailFieldObj) {

if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(emailFieldObj.value)){
return (true);
}
sChangedName = emailFieldObj.name.substring(3);
sChangedName = getFormattedmsg(sChangedName);
emailFieldObj.focus();
emailFieldObj.select();
alert(sChangedName + " is an invalid E-mail Address. Please re-enter.");
return (false)
}


function addOption(selectbox,text,value )
    {
        var optn = document.createElement("OPTION");
        optn.text = text;
        optn.value = value;
        selectbox.options.add(optn);
    }
    
    function removeAllOptions(selectbox)
    {
        var i;
        for(i=selectbox.options.length-1;i>=0;i--)
        {
            selectbox.remove(i);
        }
    }
     
  
function check(e, areaOfWorld){

        var AOWvalue = e.value;
        var data = areaOfWorld.split('/');  
        var dropdownHtml = "<option value='default'>Select Country</option>";      
        if(AOWvalue == 'default'){
            $('.currLabelDiv .currencyLabel').html('');
            $('#currLabelDiv #currencyLabel').html('');
        }
        
       else{
            for(i=0;i<data.length; i++) {
                if(data[i].indexOf(AOWvalue)>-1) {
                    var countryList = (data[i].split(',')[1]).split('|');
                     for(j=0;j<countryList.length;j++){ 
                    var currencyList=(countryList[j].split('_'));               
                     dropdownHtml += "<option value='" + currencyList[0]+ "'>"+currencyList[0] +"</option>";                              
                    
                    } 
                }
           }
           }
        
   $('#productform #TR_Country').html(dropdownHtml); 
       
}
              
               
function updateCurrencyLabel(country, areaOfWorld){
        
        var AOWvalue = country.value;
        var data = areaOfWorld.split('/');
        var spanval="";
        if(AOWvalue=='default') {
            $('.currLabelDiv .currencyLabel').html('');
            $('#currLabelDiv #currencyLabel').html('');
        } else {
            for(i=0;i<data.length; i++) {
                 if(data[i].indexOf(AOWvalue)>-1) {
                    var countryList = (data[i].split(',')[1]).split('|');
                         for(j=0;j<countryList.length;j++){     
                            var currencyList=(countryList[j].split('_'));
                                if(AOWvalue==currencyList[0]){
                                spanval = currencyList[1];    
                               $('.currLabelDiv .currencyLabel').html(spanval );
                               $('#currLabelDiv #currencyLabel').html(spanval );
                               $('#currencyVal').val(spanval);
                               $('#currencyVal').hide();                                
                                //alert($('#currencyVal').val(spanval));
                                 }   
                             }
                
              } 
           }        } 
}

function validate(formButton){
   //alert(formButton);
   //alert("inside the valdate method");
    if(!isProductNameValid()) {
        alert(" % < \" are not allowed in Product Name");
        document.getElementById("TR_Product_Name").focus();
        return false;
    } else {    
        var formObject = document.productForm;  
        document.getElementById("actionType").value = formButton.name;
        if(ValidateForm(formObject)){
            //alert("The form is now validated................");
            document.getElementById("actionType").value = formButton.name;
            //alert("document.getElementById(\"actionType\").value is: " + document.getElementById("actionType").value); 
            var menuItemIDField = document.getElementById('TR_Menu_Item_ID');
            var photofile=document.getElementById('TR_Product_Photo').value;
            if(photofile!=null){
           // alert("in if");
                if( $.browser.msie){
                     //alert(photofile);
                       $('#myImage').attr('src',photofile);
                       var imgbytes = document.getElementById('myImage').fileSize;
                       var imgkbytes = Math.round(parseInt(imgbytes)/1024);
                       var imgmbytes= Math.round(parseInt(imgbytes)/1048576);
                       if(imgmbytes>=3){
                       alert('Please upload a photo less than 5MB');
                       return false;
                       } 
                }else{
                        var fileInput = $("#TR_Product_Photo")[0];
                         if(fileInput.files[0] != null){ 
                            var imgbytes = fileInput.files[0].fileSize; // Size returned in bytes.
                            var imgkbytes = Math.round(parseInt(imgbytes)/1024);
                            var imgmbytes= Math.round(parseInt(imgbytes)/1048576);
                               if(imgmbytes>=3){
                               alert('Please upload a photo less than 5MB');
                               return false;
                               } 
                         }
                }
            
            }    
            
            if( (menuItemIDField != null) && (menuItemIDField.value != '') && (menuItemIDField.value != 'NA') ){
                 menuItemIDVal = menuItemIDField.value;
                 //alert("Menu Item ID being supplied to merlinservicewar is: " + menuItemIDVal );
                 // invoke the Ajax call to the Web service
                 //alert("now insert the ajax call here....... ");
                 var ajaxObj = null;
                // for nutrition details
                //url = "http://66.111.151.46:4214/merlinservicewar/servlet/MerlinServiceServlet?requestType=getProductNutritionInfo&productID=" + menuItemIDVal + "&isApproved=false";
                //url = "http://66.111.151.46:4214/merlinservicewar/servlet/MerlinServiceServlet?requestType=getAllProductMerlinDetails&productID=" + menuItemIDVal + "&isApproved=false";
                // for all details 
               url = "/merlinservicewar/servlet/MerlinServiceServlet?requestType=getAllProductMerlinDetails&productID=" + menuItemIDVal + "&isApproved=false";
                //url = "https://author.dev.accessmcd.com/merlinservicewar/servlet/MerlinServiceServlet?requestType=getAllProductMerlinDetails&productID=" + menuItemIDVal + "&isApproved=false";
                //alert("url: \n" + url);
                $.ajax
                ({
                    url: url,
                    type: 'GET',
                    data: '',                                                                    
                    cache: false, 
                    timeout : '20000',
                    async: false,                                                                                                  
                    error: function()
                    { 
                        //alert("******************* Inside fetchMerlinInfo - There was an Error in the Ajax call to the Merlin WebService!!!");
                        document.getElementById('merlinErrorDiv').innerHTML = "******************* There was an Error in the Ajax call to the Merlin WebService!!!";
                        $('#merlinErrorDiv').css("display","block");
                    },
                    success: function(html)
                    {
                         //alert("suceessssssssssssssss");
                        var NUTRITION_INFO_NOT_FOUND = "NUTRITION_INFO_NOT_FOUND";
                        var BUILD_INFO_NOT_FOUND = "BUILD_INFO_NOT_FOUND";
                        
                        var NUTRITION_XML_START = "<!--NUTRITION_XMLSTART-->";
                        var NUTRITION_XML_END = "<!--NUTRITION_XMLEND-->";
                        var BUILD_XML_START = "<!--BUILD_XMLSTART-->";
                        var BUILD_XML_END = "<!--BUILD_XMLEND-->";
                        
                        var NUTRITION_HTML_START = "<!--NUTRITION_HTMLSTART-->";
                        var NUTRITION_HTML_END = "<!--NUTRITION_HTMLEND-->";
                        var BUILD_HTML_START = "<!--BUILD_HTMLSTART-->";
                        var BUILD_HTML_END = "<!--BUILD_HTMLEND-->";
                        var xmlstartTag = "<!--XMLSTART-->";
                        var xmlendTag = "<!--XMLEND-->";
                        var htmlstartTag = "<!--HTMLSTART-->";
                        var htmlendTag = "<!--HTMLEND-->";
                        
                        var nutritionXmlStartIndex =html.indexOf(NUTRITION_XML_START); 
                        var nutritionXmlEndIndex = html.indexOf(NUTRITION_XML_END);
                        var nutritionHTMLStartIndex =html.indexOf(NUTRITION_HTML_START); 
                        var nutritionHTMLEndIndex = html.indexOf(NUTRITION_HTML_END);
                        var buildXmlStartIndex =html.indexOf(BUILD_XML_START); 
                        var buildXmlEndIndex = html.indexOf(BUILD_XML_END);
                        var buildHTMLstartIndex = html.indexOf(BUILD_HTML_START); 
                        var buildHTMLEndIndex = html.indexOf(BUILD_HTML_END);
                        
                        if(html.indexOf("Please provide a valid Menu Item ID") == -1){
                            //alert('Merlin Data fetched: ' + html); 
                            
                            var nutritionXmldata = html.substring(nutritionXmlStartIndex + NUTRITION_XML_START.length, nutritionXmlEndIndex);
                            document.getElementById('MERLINNutritionInfoXML').value = nutritionXmldata;
                           //alert("NUTRITION XML DATA: " + nutritionXmldata);
                            
                            var nutritionHTMLdata = html.substring(nutritionHTMLStartIndex+ NUTRITION_HTML_START.length, nutritionHTMLEndIndex);
                            document.getElementById('MERLINNutritionInfoXSLT').value = nutritionHTMLdata;
                            //alert("NUTRITION HTML DATA: " + nutritionHTMLdata);
                            
                            var buildXmldata = html.substring(buildXmlStartIndex + BUILD_XML_START.length, buildXmlEndIndex);
                            document.getElementById('MERLINBuildXML').value = buildXmldata;
                            //alert("BUILD XML DATA: " + buildXmldata );
                            
                            var buildHTMLdata = html.substring(buildHTMLstartIndex + BUILD_HTML_START.length, buildHTMLEndIndex);
                            document.getElementById('MERLINBuildInfoXSLT').value = buildHTMLdata;
                            //alert("BUILD HTML DATA: " + buildHTMLdata);
                            //alert("SSSSSeeett ajaxSucess=true" );
                            formObject.submit();    
                            return true;
                        } else {
                            //alert("Please provide a valid Menu Item ID");
                            document.getElementById('merlinErrorDiv').innerHTML = "Please provide a valid Menu Item ID";
                            document.getElementById('merlinErrorDiv').style.display = "block";
                        }
                    } 
                });
            }
            else{
              formObject.submit(); 
              return true;   
            } 
            
  
        }
        else{
        //alert(":::::::::::::false::::::::::::::");
            return false;    
        }
    } 
} 

function saveAsDraftValidate(formButton)
{
    ///alert('inside save as draft validate()');
    //alert("The Button clicked was: " + formButton.value);
    //alert("Product element: "+document.getElementById("TR_Product_Name"));
    //alert("Product Name: "+document.getElementById("TR_Product_Name").value);
    var merlinInfoStatus;
    var formObject = document.productForm;
    var ajaxSuccess = false;
   // alert(formObject);
    if(document.getElementById("TR_Product_Name").value.length==0){
        alert("Please Enter Product Name");
        document.getElementById("TR_Product_Name").focus();
        return false;
    }
     
    if(!isProductNameValid()) {
        alert(" % < \" are not allowed in Product Name");
        document.getElementById("TR_Product_Name").focus();
        return false;
    } else {
 
        //alert('inside last else' + formButton);  
        if(formButton){
           // alert("insde formbutton");
          
           // alert('inside last if(formButton)'); 
            //alert("The Button clicked was: " + formButton.value);
            document.getElementById("actionType").value = formButton.name;
            //alert("document.getElementById(\"actionType\").value is: " + document.getElementById("actionType").value); 
            var menuItemIDField = document.getElementById('TR_Menu_Item_ID');
            var photofile=document.getElementById('TR_Product_Photo').value;
            //alert(photofile); 
            if( (menuItemIDField != null) && (menuItemIDField.value != '') && (menuItemIDField.value != 'NA') ){
            //alert("inside menu ItemId"); 
                
                 menuItemIDVal = menuItemIDField.value;
                 // invoke the Ajax call to the Web service
                 //alert("now insert the ajax call here....... ");
                 //alert('The Menu Item ID is : ' + menuItemIDVal);
                
                // for nutrition details
                //url = "http://66.111.151.46:4214/merlinservicewar/servlet/MerlinServiceServlet?requestType=getAllProductMerlinDetails&productID=" + menuItemIDVal + "&isApproved=false";
                // for all details
               url = "/merlinservicewar/servlet/MerlinServiceServlet?requestType=getAllProductMerlinDetails&productID=" + menuItemIDVal + "&isApproved=false";
                //url = "https://author.dev.accessmcd.com/merlinservicewar/servlet/MerlinServiceServlet?requestType=getAllProductMerlinDetails&productID=" + menuItemIDVal + "&isApproved=false";
                //alert("url: \n" + url);
                $.ajax({
                    url: url,
                    type: 'GET', 
                    data: '',                                                                     
                    cache: false,
                    timeout : '120000',
                    async: false,  
                    error: function() {
                        //alert("******************* Inside fetchMerlinInfo - There was an Error in the Ajax call to the Merlin WebService!!!");
                        document.getElementById('merlinErrorDiv').innerHTML = "Internal error occurred while fetching Product details. Please try again.";
                        //alert("asdsadsadasdsasad");
                        $('#merlinErrorDiv').css("display","block"); 
                        //alert("******************* Chekkkkkkkkkkkkkkkk!!!");
                        ajaxSuccess = false;
                        return false;
                    },
                    success: function(html) {
                        //alert("suceessssssssssssssss :::::: " + html);
                        var NUTRITION_INFO_NOT_FOUND = "NUTRITION_INFO_NOT_FOUND";
                        var BUILD_INFO_NOT_FOUND = "BUILD_INFO_NOT_FOUND";
                        
                        var NUTRITION_XML_START = "<!--NUTRITION_XMLSTART-->";
                        var NUTRITION_XML_END = "<!--NUTRITION_XMLEND-->";
                        var BUILD_XML_START = "<!--BUILD_XMLSTART-->";
                        var BUILD_XML_END = "<!--BUILD_XMLEND-->";
                        
                        var NUTRITION_HTML_START = "<!--NUTRITION_HTMLSTART-->";
                        var NUTRITION_HTML_END = "<!--NUTRITION_HTMLEND-->";
                        var BUILD_HTML_START = "<!--BUILD_HTMLSTART-->";
                        var BUILD_HTML_END = "<!--BUILD_HTMLEND-->";
                        var xmlstartTag = "<!--XMLSTART-->";
                        var xmlendTag = "<!--XMLEND-->";
                        var htmlstartTag = "<!--HTMLSTART-->";
                        var htmlendTag = "<!--HTMLEND-->";
                        
                        var nutritionXmlStartIndex =html.indexOf(NUTRITION_XML_START); 
                        var nutritionXmlEndIndex = html.indexOf(NUTRITION_XML_END);
                        var nutritionHTMLStartIndex =html.indexOf(NUTRITION_HTML_START); 
                        var nutritionHTMLEndIndex = html.indexOf(NUTRITION_HTML_END);
                        var buildXmlStartIndex =html.indexOf(BUILD_XML_START); 
                        var buildXmlEndIndex = html.indexOf(BUILD_XML_END);
                        var buildHTMLstartIndex = html.indexOf(BUILD_HTML_START); 
                        var buildHTMLEndIndex = html.indexOf(BUILD_HTML_END);
                        
                        if(html.indexOf("Please provide a valid Menu Item ID") == -1){
                        //alert("inside vvalida menu");
                            //alert('Merlin Data fetched: ' + html); 
                            
                            var nutritionXmldata = html.substring(nutritionXmlStartIndex + NUTRITION_XML_START.length, nutritionXmlEndIndex);
                            document.getElementById('MERLINNutritionInfoXML').value = nutritionXmldata;
                            //alert("NUTRITION XML DATA: " + nutritionXmldata);
                            
                            var nutritionHTMLdata = html.substring(nutritionHTMLStartIndex+ NUTRITION_HTML_START.length, nutritionHTMLEndIndex);
                            document.getElementById('MERLINNutritionInfoXSLT').value = nutritionHTMLdata;
                            //alert("NUTRITION HTML DATA: " + nutritionHTMLdata);
                            
                            var buildXmldata = html.substring(buildXmlStartIndex + BUILD_XML_START.length, buildXmlEndIndex);
                            document.getElementById('MERLINBuildXML').value = buildXmldata;
                            //alert("BUILD XML DATA: " + buildXmldata );
                            
                            var buildHTMLdata = html.substring(buildHTMLstartIndex + BUILD_HTML_START.length, buildHTMLEndIndex);
                            document.getElementById('MERLINBuildInfoXSLT').value = buildHTMLdata;
                            //alert("BUILD HTML DATA: " + buildHTMLdata);
                            //alert("SSSSSeeett ajaxSucess=true" );
                             ajaxSuccess = true;
                        } else {
                           // alert("Please provide a valid Menu Item ID");
                            document.getElementById('merlinErrorDiv').innerHTML = "Please provide a valid Menu Item ID";
                            document.getElementById('merlinErrorDiv').style.display = "block";
                            ajaxSuccess = false;
                            return false; 
                        }
                    }
                    
                     
                }); 
                if(!ajaxSuccess)
                    return false;
            }              
        if(photofile!=null){
          // alert("photofile is not null"); 
                if( $.browser.msie){
                    //alert('in ie');
                     //alert(photofile);
                       $('#myImage').attr('src',photofile);
                       //alert( $('#myImage').attr('src',photofile));
                       var imgbytes = document.getElementById('myImage').fileSize;
                       //alert(imgbytes );
                       var imgkbytes = Math.round(parseInt(imgbytes)/1024);
                       var imgmbytes= Math.round(parseInt(imgbytes)/1048576);
                       if(imgmbytes>=3){
                           alert('Please upload a photo less than 3MB');
                           return false;
                       } 
                }else{
                    var fileInput = $("#TR_Product_Photo")[0];
                     //alert("fileInput is: " + fileInput);
                     if(fileInput.files[0] != null){ 
                        var imgbytes = fileInput.files[0].fileSize;
                        //alert("imagebytes is: " + imgbytes );// Size returned in bytes.
                        var imgkbytes = Math.round(parseInt(imgbytes)/1024);
                        var imgmbytes= Math.round(parseInt(imgbytes)/1048576);
                        if(imgmbytes>=3){
                            alert('Please upload a photo less than 3MB');
                            return false;
                       }
                     } 
                } 
             
            }     

          formObject.submit();    
          return true;       

        }
        else{
            //alert ('no formbutton....');
            return false;
        }
    }   
}
