/*
 * Copyright 1997-2009 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */

/**
 * @class CQ.form.ImageMap
 * @extends CQ.form.SmartImage.Tool
 * @private
 * The ImageMap provides the image map tool for {@link CQ.form.SmartImage}.
 * @constructor
 * Creates a new ImageMap.
 * @param {String} transferFieldName Name of the form field that is used for transferring
 * the image crop information
 */
CQ.form.ImageMap = CQ.Ext.extend(CQ.form.SmartImage.Tool, {

    /**
     * Flag if the tool has already been initialized
     * @private
     * @type Boolean
     */
    isInitialized: false,

    constructor: function(transferFieldName) {
        CQ.form.ImageMap.superclass.constructor.call(this, {
            "toolId": "smartimageMap",
            "toolName": CQ.I18n.getMessage("Map"),
            "iconCls": "cq-image-icon-map",
            "isCommandTool": false,
            "userInterface": new CQ.form.ImageMap.UI( {
                "title": CQ.I18n.getMessage("Image map tools")
            }),
            "transferFieldName": transferFieldName
        });
    },

    /**
     * Initializes the tool's components by registering the underlying
     * {@link CQ.form.SmartImage.ImagePanel} and all necessary event handlers.
     * @param {CQ.form.SmartImage} imageComponent The underlying image panel
     */
    initComponent: function(imageComponent) {
        CQ.form.ImageMap.superclass.initComponent.call(this, imageComponent);
        this.workingArea = this.imageComponent.getImagePanel();
        this.workingArea.on("contentchange", this.onContentChange, this);
    },

    /**
     * Handler that is called when the image map tool is activated.
     */
    onActivation: function() {
        CQ.form.ImageMap.superclass.onActivation.call(this);
        if (!this.isInitialized) {
            if (this.mapShapeSet == null) {
                this.mapShapeSet =
                        new CQ.form.SmartImage.ShapeSet(CQ.form.ImageMap.SHAPESET_ID);
                this.workingArea.addShapeSet(this.mapShapeSet);
            }
            this.userInterface.notifyWorkingArea(this.workingArea, this.mapShapeSet);
            this.isInitialized = true;
        }
        this.workingArea.hideAllShapeSets(false);
        if (this.initialValue != null) {
            this.deserialize(this.initialValue);
            this.initialValue = null;
        }
        this.userInterface.isActive = true;
        this.workingArea.setShapeSetVisible(CQ.form.ImageMap.SHAPESET_ID, true, true);
    },

    /**
     * Handler that is called when the image map tool is deactivated.
     */
    onDeactivation: function() {
        this.workingArea.clearSelection();
        this.userInterface.isActive = false;
        this.workingArea.setShapeSetVisible(CQ.form.ImageMap.SHAPESET_ID, false, false);
        CQ.form.ImageMap.superclass.onDeactivation.call(this);
    },

    /**
     * <p>Clears the current image map.</p>
     * <p>Note that the view is not updated.</p>
     * @private
     */
    clearMappingInformation: function() {
        if (this.mapShapeSet) {
            try {
                this.workingArea.clearSelection();
                this.mapShapeSet.removeAllShapes();
            } catch (e) {
                // ignored intentionally
            }
        }
        this.initialValue = null;
    },

    /**
     * Handler that removes mapping information when a new image gets uploaded/referenced.
     */
    onImageUploaded: function() {
        this.clearMappingInformation();
        CQ.form.ImageMap.superclass.onImageUploaded.call(this);
    },

    /**
     * Handler that removes mapping information when the image gets flushed.
     */
    onImageFlushed: function() {
        this.clearMappingInformation();
        CQ.form.ImageMap.superclass.onImageFlushed.call(this);
    },

    /**
     * <p>Handler that reacts on "smartimage.contentchange" events.</p>
     * <p>Note that currently only rotation is supported.</p>
     * @param {Object} contentChangeDef Definition of content change to handle
     */
    onContentChange: function(contentChangeDef) {
        if (contentChangeDef.changeType == "rotate") {
            var imageSize = this.workingArea.originalImageSize;
            if (this.mapShapeSet == null) {
                this.mapShapeSet =
                        new CQ.form.SmartImage.ShapeSet(CQ.form.ImageMap.SHAPESET_ID);
                this.mapShapeSet.isVisible = false;
                this.workingArea.addShapeSet(this.mapShapeSet);
                if (this.initialValue) {
                    this.deserialize(this.initialValue);
                    this.initialValue = null;
                }
            }
            var rotation = parseInt(contentChangeDef.valueDelta);
            var absRotation = parseInt(contentChangeDef.newValue);
            if (rotation != 0) {
                var shapeCnt = this.mapShapeSet.getShapeCount();
                for (var shapeIndex = 0; shapeIndex < shapeCnt; shapeIndex++) {
                    var shapeToAdapt = this.mapShapeSet.getShapeAt(shapeIndex);
                    shapeToAdapt.rotateBy(rotation, absRotation, imageSize);
                }
                this.workingArea.drawImage();
            }
        }
    },

    /**
     * Transfers the mapping data from the user interface to the form field that is used
     * for submitting the data to the server.
     */
    transferToField: function() {
        if (this.userInterface) {
            this.userInterface.saveDestinationArea();
        }
        CQ.form.ImageMap.superclass.transferToField.call(this);
    },

    /**
     * Creates a string that represents all areas of the image map.
     * @return {String} A string that represents all areas of the image map.
     */
    serialize: function() {
        if (!this.isInitialized) {
            return null;
        }
        if (this.mapShapeSet == null) {
            return "";
        }
        var dump = "";
        var areaCnt = this.mapShapeSet.getShapeCount();
        for (var areaIndex = 0; areaIndex < areaCnt; areaIndex++) {
            var areaToAdd = this.mapShapeSet.getShapeAt(areaIndex);
            dump += "[" + areaToAdd.serialize() + "]";
        }
        return dump;
    },

    /**
     * <p>Creates the areas of the image map according to the specified string
     * representation.</p>
     * <p>The method may be used even before the component is completely initialized.
     * null values and empty strings are processed correctly.</p>
     * <p>To reflect the changes visually, {@link CQ.form.SmartImage.ImagePanel#drawImage}
     * must be called explicitly.</p>
     * @param {String} strDefinition String definition to create the image map areas (as
     *        created by {@link #serialize})
     */
    deserialize: function(strDefinition) {
        this.mapShapeSet.removeAllShapes();
        if (strDefinition && (strDefinition.length > 0)) {
            var processingPos = 0;
            while (processingPos < strDefinition.length) {
                var startPos = strDefinition.indexOf("[", processingPos);
                if (startPos < 0) {
                    break;
                }
                var coordEndPos = strDefinition.indexOf(")", startPos + 1);
                if (coordEndPos < 0) {
                    break;
                }
                var areaDef = strDefinition.substring(startPos + 1, coordEndPos + 1);
                var area = null;
                if (CQ.form.ImageMap.RectArea.isStringRepresentation(areaDef)) {
                    area = CQ.form.ImageMap.RectArea.deserialize(areaDef);
                } else if (CQ.form.ImageMap.PolyArea.isStringRepresentation(areaDef)) {
                    area = CQ.form.ImageMap.PolyArea.deserialize(areaDef);
                } else if (CQ.form.ImageMap.CircularArea.isStringRepresentation(areaDef)) {
                    area = CQ.form.ImageMap.CircularArea.deserialize(areaDef);
                }
                if (area != null) {
                    var oldProcessingPos = processingPos;
                    processingPos =
                            area.destination.deserialize(strDefinition, coordEndPos + 1);
                    this.mapShapeSet.addShape(area);
                    if (processingPos == null) {
                        CQ.Log.error("CQ.form.ImageMap#deserialize: Invalid map definition: " + strDefinition + "; trying to continue parsing.");
                        processingPos = strDefinition.indexOf("]", oldProcessingPos) + 1;
                    }
                } else {
                    CQ.Log.error("CQ.form.ImageMap#deserialize: Invalid area definition string: " + areaDef);
                    processingPos = strDefinition.indexOf("]", processingPos) + 1;
                }
            }
        }
    }

});

/**
 * Shape set ID to be used by image map.
 * @static
 * @final
 * @type String
 * @private
 */
CQ.form.ImageMap.SHAPESET_ID = "smartimage.imagemap";

/**
 * Edit mode: Add an element (new area or additional polygon point)
 * @static
 * @final
 * @type Number
 * @private
 */
CQ.form.ImageMap.EDITMODE_ADD = 0;

/**
 * Edit mode: Edit existing areas and/or polygon points
 * @static
 * @final
 * @type Number
 * @private
 */
CQ.form.ImageMap.EDITMODE_EDIT = 1;

/**
 * Area type: Square
 * @static
 * @final
 * @type Number
 * @private
 */
CQ.form.ImageMap.AREATYPE_RECT = 0;

/**
 * Area type: Circle
 * @static
 * @final
 * @type Number
 * @private
 */
CQ.form.ImageMap.AREATYPE_CIRCLE = 1;

/**
 * Area type: Polygon
 * @static
 * @final
 * @type Number
 * @private
 */
CQ.form.ImageMap.AREATYPE_POLYGON = 2;

/**
 * Area type: Point (as a part of a polygon)
 * @static
 * @final
 * @type Number
 * @private
 */
CQ.form.ImageMap.AREATYPE_POINT = 3;

/**
 * Prefix for events fired by the component
 * @static
 * @final
 * @type String
 * @private
 */
CQ.form.ImageMap.EVENT_PREFIX = "imagemap.";

/**
 * Name of the "modechange" event. This is sent if the edit mode is changed implicitly by
 * the canvas, for example when automatically switching from "add polygon" to "add polygon
 * point" mode.
 * @static
 * @final
 * @type String
 * @private
 */
CQ.form.ImageMap.EVENT_MODE_CHANGE = CQ.form.ImageMap.EVENT_PREFIX + "modechange";

/**
 * Name of the "visualchange" event. This is sent if the area(s) currently edited have
 * visually changed.
 * @static
 * @final
 * @type String
 * @private
 */
CQ.form.ImageMap.EVENT_VISUAL_CHANGE = CQ.form.ImageMap.EVENT_PREFIX + "visualchange";


/**
 * @class CQ.form.ImageMap.UI
 * @extends CQ.form.SmartImage.Tool.UserInterface
 * @private
 * The ImageMap.UI provides the external user interface
 * for the image map tool.
 * @constructor
 * Creates a new ImageMap.UI.
 * @param {Object} config The config object
 */
