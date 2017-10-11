 //--------------------------------
 // Central function to manage loading of UserInfoObject
 // Erik Wannebo 11/7/2012
 //--------------------------------
 var loadingUserInfo=false;
 var moreinfocount=0;

 function getUserInfoObject(currentPagePath){

     if(UserInfoObject==null){
         //load via Ajax
         if(!loadingUserInfo){
             loadingUserInfo=true;
              if(moreinfocount<=10){
                   var url = currentPagePath.replace("/content/", "/") + '.moreinfo.html?getdata=1';
                    $.ajax({
                        url: url,
                        type: 'GET',    
                        timeout: 10000, 
                        data: '', 
                        cache: true,   
                        error: function(){
                         moreinfocount++;
                         loadingUserInfo=false;
                        },    
                        success: function(xml){                                   
                                UserInfoObject = eval('(' + xml + ')');
                                loadingUserInfo=false;
                        }
                    });                       
                }
          }  
          return false;
     }else{
         return true;
     }
 }
 
 function redirectURL(currentPagePath,excludepatterns){
   
    var currentURL =  window.location.href;
    if(currentURL.charAt(currentURL.length - 1 ) == "/")
     {
         currentURL= currentURL.substring(0, currentURL.length - 1);
     } 
     var page = currentURL.substring(currentURL .lastIndexOf('/') + 1);
     if(page==null)return;
     
     var sel = page.split('.');
     var containsAlias= false; 
     if(sel[1] == UserInfoObject.alias)containsAlias=true;    

    var homepage =  UserInfoObject.viewPath.toLowerCase() + ".html";  
    var currentPage = window.location.pathname; 
    currentPage = currentPage.replace("/content/", "/");
    
    if((TrimString(page)==sel[0]+".html") ||
       (currentURL.indexOf(homepage) > 0) ||
       (!containsAlias)
       )
    {
       var checklink= new Array();
       checklink=excludepatterns.split(",")
       for(var i=0;i<checklink.length;i++)
       { 
            if(TrimString(checklink[i]).toLowerCase() == TrimString(sel[1]).toLowerCase()){
                   return;
            }
      }
           var redurl = currentURL.substring(0,currentURL .lastIndexOf('/') + 1) + sel[0] + '.' + UserInfoObject.alias + '.' + sel[sel.length-1]; 
           window.location = redurl;
    }
}     
 
 
 /* To initialize the userinfo object anf for the frame target logic. */   
 var globalAwesomeBarInitCount=0;
 
 function initialize(currentPagePath,excludepatterns,viewPaths,tempPage) 
    { 
         //console.log('initialize');
         //wait for UserInfoObject to initialize;
         if(!getUserInfoObject(currentPagePath)){
             setTimeout(function(){initialize(currentPagePath,excludepatterns,viewPaths,tempPage)},25);
             return;
         }
         
         /* to check the frame target */      
         var target = getQuerystring('frameTarget' ,'');
         var redirect = getQuerystring('redirect' ,'true');

        
        if(target !='')
        {
            var part = new Array();
            part = target.toLowerCase().split(".");   
            var amcdTarget =  part[0] + part[1];
            if(part[0].indexOf('www1') >= 0 || amcdTarget.indexOf('wwwaccessmcd') >= 0 )    
            { 
                if(redirect=='true') 
                {
                    target = target.replace("www1", "www"); // Uncomment after CutOver 
                    window.location = target + '?redirect=false&view=' + UserInfoObject.view; ;
                 }   
            }   
            else 
            { 
                if(redirect=='true') 
                {
                    window.location = 'http://' + window.location.host  +  "/" + tempPage + '.html?frameTarget='+target + '&redirect=false&view=' + UserInfoObject.view; 
                }
            
            }
        }else{
          var viewPage = false;
          var views = viewPaths.split(',');
          for(var i = 0 ; i < views.length ; i++)
          {
              if(currentPagePath == views[i])
              {
                viewPage = true; break;
              }
          }
          if(viewPage)redirectURL(currentPagePath,excludepatterns);
        }    

       

    }
    

    function getAwesomeHeader(currentPagePath,currentDesignPath)
    {    
    
         //wait for UserInfoObject to initialize;
         if(!getUserInfoObject(currentPagePath)){
             setTimeout(function(){getAwesomeHeader(currentPagePath,currentDesignPath)},25);
             return;
         }
        getAwesomeBarData(UserInfoObject.alias, UserInfoObject.view, UserInfoObject.uname, UserInfoObject.uid, UserInfoObject.userEmail, currentDesignPath, UserInfoObject.mcdAudience,currentPagePath);
         
    }
    function getResponsiveAwesomeHeader(currentPagePath,currentDesignPath){    
        //wait for UserInfoObject to initialize;
        if(!getUserInfoObject(currentPagePath)){
            setTimeout(function(){getResponsiveAwesomeHeader(currentPagePath,currentDesignPath)},25);
            return;
        }
        getResponsiveAwesomeBarData(UserInfoObject.alias, UserInfoObject.view, UserInfoObject.uname, UserInfoObject.uid, UserInfoObject.userEmail, currentDesignPath, UserInfoObject.mcdAudience,currentPagePath);
    }
    
    function redirect_Japan(currentPagePath,jppath)
    {     
     if(jppath.indexOf('/content') >= 0)
     {
      jppath = jppath.replace('/content','');
     }
          
     var addr = document.URL;
     if(addr.indexOf(jppath) > -1)
      {
       var page = addr.substring(addr.lastIndexOf('/') + 1);  
       var sel = new Array();
       sel = page.split('.');
       if(sel.length == 2)
       {
       if(page.indexOf('.home') < 0)
       {            
        var redirectPath = currentPagePath+ ".home.html";
       window.open(redirectPath,"_self");
       }
    
        
     } 
    }  
    } 
    
    //these are all global vars from head.jsp
    redirect_Japan(thisPage,jpPath);    
    if(!isAuthor && !ignoreJapanPage){
       initialize(thisPage,excludepatterns,viewPaths,frameTargetPage);
    }    