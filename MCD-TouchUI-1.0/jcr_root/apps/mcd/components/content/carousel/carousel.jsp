<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="javax.jcr.Node,javax.jcr.NodeIterator,javax.jcr.Value,javax.jcr.Property"%>
<!--================= Carousel Start=============== -->
    <div id="myCarousel" class="carousel slide" data-ride="carousel">
      <!-- Indicators -->
      <ol class="carousel-indicators">
        <%
            if (currentNode.hasProperty("images")) {
                Property p = currentNode.getProperty("images");
                Value[] values = p.getValues();
                for (int i = 0; i < values.length; i++) {
                    if(i == 0){
                        %><li data-target="#myCarousel" data-slide-to="<%=i %>" class="active"></li><%
                    }else{
                        %><li data-target="#myCarousel" data-slide-to="<%=i %>"</li><%
                    }
                }
            }   
        %>
      </ol>
      <div class="carousel-inner" role="listbox">
        <%
            if (currentNode.hasProperty("images")) {
                Property p = currentNode.getProperty("images");
                Value[] values = p.getValues();
                for (int i = 0; i < values.length; i++) {
                    if(i == 0){
                        %><div class="item active"><%
                    }else{
                        %><div class="item"><%
                    }
                    String[] prop = values[i].getString().split("\\|",-1);
                    String imagePath = prop[0];
                    String showWidget = prop[1];
                    String widgetAlignment = prop[2].trim();
                    String widgetClass = "ltr";
                    if(widgetAlignment.equals("left")){widgetClass="ltr";}else{widgetClass="rtl";}
                    String widgetTitle = prop[3];
                    String widgetHeading = prop[4];
                    String widgetSubheading = prop[5];
                    String buttonText = prop[6];
                    String buttonUrl = prop[7];
                    if(buttonUrl.startsWith("/content")){
                        buttonUrl = buttonUrl + ".html";
                    }
                    %><a href="<%=buttonUrl%>"><img class="first-slide" src="<%=imagePath%>" alt="First slide"></a><%
                        if(showWidget.equals("y")){%>
                            <div class="slider-text-box <%=widgetClass%>">
                                <h2><%=widgetTitle%></h2>
                                <h3><%=widgetHeading%></h3>
                                <h4><%=widgetSubheading%></h4>
                                <a href="<%=buttonUrl%>"><%=buttonText%></a>
                            </div>
                        <%}
                        %>
                    </div>
                    <%
                }
            }
        %>
      </div>
      <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
        <span class="cbleft" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
        <span class="cbright" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
      </a>
    </div>
<!--===============Carousel End =========== -->

<script>
$(document).ready(function() {
    var myCarousel = $('#myCarousel');
    myCarousel.swipeleft(function() {
        myCarousel.carousel('next');
    });
    myCarousel.swiperight(function() {
        myCarousel.carousel('prev');
    });
   /*$("#myCarousel").swiperight(function() {
      $(this).carousel('prev');
    });
   $("#myCarousel").swipeleft(function() {
      $(this).carousel('next');
   });*/
});
</script>