CQ.form.ImageMap.UI = CQ.Ext.extend(CQ.form.SmartImage.Tool.UserInterface, {

    /**
     * Flag if the tool is currently active (managed by {@link CQ.formImageMap})
     * @private
     * @type Boolean
     */
    isActive: false,

    /**
     * The basic working area
     * @private
     * @type CQ.form.SmartImage.ImagePanel
     */
    workingArea: null,

    /**
     * Current edit mode.
     * @private
     * @type Number
     */
    editMode: null,

    /**
     * Current area tyoe.
     * @private
     * @type Number
     */
    areaType: null,

    /**
     * The latest polygon shape added
     * @private
     * @type CQ.form.ImageMap.PolyArea
     */
    polyAreaAdded: null,

    /**
     * The {@link CQ.form.SmartImage.ShapeSet} used to display the map's areas.
     * @private
     * @type CQ.form.SmartImage.ShapeSet
     */
    mapShapeSet: null,


    constructor: function(config) {
        var clickHandler = function(item) {
            this.toolClicked(item.itemId);
        }.createDelegate(this);
        // as Ext does only save the CQ.Ext.Elements of toolbar items, we'll have to
        // keep references of the underlying buttons on our own
        this.toolbarButtons = {
            "addRect": new CQ.Ext.Toolbar.Button( {
                "itemId": "addRect",
                "text": CQ.I18n.getMessage("Rectangle"),
                "enableToggle": true,
                "toggleGroup": "mapperTools",
                "allowDepress": false,
                "handler": clickHandler
            } ),
            "addCircle": new CQ.Ext.Toolbar.Button( {
                "itemId": "addCircle",
                "text": CQ.I18n.getMessage("Circle"),
                "enableToggle": true,
                "toggleGroup": "mapperTools",
                "allowDepress": false,
                "handler": clickHandler
            } ),
            "addPoly": new CQ.Ext.Toolbar.Button( {
                "itemId": "addPoly",
                "text": CQ.I18n.getMessage("Polygon"),
                "enableToggle": true,
                "toggleGroup": "mapperTools",
                "allowDepress": false,
                "handler": clickHandler
            } ),
            "editPolyPoint": new CQ.Ext.Toolbar.Button( {
                "itemId": "editPolyPoint",
                "xtype": "tbbutton",
                "text": CQ.I18n.getMessage("Polygon point"),
                "enableToggle": true,
                "toggleGroup": "mapperTools",
                "allowDepress": false,
                "handler": clickHandler
            } ),
            "edit": new CQ.Ext.Toolbar.Button( {
                "itemId": "edit",
                "text": CQ.I18n.getMessage("Edit"),
                "enableToggle": true,
                "toggleGroup": "mapperTools",
                "allowDepress": false,
                "handler": clickHandler
            } )
        };

         var targetOptions = [ ];
        //CUSTOM_MCD  [RAJAT CHAWLA]
        //For creating the drop down list in the target option 
        targetOptions[0] = {
                "value": "_self",
                "text": "_self (same window)"
            };
        targetOptions[1] = {
                "value": "_blank",
                "text": "_blank (new window)"
            };
        //END CUSTOM_MCD



        var toolbar = new CQ.Ext.Toolbar( {
            "xtype": "toolbar",
            "items": [
                CQ.I18n.getMessage("Add") + ":",
                this.toolbarButtons["addRect"],
                this.toolbarButtons["addCircle"],
                this.toolbarButtons["addPoly"],
                this.toolbarButtons["editPolyPoint"],
                {
                    "xtype": "tbseparator"
                },
                this.toolbarButtons["edit"],
                {
                    "xtype": "tbseparator"
                }, {
                    "itemId": "delete",
                    "xtype": "tbbutton",
                    "text": CQ.I18n.getMessage("Delete"),
                    "handler": function() {
                        this.deleteSelection();
                    }.createDelegate(this)
                }
            ]
        } );
        var defaults = {
            "layout": "column",
            "bodyStyle": "padding-top: 1px; " +
                 "padding-bottom: 1px; " +
                 "padding-left: 3px; " +
                 "padding-right: 2px;",
            "width": CQ.themes.SmartImage.Tool.MAP_TOOLS_WIDTH,
            "tbar": toolbar,
            "items": [ {
                "itemId": "col1",
                "xtype": "panel",
                "layout": "form",
                "border": false,
                "columnWidth": 0.5,
                "labelWidth": CQ.themes.SmartImage.Tool.MAP_AREAEDITOR_LABEL_WIDTH,
                "defaults": {
                    "itemCls": "cq-map-areaeditor-fieldlabel",
                    "cls": "cq-map-areaeditor-text",
                    "fieldClass": "cq-map-areaeditor-text",
                    "width": CQ.themes.SmartImage.Tool.MAP_AREAEDITOR_FIELD_WIDTH
                },
                "items": [ {
                    "itemId": "areaDefUrl",
                    "name": "url",
                    "xtype": "pathfield",
                    "fieldLabel": "HREF",
                    "listeners": {
                        "dialogopen": {
                            "fn": function() {
                                this.__position = this.getPosition();
                                this.hide();
                            },
                            "scope": this
                        },
                        "dialogclose": {
                            "fn": function() {
                                this.show();
                                this.setPosition(this.__position);
                            },
                            "scope": this
                        }
                    }
                }, {
                    
            /* done by rajat start
                     "itemId": "areaDefTarget",
                    "name": "target",
                    "xtype": "textfield",
                    "fieldLabel": "Target"
                    */ // done by rajat end 
                    //CUSTOM_MCD  [RAJAT CHAWLA]
                    //For creating the drop down list in the target option 
                    "itemId": "areaDefTarget",
                    "name": "target",
                    "xtype": "selection",
                    "fieldLabel": "Target",
                    "options": targetOptions,
                    "type": "select"
                    //END CUSTOM_MCD    






               } ]
            }, {
                "itemId": "col2",
                "xtype": "panel",
                "layout": "form",
                "border": false,
                "columnWidth": 0.5,
                "labelWidth": CQ.themes.SmartImage.Tool.MAP_AREAEDITOR_LABEL_WIDTH,
                "defaults": {
                    "itemCls": "cq-map-areaeditor-fieldlabel",
                    "cls": "cq-map-areaeditor-text",
                    "fieldClass": "cq-map-areaeditor-text",
                    "width": CQ.themes.SmartImage.Tool.MAP_AREAEDITOR_FIELD_WIDTH
                },
                "items": [ {
                    "itemId": "areaDefText",
                    "name": "text",
                    "xtype": "textfield",
                    "fieldLabel": "Text"
                }, {
                    "itemId": "areaDefCoords",
                    "name": "coords",
                    "xtype": "textfield",
                    "fieldLabel": "Coordinates"
               } ]
            } ]
        };
        CQ.Util.applyDefaults(config, defaults);
        CQ.form.ImageMap.UI.superclass.constructor.call(this, config);
    },

    /**
     * Initializes the user interface's components.
     */
    initComponent: function() {
        CQ.form.ImageMap.UI.superclass.initComponent.call(this);
        this.areaDefUrl = this.items.get("col1").items.get("areaDefUrl");
        this.areaDefTarget = this.items.get("col1").items.get("areaDefTarget");
        this.areaDefText = this.items.get("col2").items.get("areaDefText");
        this.areaDefCoords = this.items.get("col2").items.get("areaDefCoords");
        this.areaDefCoords.on("specialkey", function(tf, keyEvent) {
            var editedArea = this.editedArea;
            if ((keyEvent.getKey() == CQ.Ext.EventObject.ENTER)
                    && (editedArea != null)) {
                if (editedArea.fromCoordString(this.areaDefCoords.getValue())) {
                    // var repaintAreas = [ editedArea ];
                    this.workingArea.drawImage();
                }
                this.areaDefCoords.setValue(editedArea.toCoordString());
            }
        }, this);
        this.setDestinationAreaEditorEnabled(false);
    },

    /**
     * Notifies the image map of the working area it is used on and the shape set it
     * must use for displaying the image area's shapes.
     * @param {CQ.form.SmartImage.ImagePanel} workingArea The working area
     * @param {CQ.form.SmartImage.ShapeSet} mapShapeSet The shape set
     */
    notifyWorkingArea: function(workingArea, mapShapeSet) {
        this.workingArea = workingArea;
        this.mapShapeSet = mapShapeSet;
        this.workingArea.on("addrequest", this.onAddRequest, this);
        this.workingArea.on("selectionchange", this.onSelectionChange, this);
        this.workingArea.on("dragchange", this.onVisualChange, this);
        this.workingArea.on("rollover", this.onRollover, this);
    },

    /**
     * Handler for clicks on tools (add rect/circle/polygon, edit, etc.).
     * @param {String} value The tool id ("edit", "editPolyPoint", "addRect", "addCircle",
     *        "addPoly")
     */
    toolClicked: function(value) {
        if (value == "edit") {
            this.switchEditMode(CQ.form.ImageMap.EDITMODE_EDIT, null);
        } else if (value == "editPolyPoint") {
            this.switchEditMode(
                    CQ.form.ImageMap.EDITMODE_EDIT,
                    CQ.form.ImageMap.AREATYPE_POINT);
        } else if (value == "addRect") {
            this.switchEditMode(
                    CQ.form.ImageMap.EDITMODE_ADD,
                    CQ.form.ImageMap.AREATYPE_RECT);
        } else if (value == "addCircle") {
            this.switchEditMode(
                    CQ.form.ImageMap.EDITMODE_ADD,
                    CQ.form.ImageMap.AREATYPE_CIRCLE);
        } else if (value == "addPoly") {
            this.switchEditMode(
                    CQ.form.ImageMap.EDITMODE_ADD,
                    CQ.form.ImageMap.AREATYPE_POLYGON);
        }
    },

    /**
     * Enables or disables the destination area editor.
     * @param {Boolean} isEnabled True to enable the destination area editor
     */
    setDestinationAreaEditorEnabled: function(isEnabled) {
        this.areaDefUrl.setDisabled(!isEnabled);
        this.areaDefTarget.setDisabled(!isEnabled);
        this.areaDefText.setDisabled(!isEnabled);
        this.areaDefCoords.setDisabled(!isEnabled);
    },

    /**
     * Saves the current content of the destination area editor to the specified image area.
     * @param {CQ.form.ImageMap.Area} area Area to save data to
     */
    saveDestinationArea: function(area) {
        if (!area) {
            area = this.editedArea;
        }
        if (area) {
            var url = this.areaDefUrl.getValue();
            if (url.length > 0) {
                if (url.charAt(0) != "/") {
                    var protocolSepPos = url.indexOf("://");
                    if (protocolSepPos < 0) {
                        if (url.indexOf("mailto:") != 0) {
                            url = "http://" + url;
                        }
                    }
                }
            }
            area.destination.url = url;
            area.destination.target = this.areaDefTarget.getValue();
            area.destination.text = this.areaDefText.getValue();
        }
    },

    /**
     * Loads the current content of the destination area editor from the specified image
     * area.
     * @param {CQ.form.ImageMap.Area} area area to load data from; null to clear the current
     *        content
     */
    loadDestinationArea: function(area) {
        if (area != null) {
            this.areaDefUrl.setValue(area.destination.url);
            this.areaDefTarget.setValue(area.destination.target);
            this.areaDefText.setValue(area.destination.text);
            this.areaDefCoords.setValue(area.toCoordString());
        } else {
            this.areaDefUrl.setValue("");
            this.areaDefTarget.setValue("");
            this.areaDefText.setValue("");
            this.areaDefCoords.setValue("");
        }
    },


    // Edit mode related stuff -------------------------------------------------------------

    /**
     * Switches edit mode.
     * @param {Number} editMode new edit mode; defined by constants with prefix
     *        EDITMODE_
     * @param {Number} areaType new area type (if applicable; for example the area to add);
     *        defined by constants with prefix AREATYPE_
     */
    switchEditMode: function(editMode, areaType) {
        this.editMode = editMode;
        this.areaType = areaType;
        this.adjustToolbar();
        if (this.editMode == CQ.form.ImageMap.EDITMODE_ADD) {
            this.finishPolygonBuilding(false);
            this.workingArea.blockRollOver();
            this.workingArea.clearSelection();
            this.workingArea.drawImage();
        } else if (this.editMode == CQ.form.ImageMap.EDITMODE_EDIT) {
            if (this.areaType != CQ.form.ImageMap.AREATYPE_POINT) {
                this.finishPolygonBuilding(false);
            }
            // repaintAreas = this.getSelectedAreas();
            this.workingArea.unblockRollOver();
            this.workingArea.drawImage();
        }
        if (!this.polyAreaAdded) {
            this.workingArea.drawImage();
        }
    },

    /**
     * Adjusts the toolbar to the current edit mode.
     * @private
     */
    adjustToolbar: function() {
        var valueToSelect = null;
        if (this.editMode == CQ.form.ImageMap.EDITMODE_EDIT) {
            if (this.areaType == CQ.form.ImageMap.AREATYPE_POINT) {
                valueToSelect = "editPolyPoint";
            } else {
                valueToSelect = "edit";
            }
        } else if (this.editMode == CQ.form.ImageMap.EDITMODE_ADD) {
            if (this.areaType == CQ.form.ImageMap.AREATYPE_RECT) {
                valueToSelect = "addRect";
            } else if (this.areaType == CQ.form.ImageMap.AREATYPE_POLYGON) {
                valueToSelect = "addPoly";
            } else if (this.areaType == CQ.form.ImageMap.AREATYPE_CIRCLE) {
                valueToSelect = "addCircle";
            }
        }
        for (var buttonId in this.toolbarButtons) {
            if (this.toolbarButtons.hasOwnProperty(buttonId)) {
                var item = this.toolbarButtons[buttonId];
                item.suspendEvents();
                item.toggle(buttonId == valueToSelect);
                item.resumeEvents();
            }
        }
    },

    /**
     * Deletes the currently selected areas and polygon points (if any).
     * @return {Boolean} True if at least one area has actually been deleted
     */
    deleteSelection: function() {
        // if there are any areas with polygon points selected, delete those points first
        var isHandleDeleted = false;
        var areaCnt = this.mapShapeSet.getShapeCount();
        for (var areaIndex = 0; areaIndex < areaCnt; areaIndex++) {
            var areaToCheck = this.mapShapeSet.getShapeAt(areaIndex);
            if (areaToCheck.areaType == CQ.form.ImageMap.AREATYPE_POLYGON) {
                if (areaToCheck.selectedHandle != null) {
                    areaToCheck.removePoint(areaToCheck.selectedHandle);
                    isHandleDeleted = true;
                }
            }
        }
        if (!isHandleDeleted) {
            // remove selected areas completely
            this.workingArea.deleteSelectedShapes();
        } else {
            this.workingArea.drawImage();
        }
    },

    /**
     * Finishes the building of a polygon (executed by the user).
     * @param {Boolean} requestRepaint True to request a repaint of the image; false if the
     *        redraw is executed later on
     * @private
     */
    finishPolygonBuilding: function(requestRepaint) {
        if (this.polyAreaAdded) {
            this.polyAreaAdded.isSelected = false;
            this.polyAreaAdded.selectedHandle = null;
            if (requestRepaint) {
                this.workingArea.drawImage();
            }
        }
        this.polyAreaAdded = null;
    },


    // Event handling ----------------------------------------------------------------------

    /**
     * Handles "add (something) requested (by user)".
     * @param {Object} coords Coordinates; properties: x, y
     */
    onAddRequest: function(coords) {
        if (this.isActive) {
            coords = coords.unzoomed;
            if (this.editMode == CQ.form.ImageMap.EDITMODE_ADD) {
                var shapeToAdd;
                if (this.areaType == CQ.form.ImageMap.AREATYPE_RECT) {
                    shapeToAdd = new CQ.form.ImageMap.RectArea({ },
                        coords.y, coords.x, coords.y + 1, coords.x + 1);
                } else if (this.areaType == CQ.form.ImageMap.AREATYPE_CIRCLE) {
                    shapeToAdd = new CQ.form.ImageMap.CircularArea({ },
                        coords.x, coords.y, 1);
                } else if (this.areaType == CQ.form.ImageMap.AREATYPE_POLYGON) {
                    shapeToAdd = new CQ.form.ImageMap.PolyArea({ }, coords.x, coords.y);
                    shapeToAdd.selectPointAt(0);
                    this.polyAreaAdded = shapeToAdd;
                }
                if (shapeToAdd) {
                    this.workingArea.selectShape(shapeToAdd);
                    this.mapShapeSet.addShape(shapeToAdd);
                    this.workingArea.scheduleForDragging(shapeToAdd);
                }
            } else if ((this.editMode == CQ.form.ImageMap.EDITMODE_EDIT)
                    && (this.areaType == CQ.form.ImageMap.AREATYPE_POINT)) {
                // adding polygon point
                var polyToEdit;
                if (this.polyAreaAdded) {
                    polyToEdit = [ this.polyAreaAdded ];
                } else {
                    polyToEdit = this.workingArea.getRolledOverShapes();
                }
                var pointAdded;
                var isPointAdded = false;
                var blockAddPoint = false;
                var tolerance = this.workingArea.getTolerance();
                polyToEdit =
                    this.filterOnAreaType(polyToEdit, CQ.form.ImageMap.AREATYPE_POLYGON);
                if (polyToEdit.length > 0) {
                    var addCnt = polyToEdit.length;
                    for (var addIndex = 0; addIndex < addCnt; addIndex++) {
                        var polygonToProcess = polyToEdit[addIndex];
                        // add new point if no handle is selected, otherwise just move the
                        // existing handle
                        if (polygonToProcess.handleId == null) {
                            pointAdded = polygonToProcess.insertPoint(
                                    coords.x, coords.y, tolerance);
                            if (pointAdded != null) {
                                polygonToProcess.handleId = pointAdded;
                                polygonToProcess.selectPoint(pointAdded);
                                isPointAdded = true;
                            }
                        } else {
                            // use default move when added to a rolled over point
                            blockAddPoint = true;
                        }
                    }
                }
                // if we can neither insert the point on an existing edge of the shape nor
                // move an existing point, then we just add the point if we are building a
                // new polygon
                if (!isPointAdded && this.polyAreaAdded && !blockAddPoint) {
                    pointAdded = this.polyAreaAdded.addPoint(coords.x, coords.y);
                    if (pointAdded != null) {
                        this.polyAreaAdded.selectPoint(pointAdded);
                    }
                }
                this.workingArea.drawImage();
            }
        }
    },

    /**
     * Handles selection change events by adapting the "area destination" editor to the
     * selected areas.
     * @param {CQ.form.ImageMap.Area[]} selectedAreas list with currently selected areas
     * @private
     */
    onSelectionChange: function(selectedAreas) {
        if (this.isActive) {
            var logText =
                    "ImageMap#onSelectionChange: Received selection change for areas: ";
            if (selectedAreas.length > 0) {
                var selectionCnt = selectedAreas.length;
                for (var ndx = 0; ndx < selectionCnt; ndx++) {
                    if (ndx > 0) {
                        logText += ", ";
                    }
                    logText += selectedAreas[ndx].serialize();
                }
            } else {
                logText += "None";
            }
            CQ.Log.debug(logText);
            if (this.editedArea != null) {
                this.saveDestinationArea(this.editedArea);
            }
            if (selectedAreas.length == 1) {
                this.editedArea = selectedAreas[0];
                this.loadDestinationArea(this.editedArea);
                this.setDestinationAreaEditorEnabled(true);
            } else {
                this.editedArea = null;
                this.loadDestinationArea(null);
                this.setDestinationAreaEditorEnabled(false);
            }
        }
    },

    /**
     * Handles visual changes (such as move, add/remove polygon point).
     * @param {CQ.form.ImageMap.Area[]} changedAreas Array of areas that have changed (and
     *        hence must be updated)
     * @param {Boolean} isDragEnd True if the event signals the end of a drag operation
     * @private
     */
    onVisualChange: function(changedAreas, isDragEnd) {
        if (this.isActive) {
            var areaCnt = changedAreas.length;
            var coordStr;
            var isSet = false;
            for (var areaIndex = 0; areaIndex < areaCnt; areaIndex++) {
                if (changedAreas[areaIndex] == this.editedArea) {
                    coordStr = this.editedArea.toCoordString();
                    this.areaDefCoords.setValue(coordStr);
                    isSet = true;
                    break;
                }
            }
            if (!isSet && (changedAreas.length == 1)) {
                coordStr = changedAreas[0].toCoordString();
                this.areaDefCoords.setValue(coordStr);
            }
            if (isDragEnd && ((this.editMode == CQ.form.ImageMap.EDITMODE_ADD)
                    && (this.areaType == CQ.form.ImageMap.AREATYPE_POLYGON))) {
                this.switchEditMode(CQ.form.ImageMap.EDITMODE_EDIT,
                    CQ.form.ImageMap.AREATYPE_POINT);
            }
        }
    },

    /**
     * Handles rollover events.
     * @param {Array} rolloveredAreas list with currently "rolled over areas"
     * @private
     */
    onRollover: function(rolloveredAreas) {
        if (this.isActive) {
            var logText = "ImageMap#onRollover: Received rollover for areas: ";
            if (rolloveredAreas.length > 0) {
                var rolloverCnt = rolloveredAreas.length;
                for (var ndx = 0; ndx < rolloverCnt; ndx++) {
                    if (ndx > 0) {
                        logText += ", ";
                    }
                    logText += rolloveredAreas[ndx].serialize();
                }
            } else {
                logText += "None";
            }
            CQ.Log.debug(logText);
            if (this.editedArea == null) {
                if (rolloveredAreas.length == 1) {
                    this.loadDestinationArea(rolloveredAreas[0]);
                } else {
                    this.loadDestinationArea(null);
                }
            }
        }
    },


    // Helpers -----------------------------------------------------------------------------

    /**
     * Filters the specified list of areas for a specific area type.
     * @param {CQ.form.ImageMap.Area[]} listToFilter The area list to be filtered
     * @param {Number} areaType Area type to be recognized for the filtered list
     * @return {CQ.form.ImageMap.Area[]} The filtered list
     */
    filterOnAreaType: function(listToFilter, areaType) {
        var filteredAreas = new Array();
        var areaCnt = listToFilter.length;
        for (var areaNdx = 0; areaNdx < areaCnt; areaNdx++) {
            var areaToCheck = listToFilter[areaNdx];
            if (areaToCheck.areaType == areaType) {
                filteredAreas.push(areaToCheck);
            }
        }
        return filteredAreas;
    }

});


