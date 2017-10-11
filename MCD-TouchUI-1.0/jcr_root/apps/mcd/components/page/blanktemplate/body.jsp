<%@include file="/apps/mcd/global/global.jsp"%>
  
<body>

<!-- Google Tag Manager -->
<noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-PG56BV"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-PG56BV');</script>
<!-- End Google Tag Manager -->

    
<cq:include path="sitelevelproperties" resourceType="/apps/mcd/components/content/sitelevelproperties" />     
<cq:include path="blankpagecontent" resourceType="foundation/components/parsys" />



<script>
    function getUserInfo()
    {    
        var aID ="UNKNOWN";
        var aRole ="UNKNOWN";
        var aCombo ="UNKNOWN_UNKNOWN";
        var UserInfoObject = null;
 
        if(UserInfoObject == null){
                        var url = '<%=currentPage.getPath().replaceAll("/content/","/")%>.moreinfo.html?getdata=1';
                        $.ajax({
                            url: url,
                            type: 'GET',    
                            timeout: 6000, 
                            data: '', 
                            cache: true,   
                            error: function(){
                             //      _tag.DCSext.EID=aID;
                             //      _tag.DCSext.ROLE=aRole;
                             //      _tag.DCSext.COMBO=aCombo;
                             //      _tag.dcsCollect(); 
                            },    
                            success: function(xml){                                   
                                    UserInfoObject = eval('(' + xml + ')'); 
                                    if(UserInfoObject!=null){
                                        aID=UserInfoObject.uid;
                                        aRole=UserInfoObject.mcdAudience;
                                        aCombo= aID+"_"+aRole;
                                    }
                                   _tag.DCSext.EID=aID;
                                   _tag.DCSext.ROLE=aRole;
                                   _tag.DCSext.COMBO=aCombo;
                                   _tag.dcsCollect(); 
                            }
                        });                        
        
        }else{
             aID=UserInfoObject.uid;
             aRole=UserInfoObject.mcdAudience;
             aCombo= aID+"_"+aRole;
             _tag.DCSext.EID=aID;
             _tag.DCSext.ROLE=aRole;
             _tag.DCSext.COMBO=aCombo;
             _tag.dcsCollect(); 
        }
    }
    

</script>     

</body>
  

  