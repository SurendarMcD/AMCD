function showLogoutScreen(){
    window.location.href="https://www.accessmcd.com/InternalSite/LogoffMsg.asp?site_name=noauthaccessmcd&secure=1";
}
function showList(){
    window.location.href="/content/training/style_book_test.styleBookMobileAdmin.html";
}
//Function to validate the related keys
    function checkRelatedKey(availableTags){
        var returnFlag=true;
        for(var i=1;i<=count;i++){
            if(document.getElementById("tags"+i)&&(document.getElementById("tags"+i).value!=null)){
                for(var j=0;j<availableTags.length;j++){
                    if((availableTags[j]).toString()==(document.getElementById("tags"+i).value).toString()){
                        returnFlag=true;
                        break;
                    }
                    else{
                        returnFlag=false;                        
                        continue;
                    }
                }
                //if only first related key exists then empty value is not invalid.
                if(!document.getElementById("tags2")&&((document.getElementById("tags1").value==null)||document.getElementById("tags1").value=="")){
                    returnFlag=true;
                }
                if(!returnFlag){
                    alert("The related key at textbox "+i+" is either invalid or deleted");
                    break;
                }
            }
            else{
                continue;
            }
        }
        return returnFlag;
}

function checkDescription() {
    
    var enteredDescription=$.trim(document.getElementById("descValue").value);    
    var descLength=enteredDescription.length;
    var returnFlag=false;
        if (descLength > 1500) {         
            returnFlag=false;
            alert("The length of decsription field content exceeds the defined limit.");         
        } 
        else {        
                returnFlag=true;
        }
        
       return returnFlag;
}

/********************Javascript functions before form submit START*************/
function addValue(availableTags){
    document.getElementById("operationValue").value="add";        
    document.getElementById("descValue").value=$(".nicEdit-main").html();
    
    if(checkRelatedKey(availableTags)&&(!checkEnteredKey())&&checkDescription()){
        document.submitForm.submit();
    }
}

function updateValue(id,availableTags){
    var checkValueForUpdate=document.getElementById("keyValueForUpdate").value;
    var enteredKey=document.getElementById("key").value;
    document.getElementById("operationValue").value="update";
    document.getElementById("descValue").value=$(".nicEdit-main").html();                   
    document.getElementById("idValue").value=id;
    if(enteredKey!=checkValueForUpdate){
        if(checkRelatedKey(availableTags)&&(!checkEnteredKey(availableTags))&&checkDescription()){
            document.submitForm.submit();
        }
    }else{
        if(checkRelatedKey(availableTags)&&checkDescription()){
            document.submitForm.submit();
        }
    }
}
function deleteValue(id){
    document.getElementById("operationValue").value="delete";
    document.getElementById("idValue").value=id;
    if(confirm("Are you sure you want to delete this record?")){
        document.submitForm.submit();        
    }
}
/********************Javascript functions before form submit END*************/