/**
 * @class CQ.form.ImageMap.AreaDestination
 * @private
 * This class defines the destination of an image map area. It consists of the target url,
 * the target window and a descriptive text.
 * @constructor
 * Creates a new ImageMap.AreaDestination.
 * @param {String} url URL/HREF of the area (optional)
 * @param {String} target target frame of the area (optional)
 * @param {String} text descriptive text of the area (optional)
 */
CQ.form.ImageMap.AreaDestination = CQ.Ext.extend(CQ.Ext.emptyFn, {

    /**
     * @property {String} url
     * The destination URL of the image area
     */
    url: null,

    /**
     * @property {String} target
     * The target attribute of the image area
     */
    target: null,

    /**
     * @property {String} text
     * Descriptive text for the image area
     */
    text: null,

    constructor: function(url, target, text) {
        this.url = (url ? url : "");
        this.target = (target ? target : "");
        this.text = (text ? text : "");
    },

    /**
     * Creates a string representation of the destination (used for serialization).
     * @return {String} A string representation of the destination
     */
    serialize: function() {
        var dump = "";
        if (this.url && (this.url.length > 0)) {
            dump += "\"" + CQ.form.ImageMap.Helpers.encodeString(this.url) + "\"";
        }
        dump += "|";
        if (this.target && (this.target.length > 0)) {
            dump += "\"" + CQ.form.ImageMap.Helpers.encodeString(this.target) + "\"";
        }
        dump += "|";
        if (this.text && (this.text.length > 0)) {
            dump += "\"" + CQ.form.ImageMap.Helpers.encodeString(this.text) + "\"";
        }
        return dump;
    },

    /**
     * <p>Sets the destination from the specified image map string (full version).</p>
     * <p>The format is as defined by {@link #serialize}.</p>
     * @param {String} value The image map definition (full version)
     * @param {Number} parseStartPos Start position (in value) where the destination has to
     *        be parsed from
     * @return {Number} The character position that follows the parsed text; null if the
     *         destination could not be parsed correctly
     */
    deserialize: function(value, parseStartPos) {
        var parsePos = parseStartPos;
        var parseResult, charToCheck;
        if (parsePos < value.length) {
            charToCheck = value.charAt(parsePos);
            if (charToCheck != "|") {
                parseResult =
                    CQ.form.ImageMap.Helpers.decodeFromContainingString(value, parsePos);
                if (parseResult == null) {
                    return null;
                } else {
                    this.url = parseResult.decoded;
                    parsePos = parseResult.nextPos;
                }
            }
            parsePos++;
        }
        if (parsePos < value.length) {
            charToCheck = value.charAt(parsePos);
            if (charToCheck != "|") {
                parseResult =
                    CQ.form.ImageMap.Helpers.decodeFromContainingString(value, parsePos);
                if (parseResult == null) {
                    return null;
                } else {
                    this.target = parseResult.decoded;
                    parsePos = parseResult.nextPos;
                }
            }
            parsePos++;
        }
        if (parsePos < value.length) {
            charToCheck = value.charAt(parsePos);
            if (charToCheck != "]") {
                parseResult =
                    CQ.form.ImageMap.Helpers.decodeFromContainingString(value, parsePos);
                if (parseResult == null) {
                    return null;
                } else {
                    this.text = parseResult.decoded;
                    parsePos = parseResult.nextPos;
                }
            }
        }
        return parsePos + 1;
    }

});


/**
 * @class CQ.form.ImageMap.Helpers
 * @static
 * @private
 * This static class provides helper functions used by the image map component.
 */
