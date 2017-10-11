function showGroupURL()
{
    var selIndex = document.maintform.GROUP.selectedIndex;
    var aceGroupValue = document.maintform.GROUP.options[selIndex].value
    document.maintform.siteurl.value = '';
    for(var j = 0 ; j < disNameArr.length ; j++)
    {
        if(disNameArr[j].split('#')[0] == aceGroupValue)
        {
            document.maintform.siteurl.value = disNameArr[j].split('#')[1];
        }
    }
}

function SelectSubCat()
{ 
    removeAllOptions(document.maintform.DISPLAYNUM);
    
    if(document.maintform.pmACTION.value == 'viewgroup')
    {
        addOption(document.maintform.DISPLAYNUM, "", "no limit");
        for(var k = 0 ; k < maxLimitArr.length ; k++)
        {
            addOption(document.maintform.DISPLAYNUM,maxLimitArr[k], maxLimitArr[k]);
        }
    }
    if(document.maintform.pmACTION.value == 'view' || document.maintform.pmACTION.value == 'addM' || document.maintform.pmACTION.value == 'addA' || document.maintform.pmACTION.value == 'delete')
    {
        addOption(document.maintform.DISPLAYNUM, "", "no limit");
    }    
}

function removeAllOptions(selectbox)
{
    var i;
    for(i=selectbox.options.length-1;i>=0;i--)
    {
        selectbox.remove(i);
    }
}


function addOption(selectbox, value, text )
{
    var optn = document.createElement("OPTION");
    optn.text = text;
    optn.value = value;
    selectbox.options.add(optn);
}

function deleteUserFromGroup(user,group,bAdd)
{
    var msg="Add "+user+" to group "+group;
    if(!bAdd)msg="Remove "+user+" from group "+group;
    if(confirm(msg + "?"))
    {
         $("[name=EID]").val(user);
         $("[name=EIDLIST]").val("");
         $("[name=GROUP]").val(group);
         if(bAdd)
         {
             $("[name=pmACTION]").val("add");
         }
         else
         {
             $("[name=pmACTION]").val("delete");
         }
         $("#maintform").submit();
    }
}

function viewUser(user)
{
    $("[name=EID]").val(user);
    $("[name=pmACTION]").val("view");
    $("#maintform").submit();
}

function viewGroup(group)
{
    $("[name=GROUP]").val(group);
    $("[name=pmACTION]").val("viewgroup");
    $("#maintform").submit();
}