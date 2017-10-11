<%@include file="/libs/wcm/global.jsp" %>
<%@page session="false" import="java.util.*,java.text.*" %>
<?xml version="1.0" encoding="UTF-8" ?>
<cq:includeClientLib categories="granite.csrf.standalone" />    
<%
log("world clock POST");
//log("world clock POST - requestURL:"+slingRequest.getRequestURL());
final TreeMap locations=new TreeMap();
locations.put("Ababa","Africa/Addis_Ababa");
locations.put("Addis","Africa/Addis_Ababa");
locations.put("Adelaide","Australia/Adelaide");
locations.put("Aden","Asia/Aden");
locations.put("Almaty","Asia/Almaty");
locations.put("Anadyr","Asia/Anadyr");
locations.put("Anchorage","America/Anchorage");
locations.put("Ankara","Turkey");
locations.put("Antananarivo","Indian/Antananarivo");
locations.put("Auckland","Pacific/Auckland");
locations.put("Baghdad","Asia/Baghdad");
locations.put("Bangkok","Asia/Bangkok");
locations.put("Barcelona","Europe/Zurich");
locations.put("Beijing","Asia/Shanghai");
locations.put("Beirut","Asia/Beirut");
locations.put("Berlin","Australia/Brisbane");
locations.put("Brasil","America/Sao_Paulo");
locations.put("Brisbane","Australia/Brisbane");
locations.put("Cairo","Africa/Cairo");
locations.put("Canberra","Australia/Canberra");
locations.put("Cape Town","Africa/Johannesburg");
locations.put("Caracas","America/Caracas");
locations.put("Casablanca","Africa/Casablanca");
locations.put("Chatham Islands","Pacific/Chatham");
locations.put("Chicago","America/Chicago");
locations.put("Darwin","Australia/Darwin");
locations.put("Denver","America/Denver");
locations.put("Dhaka","Asia/Dhaka");
locations.put("Dubai","Asia/Dubai");
locations.put("Dublin","Europe/Dublin");
locations.put("Edmonton","America/Edmonton");
locations.put("Geneva","Europe/Zurich");
locations.put("Guatemala","America/Guatemala");
locations.put("Hanoi","Asia/Phnom_Penh");
locations.put("Havana","America/Havana");
locations.put("Helsinki","Europe/Helsinki");
locations.put("Hong Kong","Asia/Hong_Kong");
locations.put("Honolulu","Pacific/Honolulu");
locations.put("Islamabad","Asia/Karachi");
locations.put("Jakarta","Asia/Jakarta");
locations.put("Jerusalem","Asia/Jerusalem");
locations.put("Kabul","Asia/Kabul");
locations.put("Kamchatka","Asia/Kamchatka");
locations.put("Karachi","Asia/Karachi");
locations.put("Kathmandu","Asia/Kathmandu");
locations.put("Khartoum","Africa/Khartoum");
locations.put("Kingston","America/Jamaica");
locations.put("Kolkata","Asia/Kolkata");
locations.put("Kuala Lumpur","Asia/Kuala_Lumpur");
locations.put("Kuwait City","Asia/Kuwait");
locations.put("La Paz","America/La_Paz");
locations.put("Lagos","Africa/Lagos");
locations.put("Lahore","Asia/Karachi");
locations.put("Lima","America/Lima");
locations.put("Lisbon","Europe/Lisbon");
locations.put("London","Europe/London");
locations.put("Los Angeles","America/Los_Angeles");
locations.put("Manila","Asia/Manila");
locations.put("Melbourne ","Australia/Melbourne");
locations.put("Mexico City","America/Mexico_City");
locations.put("Minneapolis","America/Chicago");
locations.put("Montevideo","America/Montevideo");
locations.put("Montgomery","CST");
locations.put("Moscow","Europe/Moscow");
locations.put("Mumbai","IST");
locations.put("Nairobi","Africa/Nairobi");
locations.put("Nassau","America/Nassau");
locations.put("New Delhi","IST");
locations.put("New Orleans","CST");
locations.put("New York","America/New_York");
locations.put("Paris","Europe/Paris");
locations.put("Perth","Australia/Perth");
locations.put("Phoenix","America/Phoenix");
locations.put("Reykjavik","Atlantic/Reykjavik");
locations.put("Rio de Janeiro ","America/Sao_Paulo");
locations.put("Riyadh","Asia/Riyadh");
locations.put("Rome","Europe/Rome");
locations.put("San Francisco","America/Los_Angeles");
locations.put("San Juan","America/Argentina/San_Juan");
locations.put("San Salvador","America/El_Salvador");
locations.put("Santo Domingo","America/Santo_Domingo");
locations.put("Sao Paulo ","America/Sao_Paulo");
locations.put("Seattle","America/Los_Angeles");
locations.put("Shanghai","Asia/Shanghai");
locations.put("Singapore","Asia/Singapore");
locations.put("St. John\'s","America/St_Johns");
locations.put("St. Paul","America/Chicago");
locations.put("Stockholm","Europe/Stockholm");
locations.put("Suva","Pacific/Fiji");
locations.put("Sydney","Australia/Sydney");
locations.put("Taipei","Asia/Taipei");
locations.put("Tashkent","Asia/Tashkent");
locations.put("Tehran","Asia/Tehran");
locations.put("Tokyo","Asia/Tokyo");
locations.put("Toronto","America/Toronto");
locations.put("Vancouver","America/Vancouver");
locations.put("Vladivostok","Asia/Vladivostok");
locations.put("Washington DC","America/New_York");
locations.put("Yangon","Asia/Rangoon");