CQ.form.ImageMap.Helpers = function() {

    return {

        /**
         * Checks if the specified relative intersection coordinate (either horizontal or
         * vertical) is inside the valid range (0< to deltaValue if deltaValue &gt; 0; else
         * deltaValue to 0.
         * @param {Number} intersectValue relative (to the respective line start coordinate)
         *        intersection coordinate to check
         * @param {Number} deltaValue range to check
         */
        checkIntersection: function(intersectValue, deltaValue) {
            if (deltaValue < 0) {
                return (intersectValue > deltaValue) && (intersectValue <= 0);
            } else {
                return (intersectValue >= 0) && (intersectValue < deltaValue);
            }
        },

        /**
         * Calculates the distance for lines that do not extend in one dimension (vertical
         * and horizontal lines).
         * @param {Number} paraDist Distance to the line in the dimension the line does not
         *        extend (for vertical lines: horizontal coordinate)
         * @param {Number} orthDist Distance to the line in the orthogonal dimension (for
         *        vertical lines: vertical coordinate)
         * @param {Number} orthDelta Extent of the line (for vertical lines: vertical length
         *        of the line)
         * @return {Number} The correct distance in pixels
         */
        calculateNoAngledDistance: function(paraDist, orthDist, orthDelta) {
            var distance = Math.abs(paraDist);
            var otherEndDist = orthDist - orthDelta;
            if (orthDelta < 0) {
                if (orthDist > 0) {
                    distance = Math.sqrt(Math.pow(orthDist, 2) + Math.pow(paraDist, 2));
                } else if (orthDist < orthDelta) {
                    distance = Math.sqrt(Math.pow(otherEndDist, 2) + Math.pow(paraDist, 2));
                }
            } else {
                if (orthDist < 0) {
                    distance = Math.sqrt(Math.pow(orthDist, 2) + Math.pow(paraDist, 2));
                } else if (orthDist > orthDelta) {
                    distance = Math.sqrt(Math.pow(otherEndDist, 2) + Math.pow(paraDist, 2));
                }
            }
            return distance;
        },

        /**
         * <p>Calculates the distance of a point to a specified line.</p>
         * <p>The distance is calculated using the orthogonal. If no orthogonal exists, the
         * minimum distance of the point to one of the extreme line points is used.</p>
         * @param {Object} lineStart Starting point of the line (properties x, y)
         * @param {Object} lineEnd Ending point of the line (properties x, y)
         * @param {Object} point Point for which the distance has to be calculated;
         *        (properties x, y)
         * @return {Number} The distance of the point to the specified line
         */
        calculateDistance: function(lineStart, lineEnd, point) {
            var xOrigin = lineStart.x;
            var yOrigin = lineStart.y;
            var deltaX = lineEnd.x - xOrigin;
            var deltaY = lineEnd.y - yOrigin;
            var xDist = point.x - xOrigin;
            var yDist = point.y - yOrigin;
            if ((Math.abs(deltaX) > 0) && (Math.abs(deltaY) > 0)) {
                // lines with angles != 0, 90, 180, 270 degrees
                var slope = deltaY / deltaX;
                var invSlope = 1 / slope;
                var intersectionX = (xDist * invSlope + yDist) / (slope + invSlope);
                var intersectionY = intersectionX * slope;
                var hasIntersection =
                    CQ.form.ImageMap.Helpers.checkIntersection(intersectionX, deltaX)
                    && CQ.form.ImageMap.Helpers.checkIntersection(intersectionY, deltaY);
                if (hasIntersection) {
                    return Math.sqrt(Math.pow(intersectionX - xDist, 2)
                        + Math.pow(yDist - intersectionY, 2));
                } else {
                    // if no intersection could be detected, use the minimal distance to
                    // one of the extreme points of the line
                    var distStart = Math.sqrt(Math.pow(xDist, 2) + Math.pow(yDist, 2));
                    var distEnd = Math.sqrt(
                        Math.pow(xDist - deltaX, 2) + Math.pow(yDist - deltaY, 2));
                    return (distStart < distEnd ? distStart : distEnd);
                }
            } else {
                // lines with angles == 0, 90, 180, 270 degrees
                if ((deltaX == 0) && (deltaY == 0)) {
                    // point
                    return Math.sqrt(Math.pow(xDist, 2), Math.pow(yDist, 2));
                } else if (deltaX == 0) {
                    // vertical line
                    return CQ.form.ImageMap.Helpers
                            .calculateNoAngledDistance(xDist, yDist, deltaY);
                } else {
                    // horizontal line
                    return CQ.form.ImageMap.Helpers
                            .calculateNoAngledDistance(yDist, xDist, deltaX);
                }
            }
        },

        /**
         * Calculates the distance of a point to a specified circle's outline.
         * @param {Object} circleDef Circle definition (properties: x, y [specifiying the
         *        circle's center] and radius)
         * @param point Point (properties: x, y
         * @return {Number} The distance of the point to the specified line
         */
        calculateDistanceToCircle: function(circleDef, point) {
            var deltaX = point.x - circleDef.x;
            var deltaY = point.y - circleDef.y;
            var slope = deltaY / deltaX;
            if ((deltaX != 0) && (deltaY != 0)) {
                var angle = Math.atan(slope);
                var outlineX = Math.cos(angle) * circleDef.radius;
                var outlineY = Math.sin(angle) * circleDef.radius;
                if (deltaX < 0) {
                    outlineY = -outlineY;
                    outlineX = -outlineX;
                }
                var diffX = outlineX - deltaX;
                var diffY = outlineY - deltaY;
                return Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2));
            } else {
                return Math.abs(deltaY - circleDef.radius);
            }
        },

        /**
         * Compacts the specified array: All elements of value null will be removed, the
         * array size will be adjusted accordingly.
         * @param {Array} arrayToCompact array to compact
         */
        compactArray: function(arrayToCompact) {
            var elementCnt = arrayToCompact.length;
            var destIndex = 0;
            for (var compactIndex = 0; compactIndex < elementCnt; compactIndex++) {
                if (arrayToCompact[compactIndex] != null) {
                    if (compactIndex != destIndex) {
                        arrayToCompact[destIndex] = arrayToCompact[compactIndex];
                    }
                    destIndex++;
                }
            }
            arrayToCompact.length = destIndex;
        },

        /**
         * <p>Encodes the specified string as follows:</p>
         * <ul>
         * <li>""" will be encoded to "\""</li>
         * <li>"[" will be encoded to "\["</li>
         * <li>"]" will be encoded to "\]"</li>
         * <li>"\" will be encoded to "\\"</li>
         * <li>"|" will be encoded to "\|"</li>
         * </ul>
         * @param {String} str String to encode
         * @return {String} The encoded string
         */
        encodeString: function(str) {
            var charCnt = str.length;
            var destStr = "";
            var copyPos = 0;
            for (var charIndex = 0; charIndex < charCnt; charIndex++) {
                var charToCheck = str.charAt(charIndex);
                var escapedChar = null;
                switch (charToCheck) {
                    case '\\':
                        escapedChar = "\\\\";
                        break;
                    case '\"':
                        escapedChar = "\\\"";
                        break;
                    case '[':
                        escapedChar = "\\[";
                        break;
                    case ']':
                        escapedChar = "\\]";
                        break;
                    case '|':
                        escapedChar = "\\|";
                        break;
                }
                if (escapedChar != null) {
                    if (copyPos < charIndex) {
                        destStr += str.substring(copyPos, charIndex);
                    }
                    destStr += escapedChar;
                    copyPos = charIndex + 1;
                }
            }
            if (copyPos < charCnt) {
                destStr += str.substring(copyPos, charCnt);
            }
            return destStr;
        },

        /**
         * <p>Decodes a string (encoded using {@link #encodeString}) that is contained in
         * another string. The (partial) string to parse has to be enclosed in quotation
         * marks.</p>
         * <p>For example:<br>
         * decodeFromContainingString("x:\&quot;abc\\&quot;\&quot;", 2)<br>
         * will return<br>
         * { "decoded": "abc&quot;", "nextPos": 9 }</p>
         * @param {String} containingString The containing string
         * @param {Number} parseStartPos The position where parsing should start
         * @return {Object} The decoding result; properties decoded (the decoded string),
         *         nextPos (the first character position after the closing quotation);
         *         null if no string could have been decoded
         */
        decodeFromContainingString: function(containingString, parseStartPos) {
            var quotPos = containingString.indexOf("\"", parseStartPos);
            if (quotPos < 0) {
                return null;
            }
            var isDone = false;
            var currentCharPos = quotPos + 1;
            var text = "";
            var isEscaped = false;
            while (!isDone) {
                var charToProcess = containingString.charAt(currentCharPos);
                if ((charToProcess == '\"') && (!isEscaped)) {
                    isDone = true;
                } else if (charToProcess == '\\') {
                    if (isEscaped) {
                        text += "\\";
                        isEscaped = false;
                    } else {
                        isEscaped = true;
                    }
                } else if (isEscaped) {
                    text += charToProcess;
                    isEscaped = false;
                } else {
                    text += charToProcess;
                }
                currentCharPos++;
                if ((currentCharPos >= containingString.length) && (!isDone)) {
                    return null;
                }
            }
            return { "decoded": text, "nextPos": currentCharPos };
        },

        /**
         * Parses a coordinate from a containing string, starting at the specified position.
         * @param {String} str The containing string
         * @param {Number} parseStartPos The (character) position where parsing will begin
         * @return {Object} properties: coordinate, nextPos (next parsing position) and
         *         isError (set to true if there was a parsing error); null if no more
         *         coordinates could have been parsed
         */
        parseCoordinateFromContainingString: function(str, parseStartPos) {
            var strLen = str.length;
            var processingPos = parseStartPos;
            // skip leasing spaces
            while (processingPos < strLen) {
                var charToCheck = str.charAt(processingPos);
                if (charToCheck != " ") {
                    break;
                }
                processingPos++;
            }
            if (processingPos >= strLen) {
                return null;
            }
            var result = new Object();
            result.isError = false;
            // determine type of coordinate
            if (str.charAt(processingPos) == "(") {
                // coordinate pair
                var coordEndPos = str.indexOf(")", processingPos + 1);
                if (coordEndPos < 0) {
                    result.isError = true;
                    return result;
                }
                var coords = str.substring(processingPos + 1, coordEndPos);
                var coordArray = coords.split("/");
                if (coordArray.length != 2) {
                    result.isError = true;
                    return result;
                }
                var x = parseInt(coordArray[0]);
                var y = parseInt(coordArray[1]);
                if (isNaN(x) || isNaN(y)) {
                    result.isError = true;
                    return result;
                }
                result.coordinates = { "x": x, "y": y };
                result.isCoordinatesPair = true;
                processingPos = coordEndPos + 1;
            } else {
                // special notation
                var sepPos = str.indexOf(":", processingPos);
                if (sepPos < (processingPos + 1)) {
                    result.isError = true;
                    return result;
                }
                var key = str.substring(processingPos, sepPos);
                var endPosSpace = str.indexOf(" ", sepPos + 1);
                var endPosBrace = str.indexOf("(", sepPos + 1);
                var value;
                if ((endPosSpace >= 0) && (endPosBrace >= 0)) {
                    if (endPosSpace < endPosBrace) {
                        value = str.substring(sepPos + 1, endPosSpace);
                        processingPos = endPosSpace;
                    } else {
                        value = str.substring(sepPos + 1, endPosBrace);
                        processingPos = endPosBrace;
                    }
                } else if (endPosSpace >= 0) {
                    value = str.substring(sepPos + 1, endPosSpace);
                    processingPos = endPosSpace;
                } else if (endPosBrace >= 0) {
                    value = str.substring(sepPos + 1, endPosBrace);
                    processingPos = endPosBrace;
                } else {
                    if ((sepPos + 1) >= str.length) {
                        result.isError = true;
                        return result;
                    }
                    value = str.substring(sepPos + 1, str.length);
                    processingPos = str.length;
                }
                if (key == "r") {
                    // radius
                    var radius = parseInt(value);
                    if (isNaN(radius)) {
                        result.isError = true;
                        return result;
                    }
                    result.coordinates = { "radius" : radius };
                    result.isCoordinatesPair = false;
                } else {
                    result.isError = true;
                    return result;
                }
            }
            result.nextPos = processingPos;
            return result;
        },

        /**
         * Parses a coordinate string and returns a list of coordinates.
         * @param {String} str string to parse
         * @return {Object} Properties: coordinates (Array with coordinate objects
         *         [properties: x, y or radius if a radius was specified],
         *         coordinatesPairCnt (number of coordinate pairs; may differ from the size
         *         of the coordinates object, if a radius or such has been specified));
         *         null if an invalid coordinate string has been specified
         */
        parseCoordinateString: function(str) {
            var coords = new Array();
            var parsePos = 0;
            var coordinatesPairCnt = 0;
            while (parsePos >= 0) {
                var parsePart = CQ.form.ImageMap.Helpers
                        .parseCoordinateFromContainingString(str, parsePos);
                if (parsePart != null) {
                    if (parsePart.isError) {
                        return null;
                    }
                    coords[coords.length] = parsePart.coordinates;
                    if (parsePart.isCoordinatesPair) {
                        coordinatesPairCnt++;
                    }
                    parsePos = parsePart.nextPos;
                } else {
                    // we are done here
                    parsePos = -1;
                }
            }
            return { "coordinates": coords, "coordinatesPairCnt": coordinatesPairCnt };
        },

        /**
         * Parses a CSS "rect" definition (Format: "rect([top] [right] [bottom] [left])";
         * currently no parsing tolerance regarding the format implemented).
         * @param {String} rectDef The CSS "rect" definition to parse
         * @return {Object} The parsed values; properties: top, left, bottom, right
         */
        parseRectDef: function(rectDef) {
            var clipDef = null;
            var startPos = rectDef.indexOf("(");
            if (startPos >= 0) {
                var endPos = rectDef.indexOf(")", startPos + 1);
                if (endPos > startPos) {
                    var clipDefStr = rectDef.substring(startPos + 1, endPos);
                    var clipDefCoords = clipDefStr.split(" ");
                    if (clipDefCoords.length == 4) {
                        clipDef = new Object();
                        clipDef.top = clipDefCoords[0];
                        clipDef.left = clipDefCoords[3];
                        clipDef.bottom = clipDefCoords[2];
                        clipDef.right = clipDefCoords[1];
                    }
                }
            }
            return clipDef;
        }

    };
}();


/**
 * @class CQ.form.ImageMap.Area
 * @extends CQ.form.SmartImage.Shape
 * @private
 * The CQ.form.ImageMap.Area is the basic class used for implementing the area types of an
 * image map.
 * @constructor
 * Creates a new ImageMap.Area.
 * @param {Number} areaType area type to create
 * @param {Object} config The config object
 */
