
function togglePage(URL,view){
        switchview(URL);
        setCookie('userview',view,0);  
      //  window.open(URL,"_self");
} 

function checkToggleURL(userAlert,URL,message){ 
        alert(userAlert+" "+URL+" "+message);   
}