/*
Updated: 21-June-2011
Hemant Bellani
To include new locations: 
-  Papeete (Tahiti aka French Polynesia)
-  Noumea (New Caledonia)
*/
locations.put("Papeete","Pacific/Tahiti");
locations.put("Noumea","Pacific/Noumea");

String url=slingRequest.getRequestURL().toString();
String timeAdjustor="+00:00";//default
String location="";
SimpleDateFormat sdf=new SimpleDateFormat("MM-dd-yyyy hh:mm a");
long localtime=System.currentTimeMillis();
String strLocalTime="";
if(!url.endsWith(".html")){
    location=request.getParameter("location");
    String tzid=(String)locations.get(location);
    if(tzid!=null && !tzid.equals("")){
           NumberFormat hourformat = new DecimalFormat("+00;-00");
           NumberFormat minuteformat = new DecimalFormat(":00");
           //we need to get first offset to determine (roughly) local date, so that Daylight Savings Time
           //adjustments can be made using local date
           long localOffset=TimeZone.getTimeZone(tzid).getOffset(localtime);
           long serverOffset=TimeZone.getTimeZone("CST").getOffset(localtime);
           localtime+=(-1*serverOffset)+(localOffset);   
           strLocalTime=sdf.format(localtime);
           //now get offset based on local time
           double timeadj=TimeZone.getTimeZone(tzid).getOffset(localtime)/(1000d*60*60);
           double hours=Math.floor(timeadj);
           double minutes=(Math.abs(timeadj)*60)%60;
           timeAdjustor=hourformat.format(hours)+minuteformat.format(minutes);
    }
%>
<timezone xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://worldtimeengine.com/timezone.xsd">
    <version>1.1</version>
    <location>
        <region><%=location %></region>
        <latitude></latitude>
        <longitude></longitude>
    </location>
    <time>
        <utc></utc>
        <local><%=strLocalTime %></local>
        <zone>            
            <hasDST></hasDST>
            <current>
                <abbreviation></abbreviation>
                <description></description>
                <utcoffset><%=timeAdjustor%></utcoffset>
                <isdst></isdst>
                <effectiveUntil></effectiveUntil>
            </current>
        </zone>
    </time>
</timezone>
<%
}else{
    //return the location list
%>
<locations>
    <data>
    <%
    Iterator iterLocations=locations.keySet().iterator();
    while(iterLocations.hasNext()){
        String loc=(String)iterLocations.next();
    %>
<location><name><%=loc %></name><region/></location>
    <%
    }
    %>
     </data>
</locations>
<%
}
 String msg="";
 
 /*
 String[] tzids=TimeZone.getAvailableIDs();
 for(int i=0;i<tzids.length;i++){
     float offset=(float)TimeZone.getTimeZone(tzids[i]).getOffset(System.currentTimeMillis())/(1000*60*60);
    // msg+="<br>"+i+":"+tzids[i]+":"+offset;
     msg+="<br>"+tzids[i]+":"+offset;
      }   
*/
%>
<%=msg %>