CQ.form.ImageMap.Area = CQ.Ext.extend(CQ.form.SmartImage.Shape, {

    /**
     * Type of the area; as represented by constants with prefix CQ.form.ImageMap.AREATYPE_
     * @type String
     * @private
     */
    areaType: null,

    /**
     * Destination of the area.
     * @type CQ.form.ImageMap.AreaDestination
     * @private
     */
    destination: null,

    /**
     * @cfg {String} fillColor Fill color
     */
    fillColor: null,

    /**
     * @cfg {String} shadowColor "Shadow" color
     */
    shadowColor: null,

    /**
     * @cfg {String} basicShapeColor Basic color
     */
    basicShapeColor: null,

    /**
     * @cfg {String} rolloverColor Rollover color
     */
    rolloverColor: null,

    /**
     * @cfg {String} selectedColor Selection color
     */
    selectedColor: null,

    /**
     * @cfg {Number} handleSize The size of a "Handle"
     */
    handleSize: 0,

    /**
     * @cfg {String} handleColor "Handle" color
     */
    handleColor: null,

    /**
     * @cfg {String} handleRolloverColor "Handle" color when rolled over
     */
    handleRolloverColor: null,

    /**
     * @cfg {String} handleSelectedColor "Handle" color when selected
     */
    handleSelectedColor: null,

    /**
     * Flag if the area is currently rolled over
     * @type Boolean
     * @private
     */
    isRollOver: false,

    /**
     * Flag if the area is currently selected
     * @type Boolean
     * @private
     */
    isSelected: false,

    /**
     * Flag if a Handle is rolled over
     * @type Boolean
     * @private
     */
    isHandleRolledOver: false,

    /**
     * Currently rolled over handle
     * @type Object
     * @private
     */
    handleId: null,


    // Lifecycle ---------------------------------------------------------------------------

    constructor: function(areaType, config) {
        this.areaType = areaType;
        this.destination = new CQ.form.ImageMap.AreaDestination();
        this.handleId = null;
        this.isSelected = false;
        this.isRollOver = false;
        config = config || { };
        var defaults = {
            "fillColor": CQ.themes.ImageMap.FILL_COLOR,
            "shadowColor": CQ.themes.ImageMap.SHADOW_COLOR,
            "basicShapeColor": CQ.themes.ImageMap.BASIC_SHAPE_COLOR,
            "rolloverColor": CQ.themes.ImageMap.ROLLOVER_COLOR,
            "selectedColor": CQ.themes.ImageMap.SELECTED_COLOR,
            "handleSize": CQ.themes.ImageMap.HANDLE_SIZE,
            "handleColor": CQ.themes.ImageMap.HANDLE_COLOR,
            "handleRolloverColor": CQ.themes.ImageMap.HANDLE_ROLLOVER_COLOR,
            "handleSelectedColor": CQ.themes.ImageMap.HANDLE_SELECTED_COLOR
        };
        CQ.Ext.apply(this, config, defaults);
    },


    // Helpers -----------------------------------------------------------------------------

    /**
     * Checks if the specified coordinates touch the specified handle coordinates.
     * @param {Number} handleX The horizontal position of the handle
     * @param {Number} handleY The vertical position of the handle
     * @param {Object} coords Coordinates to check; properties: x, y
     * @return True if the specified coordinates touch the handle coordinates
     */
    isPartOfHandle: function(handleX, handleY, coords) {
        var absZoom = (coords.unzoomed.absoluteZoom + 1);
        var absHandleSize = Math.ceil(this.handleSize / absZoom);
        var x1 = handleX - absHandleSize;
        var x2 = handleX + absHandleSize;
        var y1 = handleY - absHandleSize;
        var y2 = handleY + absHandleSize;
        coords = coords.unzoomedUnclipped;
        return ((coords.x >= x1) && (coords.x <= x2)
                && (coords.y >= y1) && (coords.y <= y2));
    },

    /**
     * Checks if any of the four edges is rolled over (which leads to a point move instead
     * of a shape move) for the specified coordinates and sets the handleId property
     * accordingly.
     * @param {Object} coords The coordinates to check; properties: x, y
     * @return {Boolean} True if a handle is rolled over for the specified coordinates
     */
    checkAndSetHandle: function(coords) {
        this.handleId = this.calculateHandleId(coords);
        return (this.handleId != null);
    },

    /**
     * Calculates the basic angle (= the angle before any rotation is applied).
     * @param {Number} angle The angle to rotate by (in degrees)
     * @param {Number} absAngle The absolute angle after rotation (in degrees)
     * @return {Number} The absolute angle before rotation (in degrees; values: 0 .. 359)
     */
    calcBasicAngle: function(angle, absAngle) {
        var basicAngle = absAngle - angle;
        while (basicAngle < 0) {
            basicAngle = 360 - basicAngle;
        }
        basicAngle = basicAngle % 360;
        return basicAngle;
    },


    // Interface implementation ------------------------------------------------------------

    /**
     * <p>Default implementation to detect if a single point should be moved when dragged
     * from the specified coordinates.</p>
     * <p>Point moves don't require the user to drag a certain distance before the dragging
     * starts, so this is implemented as a "direct" drag operation.</p>
     * @param {Object} coords The coordinates; properties: x, y
     * @param {Number} tolerance The tolerance distance used
     */
    isDirectlyDraggable: function(coords, tolerance) {
        return this.checkAndSetHandle(coords);
    },

    /**
     * <p>Default implementation to detect if the area as a whole should be moved when
     * dragged from the specified coordinates.</p>
     * <p>As {@link #isDirectlyDraggable} is called first, we don't have to check
     * if a point move is more suitable (as this is done by the method mentioned before).
     * </p>
     * @param {Object} coords The coordinates to check
     * @param {Number} tolerance The tolerance distance
     * @return {Boolean} True if the area should be moved
     */
    isDeferredDraggable: function(coords, tolerance) {
        return this.isTouched(coords, tolerance);
    },

    /**
     * Default implementation for rollOver events. Sets the state accordingly and requests
     * a redraw of the area in its new state.
     * @param {Object} coords Mouse pointer coordinates of the rollover (properties: x, y)
     * @return {Boolean} True to request a redraw of the area
     */
    onRollOver: function(coords) {
        this.isRollOver = true;
        this.isHandleRolledOver = this.checkAndSetHandle(coords);
        CQ.Log.debug("CQ.form.ImageMap.Area.onRollOver: rollover detected.");
        return true;
    },

    /**
     * Default implementation for rolledOver events. Checks if a handle is now selected
     * and adjusts the state accordingly.
     * @param {Object} coords Current mouse pointer coordinates (properties: x, y)
     */
    onRolledOver: function(coords) {
        var oldHandle = this.handleId;
        this.checkAndSetHandle(coords);
        return (oldHandle != this.handleId);
    },

    /**
     * Default implementation for rollOut events. Sets the state accordingly and requests
     * a redraw of the area in its new state.
     * @return {Boolean} True to request a redraw of the area
     */
    onRollOut: function() {
        this.isRollOver = false;
        this.isHandleRolledOver = false;
        this.handleId = null;
        CQ.Log.debug("CQ.form.ImageMap.Area.onRollOut: rollout detected.");
        return true;
    },

    /**
     * Default implementation for select events. Sets the state accordingly and requests
     * a redraw of the area in its new state.
     * @return {Boolean} True to request a redraw of the area
     */
    onSelect: function() {
        this.isSelected = true;
        return true;
    },

    /**
     * Default implementation for unselect events. Sets the state accordingly and requests
     * a redraw of the area in its new state.
     * @return {Boolean} True to request a redraw of the area
     */
    onUnSelect: function() {
        this.isSelected = false;
        return true;
    },

    /**
     * Handler that is called when a drag operation starts. It detects if a point move or a
     * shape move has to be executed.
     * @param {Object} coords Mouse pointer coordinates where dragging starts (properties:
     *        x, y)
     * @param {Number} tolerance The tolerance distance
     */
    onDragStart: function(coords, tolerance) {
        this.pointToMove = this.handleId;
        this.calculateDraggingReference();
        return false;
    },

    /**
     * <p>Calculates actual coordinates from the specified offsets that relate to the
     * specified base coordinates.<p>
     * <p>If bounds is specified, it is ensured that the returned destination coordinates
     * are inside the specified boundaries.</p>
     * @param {Number} xOffs The horizontal offset (relative to (baseCoords)
     * @param {Number} yOffs The vertical offset (relative to baseCoords)
     * @param {Object} baseCoords The base coordinates (specified by properties x, y)
     * @param {Object} bounds (optional) bounds for the destination coordinates (specified
     *        by properties width, height)
     * @return {Object} actual destination coordinates (specified by properties x, y)
     */
    calculateDestCoords: function(xOffs, yOffs, baseCoords, bounds) {
        var destX = baseCoords.x + xOffs;
        var destY = baseCoords.y + yOffs;
        if (bounds) {
            if (destX < 0) {
                destX = 0;
            }
            if (destX >= bounds.width) {
                destX = bounds.width - 1;
            }
            if (destY < 0) {
                destY = 0;
            }
            if (destY >= bounds.height) {
                destY = bounds.height - 1;
            }
        }
        return {
            "x": destX,
            "y": destY
        };
    },


    // Additional interface ----------------------------------------------------------------

    /**
     * This method must checks if the area is valid.
     * @param {Object} coords Coordinates to check (properties: x, y)
     * @return {Boolean} True if the area is valid
     */
    isValid: function(coords) {
        // This method must be overridden by the implementing classes
        return false;
    },

    /**
     * <p>This method must calculate the handle id for the specified coordinates.</p>
     * <p><i>This method must not change the handleId property!</i></p>
     * @param {Object} coords coordinates to calculate handle ID for; properties: x, y
     * @return {Object} handle id (implementation specific) or null if no handle is at that
     *         coordinates
     */
    calculateHandleId: function(coords) {
        // this method must be overriden by the implementing class
        return null;
    },

    /**
     * <p>This method must calculate the dragging reference and must be overridden by each
     * implementation of {@link CQ.form.ImageMap.Area}.</p>
     * <p>The implementing class must set the dragging reference coordinates for the current
     * value of the pointToMove property. The way the dragging reference is calculated is
     * implementation-specific and must suit the way coordinate calculation is done
     * by the specific {@link #moveShapeBy} implementation.</p>
     */
    calculateDraggingReference: function() {
        // must be overriden by implementing classes
    },

    /**
     * <p>This method must be implemented to rotate the area by the specified angle.</p>
     * <p>Currently, only multiples of 90 must be supported.</p>
     * @param {Number} angle The angle (degrees; clockwise) the area has to be rotated by
     * @param {Number} absAngle The absolute angle (degrees) the area has to be rotated to
     * @param {Object} imageSize size of image (original, unrotated); properties: width,
     *        height
     */
    rotateBy: function(angle, absAngle, imageSize) {
        // must be overridden by implementing class
    },

    // Drawing helpers ---------------------------------------------------------------------

    /**
     * Get the color that has to be used for drawing the area itself, according to the
     * current area state.
     * @return {String} The color to be used for the drawing of the area; todo format?
     */
    getColor: function() {
        var color = this.basicShapeColor;
        if (this.isSelected) {
            color = this.selectedColor;
        } else if (this.isRollOver) {
            color = this.rolloverColor;
        }
        return color;
    },

    /**
     * <p>Draws a handle for the specified point.</p>
     * <p><i>To avoid unnecessary calculations, this method takes display coordinates, not
     * unzoomed coordinates!</i></p>
     * @param {Number} x The horizontal position of the point for which the handle has to be
     *        drawn
     * @param {Number} y The vertical position of the point for which the handle has to be
     *        drawn
     * @param {Boolean} isRolledOver True if the handle has to be drawn in "rollover" state
     * @param {Boolean} isSelected True if the handle has to be drawn in "selected" state
     * @param {CanvasRenderingContext2D} ctx canvas context on which to draw
     */
    drawHandle: function(x, y, isRolledOver, isSelected, ctx) {
        var baseX = x - this.handleSize;
        var baseY = y - this.handleSize;
        var extension = this.handleSize * 2;
        ctx.lineWidth = 1;
        ctx.strokeStyle = this.shadowColor;
        ctx.strokeRect(baseX + 1, baseY + 1, extension, extension);
        if (isSelected) {
            ctx.strokeStyle = this.handleSelectedColor;
        } else if (isRolledOver) {
            ctx.strokeStyle = this.handleRolloverColor;
        } else {
            ctx.strokeStyle = this.handleColor;
        }
        ctx.strokeRect(baseX, baseY, extension, extension);
    }

});


/**
 * @class CQ.form.ImageMap.RectArea
 * @extends CQ.form.ImageMap.Area
 * @private
 * This class represents a rectangular area of the image map.
 * @constructor
 * Creates a new ImageMap.RectArea.
 * @param {Number} top top edge of image area (incl.)
 * @param {Number} left left edge of image area (incl.)
 * @param {Number} bottom bottom edge of image area (incl.)
 * @param {Number} right right edge of image area (incl.)
 */
