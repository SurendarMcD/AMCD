<%@ include file="/apps/mcd/global/global.jsp" %><%
%><%@ page import="java.util.*" %><%
%><%@ page import="com.mcd.gmt.product.constant.ProductConstant,com.mcd.gmt.product.manager.ProductManager,com.mcd.gmt.cq.*" %><%
%><%@ page import="com.mcd.gmt.product.bo.ProductDetail "%><%
%><%@ page import="org.slf4j.Logger, org.slf4j.LoggerFactory.*,com.day.cq.wcm.foundation.Image, com.day.cq.wcm.api.components.DropTarget" %><%
%><%@ page import="org.apache.sling.api.resource.ResourceResolver, com.day.cq.tagging.Tag, com.day.cq.tagging.TagManager, com.day.cq.tagging.InvalidTagFormatException" %><%
%>
<html> 
<head>
</head> 
<body>


<%
        String keyWordStr = "new york, Cheese, Frozen, Chili beans, mcflurry, Caramel Mocha Espresso, Gravy Sauce, Herb, Chicken, snacking, chicken & bacon melt, mixed vegetable, sweet chili wrap, grilled onions, Lettuce, garlic sauce, cheese., Smokehouse, Jalapeno Cheddar, summer, pesto, Deluxe, america, mushroom sauce, grilled onion sauce, whole grain, BBQ Sauce, ginger, Caramel Mocha Iced Espresso, bagel, red onions, Pie, rocket, Almonds, Mocha Frappe, Yanju, indulgence, mozzarella, onions, Oatmeal, Long Corn Meal, McCafe Beverages, mcwrap, mini, poultry, barbecue, 1955, spicy, Skewers, sour cream, rice bun, lettuce, festive, bone in chicken, wings, burger, Ciabatta, salsa, bold, Frappe, chicken wrap, Caramel Mocha, steamed, miami melt, McCafe Frappe, tomato chili, deli choices, Beef, tacos, McMini, fish, mushrooms, FSL, black pepper, festive deluxe, Char Grill, Tomato, bacon, tour around the world, 3:1 patty, cheddar, oven, US Oatmeal, 3 : 1, spicy vegetable, teriyaki, grated cheese top bun, great tastes of america, deli range, parmesan, premium beef burger, Quarter Bun, mustard, deli choice, bbq, add-on, new york classic, big classic beef, Mayonnaise, Lemonade, Breader, toffee crisp, grain bun, Pounder, premium burger, my flurry, Wheat Square Bun, tomato, egg, Quarter, grilled, unbreaded, Egg, 280, Smokey, pastrami, Real Fruit Smoothie, arugula, mashed potato, beef burger, france, Caramel Frappe, premium, McChicken, McChicken sauce, snack wrap, emmental, Premium, germany, Brown Roll, american bagel, Chicken Wing Stick, gta, tortilla, big bbq, Chocolate, McBites, deli, Fruit and Maple Oatmeal, Chicken Wings, chipolte, Strawberry Lemonade, Wildberry Smoothie, Marinader, bacon pepper, Snack, Herb bun, roasted, Chicken with bone, Smoothie, wraps, shrimp, Creme, crispy, Corn Meal, winter warmers, m burger, cadburry wispa, ketchup, lemon, onion, red wine sauce, Strawberry Banana Smoothie, McGrilled Chicken, sesame, Onion, Sourdough Bun Toasted, Spicy McWings, herb, Unilever, Barbeque, salt, 4 : 1, chorizo, Keywords, Bone, chicken & bacon wrap, small, ciabatta, oreo, big beef burger, Crunch, monterey jack cheese, Bacon, Quarter bun, veggieburger, chips, Cheese sauce, Brulee, McFlurry, potato patty, Magnum, Legend, wing, Chicken Middle Wing, sesame bun heel, vegetarian, baguette, pork, cheese, big beef parmesano, sandwich, Angus, chicken, beef, cbo, Sweet & Tangy, wrap, 4:1, veggie, sausage, Crisp, Grated Cheese Topped Bun, Frappes, BBQ, Fruit and Maple, Frozen Strawberry Lemonade, grilled chicken salad, Brownies, m, mustard relish, Ketchup, german, Banana, Sweet Lemon Sauce, Mixed Salad, side";
        //out.println("******************************************************KeyWords are: : " + keyWordStr );
        String [] keyWordsArray = keyWordStr.split(",");
        String currentKeyWord = "";
        Tag currentTag = null;
        TagManager tagManager = null;

        int countOfTagsAdded = 0;
        if((null != keyWordsArray) && (keyWordsArray.length>0)){
            
            for(int count=0; count < keyWordsArray.length; count++){
                currentKeyWord = ProductConstant.GMS_TAGGING_PATH.concat((keyWordsArray[count].trim()).toLowerCase());
                log.error("******************************************************Current KeyWord is: " + currentKeyWord);
                out.println("******************************************************Current KeyWord is: " + currentKeyWord);
                tagManager = resourceResolver.adaptTo(TagManager.class);
                currentTag = tagManager.resolve(currentKeyWord);
                out.println("******************************************************Current Tag is: " + currentTag );
                log.error("************************************************ right after tagManager.resolve() call ***********");
                if(! (null == currentTag) ){ // if a tag corresponding to the keyword exists in Tagging section
                    log.error("******************************************************** currentTag is not null **********");
                }else{
                    countOfTagsAdded++;
                    log.error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! currentTag not resolved !!!!!!!!!!!!!!!!");
                    try{
                        currentTag = tagManager.createTag(currentKeyWord, keyWordsArray[count], "Description for ".concat(keyWordsArray[count]));
                    } catch(InvalidTagFormatException invalidTagFormatException){
                        log.error("The Tag was not created properly " + invalidTagFormatException.getMessage());
                    }
                    //pageTagsList.add(currentTag); 
                }
                
            }
            
        } 
        
%>
</body> 
