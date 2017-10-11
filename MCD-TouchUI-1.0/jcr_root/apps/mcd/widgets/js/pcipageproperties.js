/* 
 * Widget for PCI Page Properties dialog 
 * Erik Wannebo 11/9/2009  
 * Wei 09/23/2010   
 */ 

CQ.form.pcipageproperties = CQ.Ext.extend(CQ.form.CompositeField, {
        
    constructor : function(config){
        CQ.form.pcipageproperties.superclass.constructor.call(this, config);
    }
}
);
CQ.Ext.reg("pcipageproperties", CQ.form.pcipageproperties);

/*
 * Widget for PCI Categories (to fix some costmetic issues
 * Erik Wannebo 11/12/09
 */

CQ.form.PCICategories = CQ.Ext.extend(CQ.form.Selection, {
       
    /** 
     * Renders the component.
     * @param {CQ.Ext.Element} ct container element
     * @param {Object} pos
     */
    onRender: function(ct, pos) {
        this.comboBox.width=300;
        this.comboBox.minListWidth=400;
        /*
        //testing
         var reader = new CQ.Ext.data.ArrayReader({}, [
           {name: 'categoryid'},
           {name: 'category'},
           {name: 'view'}
       
        ]);
      
         // get the data
        var proxy = new CQ.Ext.data.HttpProxy({
                //where to retrieve data
                url: '/apps/mcd/classes/pcicategories.html', //url to data object (server side script)
                method: 'GET'
            });
       
        // create the data store.
        var store;
        
        store = new CQ.Ext.data.Store({
            reader: reader,
            proxy: proxy
        });
        
        store.load();
        this.comboBox.bindStore(store);
      
        //this.comboBox.store = store;
       // store.load();
        //this.comboxBox.setVisible(true);
        
        //end testing 
        */
        CQ.form.PCICategories.superclass.onRender.call(this, ct, pos);
        // propagate value to view - mimics the initValue()-mechanism of CQ.Ext.form.Field
        //alert(this.comboBox.minListWidth);
    
    },
    
    //wei - when category selection changed...
    categorySelectionChanged: function() {
        var parentPanel=this.findParentByType('panel');
        var pciViews = null;
        
        if(parentPanel){      
            pciViews=parentPanel.findByType('pciviews');
        }
        var selectedCategory = this.comboBox.getValue();
        //alert("Selected Category = " + selectedCategory);
        this.doAjax(selectedCategory, pciViews);
    },
    
    //wei - not using this function now
    selectionChanged: function(){
        //get sibling PCIViews (custom xtype for parent, to store Categories?)
        alert('changed');   
        var parentPanel=this.findParentByType('panel');
        if(parentPanel){      
            var pciViews=parentPanel.findByType('pciviews');
            if(pciViews.length==1){
                //This list should perhaps be dynamically loaded?
                var allViews=[
                    {text:"Australia",value:"AU"},
                    {text:"Global",value:"ENT"},
                    {text:"United States",value:"US"}
                    ];
                //TODO: get allowed view(s) for category
                // either ALL or a single view
                                        
               //wei - for testing...will get the category list dynamically from the txt file
                var allCategories =[
                    {id:"32050",category:"Action Required (O/O Pilot)",view:"US"},
                    {id:"30001",category:"Atlanta Region Headlines",view:"US"},
                    {id:"31001*",category:"Atlanta Region Top Story",view:"US"}
                    ]; 
                            
                var selectedCategory = this.comboBox.getValue();
                //alert("selectedCategory=" + selectedCategory);
                
                var allowedView = "ALL";    
               
               for(var j=0; j<allCategories.length; j++) {
                   //alert(allCategories[j].category);
                   if (allCategories[j].category == selectedCategory) 
                       allowedView = allCategories[j].view;
               }
                
                //alert("allowedView=" + allowedView);
                
                //var allowedView="ALL";
                //if(Math.random()>.5)allowedView="AU"; //for testing
                
                if(allowedView=="ALL"){
                    pciViews[0].setOptions(allViews);
                }else{
                    var allowedViews=[];
                    for(var i=0;i<allViews.length;i++){
                        if(allViews[i].value==allowedView){
                             allowedViews[allowedViews.length]=allViews[i];
                        }
                    }
                    pciViews[0].setOptions(allowedViews);
                    pciViews[0].setValue(allowedView);
                }
               
            }
        }
    },
    
    //wei - added ajax call
    doAjax: function(selectedCategory, pciViews) {
         //alert("doing ajax calling...");         
         CQ.Ext.Ajax.request({
            url : '/apps/mcd/classes/pcicategories.html',
            method: 'GET',
            async: 'false',
            success: function ( result, request ) {
                 var allowedView = "All";
                 var categoryList = result.responseText;
                         
                 var categoryEntries = categoryList.split("\,");
                 for (var i=0; i<categoryEntries.length; i++) {
                       //alert("categoryEntry=" + categoryEntries[i] + "...");
                       var categoryEntry = categoryEntries[i].split("\|");
                       var category = categoryEntry[1];
                       
                       if (category == selectedCategory) {
                           var allowedView = categoryEntry[2];
                           break;
                       }
                  } 
                  //alert("allowedView = " + allowedView);  
                                
                  if(pciViews.length==1){ 
                                  
                       var allViews=[
                        {text:"Australia",value:"AU"},
                        {text:"Global",value:"ENT"},
                        {text:"United States",value:"US"},
                        {text:"New Zealand",value:"NZ"}
                        ];
                        
                       var allowedViews=[];
                       if(allowedView=="ALL"){
                            pciViews[0].setOptions(allViews);
                            
                       }else{
                            //var allowedViews=[];
                            for(var i=0;i<allViews.length;i++){
                            
                                if(allowedView.indexOf(allViews[i].value)!=-1){
                                   
                                //if(allViews[i].value==allowedView){
                                     allowedViews[allowedViews.length]=allViews[i];
                                }    
                            }
                            pciViews[0].setOptions(allowedViews);
                            pciViews[0].setValue(allowedView);
                       }
                  }
                 
               //return CQ.Ext.encode(categoryList);
                                                
              },
              failure: function ( result, request ) {
                  var categoryList = result.responseText;
                  alert("Not getting category list:" + categoryList);
                  // return categoryList;
              }
         });
    },
    
    testcall: function() {
    
        this.comboBox.displayField="category";
        this.comboBox.valueField="categoryid";
            //testing
         var reader = new CQ.Ext.data.ArrayReader({}, [
           {name: 'categoryid'},
           {name: 'category'},
           {name: 'view'}
       
        ]);
      
         // get the data
        var proxy = new CQ.Ext.data.HttpProxy({
                //where to retrieve data
                url: '/apps/mcd/classes/pcicategories1.html', //url to data object (server side script)
                method: 'GET'
            });
       
        // create the data store.
        var store;
        
        store = new CQ.Ext.data.Store({
            reader: reader,
            proxy: proxy
        });
        
        store.load();
       // this.comboBox.setStore(store);
        this.comboBox.bindStore(store, true);
       // this.doLayout();
      
        //this.comboBox.store = store;
             
        //end testing    
    },
    
    test: function() {
        var parentPanel=this.findParentByType('panel');
        var pciCatetories = null;
        
        if(parentPanel){      
            pciCategories=parentPanel.findByType('pcicategories');
        }
       
        this.getCategories(pciCategories);
    },
    
    getCategories: function(pciCategories) {
            CQ.Ext.Ajax.request({
            url : '/apps/mcd/classes/pcicategories.jsp',
            method: 'GET',
            async: 'false',
            success: function ( result, request ) {
                 var categoryList = result.responseText;
                 var dataArr = [];
                                
                 var categoryEntries = categoryList.split("\,");
                 for (var i=0; i<categoryEntries.length; i++) {
                       //alert("categoryEntry=" + categoryEntries[i] + "...");
                       var categoryEntry = categoryEntries[i].split("\|");
                       var category = categoryEntry[1];
                                        
                       dataArr.push({text: categoryEntry[1], value: categoryEntry[0]});    
                       // dataArr.push([categoryEntry[0], categoryEntry[1]]);    
                  } 
               /*  
                  for (var j=0; j<dataArr.length; j++) {
                      alert(dataArr[j].text + " - " + dataArr[j].value);
                      //break;
                  }*/
                 
                  //this.comboBox.setOptions(dataArr); 
                  //var categoryCmp = CQ.Ext.getCmp("category");
                  //categoryCmp.items.setOptions(dataArr);
                  pciCategories[0].setOptions(CQ.Util.formatData(dataArr));
                     
             }, 
             failure: function ( result, request ) {
                  var categoryList = result.responseText;
                  alert("Not getting category list:" + categoryList);
                  // return categoryList;
              }
         });
    },
            
    constructor: function(config){
       
        config = config || {};
        CQ.form.PCICategories.superclass.constructor.call(this, config);
     
        this.comboBox.on("select",this.categorySelectionChanged, this);
        //this.comboBox.on("render",this.testcall, this);
         //this.comboBox.on("render",this.test, this);
    } 
}
);
CQ.Ext.reg("pcicategories", CQ.form.PCICategories);

/*
 * Widget for PCI Views (for dynamically displaying based on selected Category)
 * Erik Wannebo 9/13/10
 */

CQ.form.PCIViews = CQ.Ext.extend(CQ.form.Selection, {
        
    constructor : function(config){
        CQ.form.PCICategories.superclass.constructor.call(this, config);
    }
}
);
CQ.Ext.reg("pciviews", CQ.form.PCIViews);