CQ.form.ImageMap.RectArea = CQ.Ext.extend(CQ.form.ImageMap.Area, {

    constructor: function(config, top, left, bottom, right) {
        CQ.form.ImageMap.RectArea.superclass.constructor.call(this,
                CQ.form.ImageMap.AREATYPE_RECT, config);
        this.top = top;
        this.left = left;
        this.bottom = bottom;
        this.right = right;
    },

    /**
     * <p>Checks if the specified coordinates "belong" to the image area.</p>
     * <p>Currently, the borders of the rectangular area are checked for this.</p>
     * @param {Object} coords Coordinates to check; properties: x, y
     * @param {Number} tolerance The tolerance distance to be considered
     * @return {Boolean} True if the specified coordinates "belong" to the image area
     */
    isTouched: function(coords, tolerance) {
        var handleId = this.calculateHandleId(coords);
        if (handleId != null) {
            return true;
        }
        coords = coords.unzoomedUnclipped;
        // check top border
        var top1 = this.top - tolerance;
        var top2 = this.top + tolerance;
        if ((coords.y >= top1) && (coords.y <= top2)) {
            if ((coords.x >= this.left) && (coords.x <= this.right)) {
                return true;
            }
        }
        // check bottom border
        var bottom1 = this.bottom - tolerance;
        var bottom2 = this.bottom + tolerance;
        if ((coords.y >= bottom1) && (coords.y <= bottom2)) {
            if ((coords.x >= this.left) && (coords.x <= this.right)) {
                return true;
            }
        }
        // check left border
        var left1 = this.left - tolerance;
        var left2 = this.left + tolerance;
        if ((coords.x >= left1) && (coords.x <= left2)) {
            if ((coords.y >= this.top) && (coords.y <= this.bottom)) {
                return true;
            }
        }
        // check right border
        var right1 = this.right - tolerance;
        var right2 = this.right + tolerance;
        if ((coords.x >= right1) && (coords.x <= right2)) {
            if ((coords.y >= this.top) && (coords.y <= this.bottom)) {
                return true;
            }
        }
        return false;
    },

    /**
     * Calulates a suitable dragging reference.
     */
    calculateDraggingReference: function() {
        if ((this.pointToMove == "topleft") || (this.pointToMove == null)) {
            this.draggingReference = {
                "x": this.left,
                "y": this.top
            };
        } else if (this.pointToMove == "topright") {
            this.draggingReference = {
                "x": this.right,
                "y": this.top
            };
        } else if (this.pointToMove == "bottomleft") {
            this.draggingReference = {
                "x": this.left,
                "y": this.bottom
            };
        } else if (this.pointToMove == "bottomright") {
            this.draggingReference = {
                "x": this.right,
                "y": this.bottom
            };
        }
    },

    /**
     * Moves the shape or the point by the specified offsets.
     * @param {Number} xOffs The horizontal offset
     * @param {Number} yOffs The vertical offset
     */
    moveShapeBy: function(xOffs, yOffs, coords) {
        var imageSize = coords.unzoomed.rotatedImageSize;
        var destCoords =
                this.calculateDestCoords(xOffs, yOffs, this.draggingReference, imageSize);
        if (this.pointToMove == null) {
            var width = this.right - this.left;
            this.left = destCoords.x;
            this.right = this.left + width;
            var height = this.bottom - this.top;
            this.top = destCoords.y;
            this.bottom = this.top + height;
            if (this.right >= imageSize.width) {
                var delta = this.right - imageSize.width + 1;
                this.left -= delta;
                this.right -= delta;
            }
            if (this.bottom >= imageSize.height) {
                delta = this.bottom - imageSize.height + 1;
                this.top -= delta;
                this.bottom -= delta;
            }
        } else if (this.pointToMove == "topleft") {
            this.left = destCoords.x;
            this.top = destCoords.y;
        } else if (this.pointToMove == "topright") {
            this.right = destCoords.x;
            this.top = destCoords.y;
        } else if (this.pointToMove == "bottomleft") {
            this.left = destCoords.x;
            this.bottom = destCoords.y;
        } else if (this.pointToMove == "bottomright") {
            this.right = destCoords.x;
            this.bottom = destCoords.y;
        }
        return true;
    },

    /**
     * Ensures the correct coordinates (left may become right and top may become button
     * through the dragging operation).
     */
    onDragEnd: function() {
        var swap;
        if (this.top > this.bottom) {
            swap = this.top;
            this.top = this.bottom;
            this.bottom = swap;
        }
        if (this.left > this.right) {
            swap = this.left;
            this.left = this.right;
            this.right = swap;
        }
    },

    /**
     * Calculates the handle id for the specified coordinates.
     * @param {Object} coords The coordinates to calculate the handle ID for
     */
    calculateHandleId: function(coords) {
        if (this.isPartOfHandle(this.left, this.top, coords)) {
            return "topleft";
        }
        if (this.isPartOfHandle(this.right, this.top, coords)) {
            return "topright";
        }
        if (this.isPartOfHandle(this.left, this.bottom, coords)) {
            return "bottomleft";
        }
        if (this.isPartOfHandle(this.right, this.bottom, coords)) {
            return "bottomright";
        }
        return null;
    },

    /**
     * Checks if the area is correct (width and height are &lt; 0).
     * @return {Boolean} True if the area is correct
     */
    isValid: function() {
        return (this.top != this.bottom) && (this.left != this.right);
    },

    /**
     * <p>Rotates the area by the specified angle.</p>
     * <p>Currently, only multiples of 90 (degrees) are supported.</p>
     * @param {Number} angle The angle (degrees; clockwise) the area has to be rotated by
     * @param {Number} absAngle The absolute angle (degrees) the area has to be rotated to
     * @param {Object} imageSize The size of the image (original, unrotated; properties:
     *        width, height)
     */
    rotateBy: function(angle, absAngle, imageSize) {
        var tempTop;
        var tempBottom;
        // calculate basic angle
        var basicAngle = this.calcBasicAngle(angle, absAngle);
        var margin = ((basicAngle == 90) || (basicAngle == 270)
                ? imageSize.width : imageSize.height);
        // rotate in 90 degree steps
        var steps = Math.round(angle / 90);
        for (var step = 0; step < steps; step++) {
            tempTop = this.top;
            tempBottom = this.bottom;
            this.top = this.left;
            this.bottom = this.right;
            this.right = margin - tempTop;
            this.left = margin - tempBottom;
        }
    },

    /**
     * Sets the correct handle for dragging the rectangle after adding it.
     * @param {Object} coords Coordinates (properties: x, y)
     */
    onAddForDrag: function(coords) {
        this.handleId = "bottomright";
    },

    /**
     * Redraws the rectangular image area on the specified canvas context.
     * @param {CanvasRenderingContext2D} ctx The context to be used for drawing
     * @param {Number} zoom The real zoom factor (1.0 means that the original size should be
     *        used)
     * @param {Object} offsets Drawing offsets; properties: srcX, srcY, destX, destY,
     *        imageSize, zoomedSize; (see {@link CQ.form.SmartImage.Shape#draw})
     */
    draw: function(ctx, zoom, offsets) {
        CQ.Log.debug("CQ.form.ImageMap.RectArea#draw: Started.");
        // reduce drawing to a minimum if IE is used and dragging is done
        var width = this.right - this.left;
        var height = this.bottom - this.top;
        var rectLeft = this.left;
        var rectTop = this.top;
        if (width < 0) {
            width = -width;
            rectLeft = this.right;
        } else if (width == 0) {
            width = 1;
        }
        if (height < 0) {
            height = -height;
            rectTop = this.bottom;
        } else if (height == 0) {
            height = 1;
        }
        var coords = this.calculateDisplayCoords(zoom, offsets, rectLeft, rectTop);
        var size = this.calculateDisplaySize(zoom, width, height);
        var coords2 = {
            "x": coords.x + size.width,
            "y": coords.y + size.height
        };
        if (this.fillColor) {
            ctx.fillStyle = this.fillColor;
            ctx.fillRect(coords.x, coords.y, size.width, size.height);
        }
        var drawHandle = (this.isRollOver);
        if (drawHandle) {
            this.drawHandle(coords.x, coords.y,
                    (this.handleId == "topleft"), false, ctx);
            this.drawHandle(coords2.x, coords.y,
                    (this.handleId == "topright"), false, ctx);
            this.drawHandle(coords.x, coords2.y,
                    (this.handleId == "bottomleft"), false, ctx);
            this.drawHandle(coords2.x, coords2.y,
                    (this.handleId == "bottomright"), false, ctx);
        }
        ctx.strokeStyle = this.getColor();
        ctx.lineWidth = 1;
        ctx.strokeRect(coords.x, coords.y, size.width,  size.height);
        CQ.Log.debug("CQ.form.ImageMap.RectArea#draw: Finished.");
    },

    /**
     * Creates a String representation of the area.
     * @return {String} The String representation of the area
     */
    serialize: function() {
        return "rect("+ this.left + "," + this.top + "," + this.right + ","
                + this.bottom + ")" + this.destination.serialize();
    },

    /**
     * Creates a String representation of the area's coordinates (may be edited by user).
     * @return {String} The String representation of the area's coordinates
     */
    toCoordString: function() {
        return "(" + this.left + "/" + this.top + ") (" + this.right + "/" + this.bottom
                + ")";
    },

    /**
     * <p>Sets the rectangle according to the specified coordinate string representation.
     * </p>
     * <p>Note that the area must be repainted to reflect the changes visually.</p>
     * @param {String} coordStr coordinates string
     * @return {Boolean} True if the area could be adapted to the string; false if the
     *         string could not be parsed
     */
    fromCoordString: function(coordStr) {
        var coordDef = CQ.form.ImageMap.Helpers.parseCoordinateString(coordStr);
        if (coordDef == null) {
            return false;
        }
        var coords = coordDef.coordinates;
        if ((coords.length != 2) || (coordDef.coordinatesPairCnt != 2)) {
            return false;
        }
        var x1 = coords[0].x;
        var y1 = coords[0].y;
        var x2 = coords[1].x;
        var y2 = coords[1].y;
        if (x1 == x2) {
            return false;
        }
        if (y1 == y2) {
            return false;
        }
        // todo implement more validation code?
        if (x1 < x2) {
            this.left = x1;
            this.right = x2;
        } else {
            this.left = x2;
            this.right = x1;
        }
        if (y1 < y2) {
            this.top = y1;
            this.bottom = y2;
        } else {
            this.top = y2;
            this.bottom = y1;
        }
        return true;
    }

});

/**
 * <p>Checks if the specified string contains the definition of a polygonal area.</p>
 * <p>This method only checks for basic compliance with the formatting rules. Further format
 * checking will be done in {@link #deserialize()}.</p>
 * @static
 * @param {String} strToCheck The string to be checked
 * @return {Boolean} True if the specified string contains the definition of a polygonal
 *         area
 */
CQ.form.ImageMap.RectArea.isStringRepresentation = function(strToCheck) {
    var strLen = strToCheck.length;
    if (strLen < 13) {
        return false;
    }
    var contentStartPos = strToCheck.indexOf("(");
    if (contentStartPos <= 0) {
        return false;
    }
    var prefix = strToCheck.substring(0, contentStartPos);
    if (prefix != "rect") {
        return false;
    }
    if (!strToCheck.charAt(strLen) == ')') {
        return false;
    }
    return true;
};

/**
 * <p>Parses the specified string representation and creates a suitable
 * {@link CQ.form.ImageMap.RectArea} object accordingly.</p>
 * <p>The String representation should have been checked beforehand using
 * {@link #isStringRepresentation}.</p>
 * @static
 * @param {String} stringDefinition the String representation of the rectangular area (as
 *        created by {@link #serialize})
 * @return {CQ.form.ImageMap.RectArea} The rectangular area created; null, if the
 *         string definition is not correct
 */
CQ.form.ImageMap.RectArea.deserialize = function(stringDefinition) {
    var defStartPos = stringDefinition.indexOf("(");
    if (defStartPos < 0) {
        return null;
    }
    var defEndPos = stringDefinition.indexOf(")", defStartPos + 1);
    if (defEndPos < 0) {
        return null;
    }
    var def = stringDefinition.substring(defStartPos + 1, defEndPos);
    var coordIndex;
    var coords = def.split(",");
    if (coords.length != 4) {
        return null;
    }
    var preparsedCoords = new Array();
    var coordCnt = coords.length;
    for (coordIndex = 0; coordIndex < coordCnt; coordIndex++) {
        var coord = parseInt(coords[coordIndex]);
        if (isNaN(coord)) {
            return null;
        }
        preparsedCoords[coordIndex] = coord;
    }
    return new CQ.form.ImageMap.RectArea({ },
            preparsedCoords[1], preparsedCoords[0], preparsedCoords[3], preparsedCoords[2]);
};


/**
 * @class CQ.form.ImageMap.CircularArea
 * @extends CQ.form.ImageMap.Area
 * @private
 * This class represents a circular area of the image map.
 * @constructor
 * <p>Creates a new ImageMap.CircularArea.</p>
 * <p>The center point of the circle must already be defined.</p>
 * @param {Object} config The config object
 * @param {Number} x horizontal coordinate of center point
 * @param {Number} y vertical coordinate of center point
 * @param {Number} radius initial radius of circle; use 1 for a new circle
 */
CQ.form.ImageMap.CircularArea = CQ.Ext.extend(CQ.form.ImageMap.Area, {

    constructor: function(config, x, y, radius) {
        CQ.form.ImageMap.RectArea.superclass.constructor.call(this,
                CQ.form.ImageMap.AREATYPE_CIRCLE, config);
        this.x = x;
        this.y = y;
        this.radius = radius;
        this.handlePosition = {
            "x": x + radius,
            "y": y
        };
    },

    /**
     * Checks if the specified coordinates "belong" to the image area.
     * @param {Object} coords Coordinates to check; properties: x, y
     * @param {Number} tolerance The tolerance distance to be considered
     * @return {Boolean} True if the specified coordinates "belong" to the image area
     */
    isTouched: function(coords, tolerance) {
        var handleId = this.calculateHandleId(coords);
        if (handleId != null) {
            return true;
        }
        coords = coords.unzoomedUnclipped;
        var distance = CQ.form.ImageMap.Helpers.calculateDistanceToCircle(this, coords);
        return (distance <= tolerance);
    },

    /**
     * Calulates a suitable dragging reference.
     */
    calculateDraggingReference: function() {
        if (this.pointToMove == null) {
            this.draggingReference = {
                "x": this.x,
                "y": this.y
            };
        } else  {
            this.draggingReference = {
                "x": this.pointToMove.x,
                "y": this.pointToMove.y
            };
        }
    },

    /**
     * Moves the shape or the point by the specified offsets.
     * @param {Number} xOffs The horizontal offset
     * @param {Number} yOffs The vertical offset
     * @param {Object} coords Coordinates; properties: x, y
     * @return {Boolean} True if the shape has to be redrawn
     */
    moveShapeBy: function(xOffs, yOffs, coords) {
        var imgSize = coords.unzoomed.rotatedImageSize;
        var destCoords =
                this.calculateDestCoords(xOffs, yOffs, this.draggingReference, imgSize);
        if (this.pointToMove == null) {
            var handleDeltaX = this.handlePosition.x - this.x;
            var handleDeltaY = this.handlePosition.y - this.y;
            this.x = destCoords.x;
            this.y = destCoords.y;
            if (this.x < this.radius) {
                this.x = this.radius;
            }
            if (this.y < this.radius) {
                this.y = this.radius;
            }
            if (this.x >= (imgSize.width - this.radius)) {
                this.x = imgSize.width - this.radius - 1;
            }
            if (this.y >= (imgSize.height - this.radius)) {
                this.y = imgSize.height - this.radius - 1;
            }
            this.handlePosition.x = this.x + handleDeltaX;
            this.handlePosition.y = this.y + handleDeltaY;
        } else {
            this.pointToMove.x = destCoords.x;
            this.pointToMove.y = destCoords.y;
            var xDelta = this.pointToMove.x - this.x;
            var yDelta = this.pointToMove.y - this.y;
            this.radius = Math.sqrt((xDelta * xDelta) + (yDelta * yDelta));
            var angle = null;
            if (xDelta != 0) {
                angle = Math.atan(yDelta / xDelta);
            }
            var isCorrected = false;
            if ((this.x - this.radius) < 0) {
                this.radius = this.x;
                isCorrected = true;
            }
            if ((this.x + this.radius) >= imgSize.width) {
                this.radius = imgSize.width - this.x - 1;
                isCorrected = true;
            }
            if ((this.y - this.radius) < 0) {
                this.radius = this.y;
                isCorrected = true;
            }
            if ((this.y + this.radius) >= imgSize.height) {
                this.radius = imgSize.height - this.y - 1;
                isCorrected = true;
            }
            if (isCorrected) {
                if (angle != null) {
                    var correctX = this.radius * Math.cos(angle);
                    var correctY = this.radius * Math.sin(angle);
                    if (xDelta < 0) {
                        correctX = -correctX;
                        correctY = -correctY;
                    }
                    this.pointToMove.x = this.x + correctX;
                    this.pointToMove.y = this.y + correctY;
                } else {
                    this.pointToMove.x = this.x;
                    if (yDelta < 0) {
                        this.pointToMove.y = this.y - this.radius;
                    } else {
                        this.pointToMove.y = this.y + this.radius;
                    }
                }
            }
        }
        return true;
    },

    /**
     * Calculates a "handle id" for the specified coordinates.
     * @param {Object} coords Coordinates; properties: x, y
     * @return {Object} A suitable handle ID for correct highlightning
     */
    calculateHandleId: function(coords) {
        if (this.isPartOfHandle(this.handlePosition.x, this.handlePosition.y, coords)) {
            return this.handlePosition;
        }
        return null;
    },

    /**
     * Checks if the area is correct (width and height are &lt; 0).
     * @return {Boolean} True if the area is correct
     */
    isValid: function() {
        return (this.radius > 0);
    },

    /**
     * <p>Rotates the area by the specified angle.</p>
     * <p>Currently, only multiples of 90 (degrees) are supported.</p>
     * @param {Number} angle The angle (degrees; clockwise) the area has to be rotated by
     * @param {Number} absAngle The absolute angle (degrees) the area has to be rotated to
     * @param {Object} imageSize The size of the image (original, unrotated); properties:
     *        width, height
     */
    rotateBy: function(angle, absAngle, imageSize) {
        // calculate basic angle
        var basicAngle = this.calcBasicAngle(angle, absAngle);
        var margin = ((basicAngle == 90) || (basicAngle == 270)
                ? imageSize.width : imageSize.height);
        // rotate in 90 degree steps
        var steps = Math.round(angle / 90);
        var tempX;
        for (var step = 0; step < steps; step++) {
            tempX = this.x;
            this.x = margin - this.y;
            this.y = tempX;
            tempX = this.handlePosition.x;
            this.handlePosition.x = margin - this.handlePosition.y;
            this.handlePosition.y = tempX;
        }
    },

    /**
     * Sets the correct handle for dragging the circle after adding it.
     * @param {Object} coords Coordinates; properties: x, y
     */
    onAddForDrag: function(coords) {
        this.handleId = this.handlePosition;
    },

    /**
     * Draws the circular area.
     * @param {CanvasRenderingContext2D} ctx The canvas context to be used for drawing
     * @param {Number} zoom Real zoom factor (1.0 means that the original size should be
     *        used)
     * @param {Object} offsets Drawing offsets; properties: srcX, srcY, destX, destY,
     *        imageSize, zoomedSize (see {@link CQ.form.SmartImage.Shape#draw})
     */
    draw: function(ctx, zoom, offsets) {
        CQ.Log.debug("CQ.form.ImageMap.CircularArea#paint: Started.");
        var coords = this.calculateDisplayCoords(zoom, offsets, this.x, this.y);
        var displayRadius = this.calculateDisplaySize(zoom, this.radius, 0).width;
        // fill
        if (this.fillColor) {
            ctx.fillStyle = this.fillColor;
            ctx.beginPath();
            ctx.arc(coords.x, coords.y, displayRadius, 0, 2 * Math.PI, false);
            ctx.closePath();
            ctx.fill();
        }
        // stroke
        ctx.lineWidth = 1.0;
        ctx.strokeStyle = this.getColor();
        ctx.beginPath();
        ctx.arc(coords.x, coords.y, displayRadius, 0, 2 * Math.PI, false);
        ctx.closePath();
        ctx.stroke();
        // handle
        var drawHandle = (this.isRollOver);
        if (drawHandle) {
            var isHandleSelected = (this.handleId != null);
            var handleCoords =
                    this.calculateDisplayCoords(zoom, offsets, this.handlePosition);
            this.drawHandle(
                    handleCoords.x, handleCoords.y, isHandleSelected, false, ctx);
        }
        CQ.Log.debug("CQ.form.ImageMap.CircularArea#paint: Finished.");
    },

    /**
     * Creates a text representation of the area.
     * @return {String} The text representation of the area
     */
    serialize: function() {
        return "circle(" + this.x + "," + this.y + "," + Math.round(this.radius) + ")"
                + this.destination.serialize();
    },

    /**
     * Creates a String representation of the area's coordinates (may be edited by user).
     * @return {String} The String representation of the area's coordinates
     */
    toCoordString: function() {
        return "(" + this.x + "/" + this.y + ") r:" + Math.round(this.radius);
    },

    /**
     * <p>Sets the circular area according to the specified coordinate String
     * representation.</p>
     * <p>The area must be repainted to reflect the changes visually.</p>
     * @param {String} coordStr The string representing the coordinates
     * @return {Boolean} True if the area could be adapted to the string; false if the
     *         string could not be parsed
     */
    fromCoordString: function(coordStr) {
        var coordDef = CQ.form.ImageMap.Helpers.parseCoordinateString(coordStr);
        if (coordDef == null) {
            return false;
        }
        var coords = coordDef.coordinates;
        if ((coords.length != 2) || (coordDef.coordinatesPairCnt != 1)) {
            return false;
        }
        var radius, x, y;
        if (coords[0].radius) {
            radius = coords[0].radius;
            x = coords[1].x;
            y = coords[1].y;
        } else {
            radius = coords[1].radius;
            x = coords[0].x;
            y = coords[0].y;
        }
        // todo implement more validation code?
        var newX, newY;
        var deltaX = this.handlePosition.x - this.x;
        var deltaY = this.handlePosition.y - this.y;
        if (deltaX != 0) {
            var angle = Math.atan(deltaY / deltaX);
            newX = Math.cos(angle) * radius;
            newY = Math.sin(angle) * radius;
            if (deltaX < 0) {
                newX = -newX;
                newY = -newY;
            }
            this.handlePosition.x = newX + x;
            this.handlePosition.y = newY + y;
        } else {
            this.handlePosition.x = x;
            newY = (this.handlePosition.y < this.y ? -radius : radius);
            this.handlePosition.y = newY + y;
        }
        this.x = x;
        this.y = y;
        this.radius = radius;
        return true;
    }

});

/**
 * <p>Checks if the specified string contains the definition of a circular area.</p>
 * <p>This method only checks for basic compliance with the formatting rules. Further format
 * checking will be done in {@link #deserialize}.</p>
 * @static
 * @param {String} strToCheck The string to check
 * @return {Boolean} True if the specified string contains the definition of a circular
 *         area
 */
CQ.form.ImageMap.CircularArea.isStringRepresentation = function(strToCheck) {
    var strLen = strToCheck.length;
    if (strLen < 13) {
        return false;
    }
    var contentStartPos = strToCheck.indexOf("(");
    if (contentStartPos <= 0) {
        return false;
    }
    var prefix = strToCheck.substring(0, contentStartPos);
    if (prefix != "circle") {
        return false;
    }
    if (!strToCheck.charAt(strLen) == ')') {
        return false;
    }
    return true;
};

/**
 * <p>Parses the specified string representation and creates a suitable
 * {@link CQ.form.ImageMap.CircularArea} object accordingly.</p>
 * <p>The specified string representation should have been checked beforehand using
 * {@link #isStringRepresentation}.</p>
 * @static
 * @param {String} stringDefinition The String representation of the polygonal area (as
 *        created by {@link #serialize})
 * @return {CQ.form.ImageMap.CircularArea} The image map created; null, if the string
 *         definition is not correct
 */
CQ.form.ImageMap.CircularArea.deserialize = function(stringDefinition) {
    var defStartPos = stringDefinition.indexOf("(");
    if (defStartPos < 0) {
        return null;
    }
    var defEndPos = stringDefinition.indexOf(")", defStartPos + 1);
    if (defEndPos < 0) {
        return null;
    }
    var def = stringDefinition.substring(defStartPos + 1, defEndPos);
    var coordIndex;
    var coords = def.split(",");
    if (coords.length != 3) {
        return null;
    }
    var preparsedCoords = new Array();
    var coordCnt = coords.length;
    for (coordIndex = 0; coordIndex < coordCnt; coordIndex++) {
        var coord = parseInt(coords[coordIndex]);
        if (isNaN(coord)) {
            return null;
        }
        preparsedCoords[coordIndex] = coord;
    }
    return new CQ.form.ImageMap.CircularArea({ },
            preparsedCoords[0], preparsedCoords[1], preparsedCoords[2]);
};


/**
 * @class CQ.form.ImageMap.PolyArea
 * @extends CQ.form.ImageMap.Area
 * @private
 * This class represents a polygonal area of the image map.
 * @constructor
 * Creates a new ImageMap.PolyArea.
 * @param {Object} config The config object
 * @param {Number} x1 horizontal coordinate of first polygon point
 * @param {Number} y1 vertical coordinate of first polygon point
 */
CQ.form.ImageMap.PolyArea = CQ.Ext.extend(CQ.form.ImageMap.Area, {

    constructor: function(config, x1, y1) {
        CQ.form.ImageMap.RectArea.superclass.constructor.call(this,
                CQ.form.ImageMap.AREATYPE_POLYGON, config);
        this.areaType = CQ.form.ImageMap.AREATYPE_POLYGON;
        this.destination = new CQ.form.ImageMap.AreaDestination();
        this.points = new Array();
        this.points.push({
            "x": x1,
            "y": y1
        });
    },

    /**
     * Adds a new point to the polygon.
     * @param {Number} x The horizontal coordinate of point to add
     * @param {Number} y The vertical coordinate of point to add
     * @return {Object} The object representing the newly created point; properties: x, y
     */
    addPoint: function(x, y) {
        var thePoint = {
            "x": x,
            "y": y
        };
        this.points.push(thePoint);
        return thePoint;
    },

    /**
     * <p>Inserts a new point on an existing line of the polygon.</p>
     * <p>The method determines the correct insertion point, using the specified tolerance
     * distance. If the specified point is not near an existing line, the method will
     * return null.</p>
     * @param {Number} x The horizontal coordinate of the point to insert
     * @param {Number} y The vertical coordinate of the point to insert
     * @param {Number} tolerance The tolerance distance
     * @return {Object} The object representing the newly created point; null if wrong
     *         coordinates were specified
     */
    insertPoint: function(x, y, tolerance) {
        var pointToAdd = {
            "x": x,
            "y": y
        };
        var pointCnt = this.points.length;
        var insertIndex = this.calculatePointInsertIndex(x, y, tolerance);
        if (insertIndex < 0) {
            return null;
        }
        if (insertIndex < pointCnt) {
            for (var copyIndex = pointCnt; copyIndex > insertIndex; copyIndex--) {
                this.points[copyIndex] = this.points[copyIndex - 1];
            }
        }
        this.points[insertIndex] = pointToAdd;
        return pointToAdd;
    },

    /**
     * <p>Removes the specified point from the polygon.</p>
     * <p>The point to remove is determined by object identity first, then by comparing
     * coordinates.</p>
     * <p>A redraw must be issued explicitly to actually remove the point from screen.
     * </p>
     * @param {Object} pointToRemove The point to be removed (properties: x, y)
     */
    removePoint: function(pointToRemove) {
        var pointCnt = this.points.length;
        var isRemoved = false;
        var checkIndex, pointToCheck;
        for (checkIndex = 0; checkIndex < pointCnt; checkIndex++) {
            pointToCheck = this.points[checkIndex];
            if (pointToCheck == pointToRemove) {
                this.points[checkIndex] = null;
                if (this.handleId == pointToCheck) {
                    this.handleId = null;
                }
                if (this.selectedHandle == pointToCheck) {
                    this.selectedHandle = null;
                }
                isRemoved = true;
                break;
            }
        }
        if (!isRemoved) {
            for (checkIndex = 0; checkIndex < pointCnt; checkIndex++) {
                pointToCheck = this.points[checkIndex];
                if ((pointToCheck.x == pointToRemove.x)
                        && (pointToCheck.y == pointToRemove.y)) {
                    this.points[checkIndex] = null;
                    if (this.handleId == pointToCheck) {
                        this.handleId = null;
                    }
                    if (this.selectedHandle == pointToCheck) {
                        this.selectedHandle = null;
                    }
                    break;
                }
            }
        }
        CQ.form.ImageMap.Helpers.compactArray(this.points);
    },

    /**
     * Checks if the specified coordinates are "on" a line between two specified points.
     * @param {Object} coordsToCheck Coordinates to check; properties: x, y
     * @param {Object} lineStart Line's start position; properties: x, y
     * @param {Object} lineEnd Line's end position; properties: x, y
     * @param {Number} tolerance The tolerance distance
     * @return {Boolean} True if the specified coordinate is on (or nearby) the specified
     *         line
     */
    isOnLine: function(coordsToCheck, lineStart, lineEnd, tolerance) {
        var distance = CQ.form.ImageMap.Helpers.calculateDistance(
                lineStart, lineEnd, coordsToCheck);
        return (distance <= tolerance);
    },

    /**
     * Calculates a "bounding rectangle" for the polygonal area.
     * @return {Object} Object with properties top, left, bottom and right; null if no
     *         points are defined (should not happen, as the polygon area would be invalid
     *         then and hence automatically removed)
     */
    calcBoundingRect: function() {
        if (this.points.length == 0) {
            return null;
        }
        var minX = this.points[0].x;
        var minY = this.points[0].y;
        var maxX = minX;
        var maxY = minY;
        var pointCnt = this.points.length;
        for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
            var pointToCheck = this.points[pointIndex];
            if (pointToCheck.x < minX) {
                minX = pointToCheck.x;
            } else if (pointToCheck.x > maxX) {
                maxX = pointToCheck.x;
            }
            if (pointToCheck.y < minY) {
                minY = pointToCheck.y;
            } else if (pointToCheck.y > maxY) {
                maxY = pointToCheck.y;
            }
        }
        var boundingRect = new Object();
        boundingRect.top = minY;
        boundingRect.left = minX;
        boundingRect.bottom = maxY;
        boundingRect.right = maxX;
        return boundingRect;
    },

    /**
     * <p>Calculates the insert index for the specified coordinates.</p>
     * <p>This is used to determine where a new polygon point must be inserted in the list
     * of existing polygon points.</p>
     * @param {Number} x horizontal coordinate
     * @param {Number} y vertical coordinate
     * @return {Number} The array index where the point has to be inserted; -1 if the
     *         coordinates are invalid
     */
    calculatePointInsertIndex: function(x, y, tolerance) {
        var pointCnt = this.points.length;
        if (pointCnt == 1) {
            return 1;
        }
        var coordsToCheck = new Object();
        coordsToCheck.x = x;
        coordsToCheck.y = y;
        for (var pointIndex = 1; pointIndex < pointCnt; pointIndex++) {
            var p1 = this.points[pointIndex - 1];
            var p2 = this.points[pointIndex];
            if (this.isOnLine(coordsToCheck, p1, p2, tolerance)) {
                return pointIndex;
            }
        }
        var isOnLine = this.isOnLine(coordsToCheck,
                this.points[0], this.points[pointCnt - 1], tolerance);
        if (isOnLine) {
            return pointCnt;
        }
        return -1;
    },

    /**
     * Cleans up the polygon by removing succeeding points using the same coordinates.
     */
    cleanUp: function() {
        var pointCnt = this.points.length;
        for (var pointIndex = 0; pointIndex < (pointCnt - 1); pointIndex++) {
            var p1 = this.points[pointIndex];
            var p2 = this.points[pointIndex + 1];
            if ((p1.x == p2.x) && (p1.y == p2.y)) {
                this.points[pointIndex] = null;
                CQ.Log.info("CQ.form.ImageMap.PolyArea#cleanUp: Polygon point with identical coordinates removed: " + p1.x + "/" + p1.y);
            }
        }
        CQ.form.ImageMap.Helpers.compactArray(this.points);
    },

    /**
     * <p>Checks if the specified coordinates "belong" to the image area.</p>
     * <p>Currently, the borders of the polygonal area are checked for this.</p>
     * @param {Object} coords Coordinates to check; properties: x, y
     * @param {Number} tolerance The tolerance distance to be considered
     * @return {Boolean} True if the specified coordinates "belong" to the image area
     */
    isTouched: function(coords, tolerance) {
        var handleId = this.calculateHandleId(coords);
        if (handleId != null) {
            return true;
        }
        var pointCnt = this.points.length;
        coords = coords.unzoomedUnclipped;
        // handle "one point polygons"
        if (pointCnt == 1) {
            var xDelta = Math.abs(this.points[0].x - coords.x);
            var yDelta = Math.abs(this.points[0].y - coords.y);
            return (xDelta < tolerance) && (yDelta < tolerance);
        } else {
            var isOnLine;
            for (var pointIndex = 1; pointIndex < pointCnt; pointIndex++) {
                var p1 = this.points[pointIndex - 1];
                var p2 = this.points[pointIndex];
                isOnLine = this.isOnLine(coords, p1, p2, tolerance);
                if (isOnLine) {
                    return true;
                }
            }
            return this.isOnLine(
                    coords, this.points[0], this.points[pointCnt - 1], tolerance);
        }
    },

    /**
     * Calulates a suitable dragging reference
     */
    calculateDraggingReference: function() {
        if (this.pointToMove == null) {
            var boundingRect = this.calcBoundingRect();
            this.draggingReference = {
                "x": boundingRect.left,
                "y": boundingRect.top,
                "width": boundingRect.right - boundingRect.left + 1,
                "height": boundingRect.bottom - boundingRect.top + 1
            };
        } else  {
            this.draggingReference = {
                "x": this.pointToMove.x,
                "y": this.pointToMove.y
            };
        }
    },

    /**
     * Moves the whole polygonal area by the specified offset.
     * @param {Number} xOffs The horizontal move offset
     * @param {Number} yOffs The vertical move offset
     * @param {Object} coords Coordinates (properties: x, y)
     */
    moveShapeBy: function(xOffs, yOffs, coords) {
        var imgSize = coords.unzoomed.rotatedImageSize;
        var destCoords =
                this.calculateDestCoords(xOffs, yOffs, this.draggingReference, imgSize);
        var destX = destCoords.x;
        var destY = destCoords.y;
        if (this.pointToMove == null) {
            var endX = destX + this.draggingReference.width;
            if (endX >= imgSize.width) {
                destX = imgSize.width - this.draggingReference.width;
            }
            var endY = destY + this.draggingReference.height;
            if (endY >= imgSize.height) {
                destY = imgSize.height - this.draggingReference.height;
            }
            var currentBounds = this.calcBoundingRect();
            var pointOffsX = destX - currentBounds.left;
            var pointOffsY = destY - currentBounds.top;
            var pointCnt = this.points.length;
            for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
                var pointToMove = this.points[pointIndex];
                pointToMove.x += pointOffsX;
                pointToMove.y += pointOffsY;
            }
        } else {
            this.pointToMove.x = destX;
            this.pointToMove.y = destY;
        }
        return true;
    },

    /**
     * Calculates a "handle id" for the specified coordinates.
     * @param {Number} x The horizontal position to check
     * @param {Number} y The vertical position to check
     * @return {String} A suitable handle ID for correct highlightning
     */
    calculateHandleId: function(x, y) {
        var pointCnt = this.points.length;
        for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
            var pointToCheck = this.points[pointIndex];
            if (this.isPartOfHandle(pointToCheck.x, pointToCheck.y, x, y)) {
                return pointToCheck;
            }
        }
        return null;
    },

    /**
     * Handles unSelect events for polygonal areas.
     */
    onUnSelect: function() {
        this.selectedHandle = null;
        CQ.form.ImageMap.PolyArea.superclass.onUnSelect.call(this);
        return true;
    },

    /**
     * Checks if the area is correct (at least one point is defined).
     * @return {Boolean} True if the area is correct
     */
    isValid: function() {
        return (this.points.length > 0);
    },

    /**
     * <p>Rotates the area by the specified angle.</p>
     * <p>Currently, only multiples of 90 (degrees) are supported.</p>
     * @param {Number} angle The angle (degrees; clockwise) the area has to be rotated by
     * @param {Number} absAngle The absolute angle (degrees) the area has to be rotated to
     * @param {Object} imageSize The size of the image (original, unrotated); properties:
     *                 width, height
     */
    rotateBy: function(angle, absAngle, imageSize) {
        // calculate basic angle
        var basicAngle = this.calcBasicAngle(angle, absAngle);
        var margin = ((basicAngle == 90) || (basicAngle == 270)
                ? imageSize.width : imageSize.height);
        // rotate in 90 degree steps
        var steps = Math.round(angle / 90);
        var tempX;
        for (var step = 0; step < steps; step++) {
            var pointCnt = this.points.length;
            for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
                var pointToRotate = this.points[pointIndex];
                tempX = pointToRotate.x;
                pointToRotate.x = margin - pointToRotate.y;
                pointToRotate.y = tempX;
            }
        }
    },

    /**
     * Sets the correct handle for dragging the initial polygon point after adding it.
     * @param {Object} coords Coordinates
     */
    onAddForDrag: function(coords) {
        this.handleId = this.points[0];
    },

    /**
     * Handles the start of a dragging operation for polygonal areas.
     */
    onDragStart: function() {
        this.selectedHandle = this.handleId;
        CQ.form.ImageMap.PolyArea.superclass.onDragStart.call(this);
        return true;
    },

    /**
     * Selects a polygon point by its index.
     * @param {Number} index The index of the polygon point to select; if an invalid index
     *        is specified, the current selection is removed
     */
    selectPointAt: function(index) {
        if ((index >= 0) && (index < this.points.length)) {
            this.selectedHandle = this.points[index];
        } else {
            this.selectedHandle = null;
        }
    },

    /**
     * Selects the specified polygon point.
     * @param {Object} point The polygon point to select; properties: x, y
     */
    selectPoint: function(point) {
        if (point == null) {
            this.selectedHandle = null;
        } else {
            var pointCnt = this.points.length;
            for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
                var pointToCheck = this.points[pointIndex];
                if ((pointToCheck.x == point.x) && (pointToCheck.y == point.y)) {
                    this.selectedHandle = pointToCheck;
                    return;
                }
            }
        }
    },

    /**
     * Draws the polygonal area.
     * @param {CanvasRenderingContext2D} ctx The canvas context to be used for drawing
     * @param {Number} zoom Real zoom factor (1.0 means that the original size should be
     *        used)
     * @param {Object} offsets Drawing offsets; properties: srcX, srcY, destX, destY,
     *        imageSize, zoomedSize (see {@link CQ.form.SmartImage.Shape#draw})
     */
    draw: function(ctx, zoom, offsets) {
        CQ.Log.debug("CQ.form.ImageMap.PolyArea#paint: Started.");
        // draw polygon
        var pointIndex, pointToProcess;
        var pointCnt = this.points.length;
        var origin = this.calculateDisplayCoords(zoom, offsets, this.points[0]);
        if (this.fillColor) {
            ctx.fillStyle = this.fillColor;
            ctx.beginPath();
            // fill
            ctx.moveTo(origin.x, origin.y);
            for (pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
                pointToProcess =
                        this.calculateDisplayCoords(zoom, offsets, this.points[pointIndex]);
                ctx.lineTo(pointToProcess.x, pointToProcess.y);
            }
            ctx.closePath();
            ctx.fill();
        }
        // stroke
        ctx.lineWidth = 1.0;
        ctx.strokeStyle = this.getColor();
        ctx.beginPath();
        ctx.moveTo(origin.x, origin.y);
        for (pointIndex = 1; pointIndex < pointCnt; pointIndex++) {
            pointToProcess =
                    this.calculateDisplayCoords(zoom, offsets, this.points[pointIndex]);
            ctx.lineTo(pointToProcess.x, pointToProcess.y);
        }
        ctx.closePath();
        ctx.stroke();
        // handles
        var drawHandle =
            this.isRollOver || (this.selectedHandle != null) || this.isSelected;
        var isOriginSelected = (this.selectedHandle == this.points[0]);
        var isOriginRolledOver = (this.handleId == this.points[0]);
        if (drawHandle || isOriginSelected) {
            this.drawHandle(origin.x, origin.y, isOriginRolledOver, isOriginSelected, ctx);
        }
        for (pointIndex = 1; pointIndex < pointCnt; pointIndex++) {
            pointToProcess =
                    this.calculateDisplayCoords(zoom, offsets, this.points[pointIndex]);
            var isSelected = (this.selectedHandle == this.points[pointIndex]);
            var isRolledOver = (this.handleId == this.points[pointIndex]);
            if (drawHandle || isSelected) {
                this.drawHandle(
                        pointToProcess.x, pointToProcess.y, isRolledOver, isSelected, ctx);
            }
        }
        CQ.Log.debug("CQ.form.ImageMap.PolyArea#paint: Finished.");
    },

    /**
     * Creates a String representation of the area.
     * @return {String} The String representation of the area
     */
    serialize: function() {
        var dump = "poly(";
        var pointCnt = this.points.length;
        for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
            if (pointIndex > 0) {
                dump += ",";
            }
            var pointToDump = this.points[pointIndex];
            dump += pointToDump.x + "," + pointToDump.y;
        }
        dump += ")";
        dump += this.destination.serialize();
        return dump;
    },

    /**
     * Creates a String representation of the area's coordinates (may be edited by user).
     * @return {String} String representation of the area's coordinates
     */
    toCoordString: function() {
        var coordStr = "";
        var pointCnt = this.points.length;
        for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
            if (pointIndex > 0) {
                coordStr += " ";
            }
            var pointToAdd = this.points[pointIndex];
            coordStr += "(" + pointToAdd.x + "/" + pointToAdd.y + ")";
        }
        return coordStr;
    },

    /**
     * <p>Sets the polygon points according to the specified coordinate String
     * representation.<p>
     * <p>The area must be repainted to reflect the changes visually.</p>
     * @param {String} coordStr coordinates The String representation
     * @return {Boolean} True if the area could be adapted to the string; false if the
     *         string could not be parsed
     */
    fromCoordString: function(coordStr) {
        var coordDef = CQ.form.ImageMap.Helpers.parseCoordinateString(coordStr);
        if (coordDef == null) {
            return false;
        }
        var coords = coordDef.coordinates;
        if ((coords.length < 2) || (coordDef.coordinatesPairCnt != coords.length)) {
            return false;
        }
        // todo implement validation code?
        this.points.length = 0;
        var pointCnt = coords.length;
        for (var pointIndex = 0; pointIndex < pointCnt; pointIndex++) {
            var pointCoord = coords[pointIndex];
            this.addPoint(pointCoord.x, pointCoord.y);
        }
        return true;
    }

});

/**
 * <p>Checks if the specified string contains the definition of a polygonal area.</p>
 * <p>This method only checks for basic compliance with the formatting rules. Further format
 * checking will be done in {@link #deserialize}.</p>
 * @static
 * @param {String} strToCheck The string to check
 * @return {Boolean} True if the specified string contains the definition of a polygonal
 *         area
 */
CQ.form.ImageMap.PolyArea.isStringRepresentation = function(strToCheck) {
    var strLen = strToCheck.length;
    if (strLen < 9) {
        return false;
    }
    var contentStartPos = strToCheck.indexOf("(");
    if (contentStartPos <= 0) {
        return false;
    }
    var prefix = strToCheck.substring(0, contentStartPos);
    if (prefix != "poly") {
        return false;
    }
    if (!strToCheck.charAt(strLen) == ')') {
        return false;
    }
    return true;
};

/**
 * <p>Parses the specified String representation and creates a suitable
 * {@link CQ.form.ImageMap.PolyArea} object accordingly.</p>
 * <p>The specified String representation should have been checked beforehand using
 * {@link #isStringRepresentation}.</p>
 * @static
 * @param {String} stringDefinition The String representation of the polygonal area (as
 *        created by {@link #serialize})
 * @return {CQ.form.ImageMap.PolyArea} The polygonal area created; null, if the
 *         string definition is not correct
 */
CQ.form.ImageMap.PolyArea.deserialize = function(stringDefinition) {
    var defStartPos = stringDefinition.indexOf("(");
    if (defStartPos < 0) {
        return null;
    }
    var defEndPos = stringDefinition.indexOf(")", defStartPos + 1);
    if (defEndPos < 0) {
        return null;
    }
    var def = stringDefinition.substring(defStartPos + 1, defEndPos);
    var pointDefs = def.split(",");
    var preparsedPoints = new Array();
    var pointIndex;
    var pointCnt = pointDefs.length;
    if ((pointCnt & 1) != 0) {
        return null;
    }
    for (pointIndex = 0; pointIndex < pointCnt; pointIndex += 2) {
        var x = parseInt(pointDefs[pointIndex]);
        var y = parseInt(pointDefs[pointIndex + 1]);
        if (isNaN(x)) {
            return null;
        }
        if (isNaN(y)) {
            return null;
        }
        preparsedPoints[pointIndex / 2] = { "x": x, "y": y };
    }
    pointCnt = preparsedPoints.length;
    var theArea = new CQ.form.ImageMap.PolyArea({ },
            preparsedPoints[0].x, preparsedPoints[0].y);
    for (pointIndex = 1; pointIndex < pointCnt; pointIndex++) {
        theArea.addPoint(preparsedPoints[pointIndex].x, preparsedPoints[pointIndex].y);
    }
    return theArea;
};
