package com.mcd.accessmcd.comments.util;

import java.util.List;
import java.util.ArrayList;
import java.util.StringTokenizer;
import java.util.Collections;

import javax.jcr.Node;
import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

import org.apache.sling.api.resource.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.text.Text;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager; 
import com.mcd.accessmcd.comments.constants.CommentsConstants;
import com.mcd.accessmcd.comments.util.CommentComparator;

public class NodeUtility
{
    private static final Logger log = LoggerFactory.getLogger(NodeUtility.class);
    private Node referredNode;
    private List<Node> nodeList;
    private Resource resource;
    String nodePath;

    public NodeUtility(Resource res)
    {
        try {
            if(res != null) {
                resource = res;
                if(res.getPath().startsWith(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)) && res.adaptTo(Node.class).isNodeType(CommentsConstants.COMMENT_NODE_TYPE)) {
                    referredNode = resource.adaptTo(Node.class);
                } else {
                    nodePath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH) + res.getPath().substring(0,res.getPath().indexOf(CommentsConstants.JCR_CONTENT_PATH)) + CommentsConstants.JCR_CONTENT_PATH + ((Node)res.adaptTo(Node.class)).getName();
                    Resource referredResource = res.getResourceResolver().getResource(nodePath); 
                    if(null != referredResource) {
                        resource = referredResource;
                        referredNode = resource.adaptTo(Node.class);
                    }
                    log.error("************** Referred Node Object ::::::::::::::::: " + referredNode);
                }
            }
        } catch(Exception ex) {
            log.error("Failed to create NodeUtility object - ", ex);
        }
    }

    public List<Node> getChildNodeList(Node node) throws Exception
    {
        try {
            if(nodeList == null) {
                nodeList = new ArrayList<Node>();
            }
            if(node.hasNodes()) {
                NodeIterator nodeIter = node.getNodes();
                while(nodeIter.hasNext()){
                    Node childNode = nodeIter.nextNode();
                    if(childNode.getName().equals("like")){
                    }else{
                    nodeList.add(childNode);
                    getChildNodeList(childNode);
                }}
            }
            Collections.sort(nodeList, new CommentComparator());
        } catch(Exception ex) {
            log.error("getChildNodeList Failed to get list - ", ex); 
        }
        return nodeList;
    }

    public List<Node> getReferredNodeList()
    {
        List<Node> referredNodeList = new ArrayList<Node>();
        try {
            if(referredNode.hasNodes()) {
                NodeIterator referredNodeIter = referredNode.getNodes();
                while(referredNodeIter.hasNext()){
                    referredNodeList.add(referredNodeIter.nextNode());
                }
            }
            Collections.sort(referredNodeList, new CommentComparator());  
        } catch(Exception ex) {
            log.error("getReferredNodeList Failed to get list - ", ex);
        }
        return referredNodeList;
    }

    public void createNodePath(String referer) throws Exception
    {
        //Resource commentRootResource = null;
        log.error("*************** Getting Resource Object ::::: " + resource);
        if(referredNode == null)
        {
            //commentRootResource = resource.getResourceResolver().getResource(nodePath); 
            String commentPagePath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH);
            //Node node = (Node)resource.getResourceResolver().getResource(commentPagePath).adaptTo(Node.class);
        
            String pagePath = nodePath.replace(commentPagePath,CommentsConstants.BLANK);
            pagePath = pagePath.substring(0,pagePath.indexOf(CommentsConstants.SLASH + CommentsConstants.JCR_CONTENT));
            StringTokenizer pathElements = new StringTokenizer(pagePath, CommentsConstants.SLASH);
            
            while(pathElements.hasMoreTokens())
            {
                commentPagePath = commentPagePath+CommentsConstants.SLASH+pathElements.nextToken();
                if(resource.getResourceResolver().getResource(commentPagePath) == null)
                {
                    if(commentPagePath.equals(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH) + CommentsConstants.SLASH + CommentsConstants.CONTENT))
                    {
                        try
                        {
                            Node root = ((Session)resource.getResourceResolver().adaptTo(Session.class)).getRootNode();
                            String commentNodePath = Text.getRelativeParent(commentPagePath, 1);
                            
                            for(StringTokenizer names = new StringTokenizer(commentNodePath, CommentsConstants.SLASH); names.hasMoreTokens();)
                            {
                                String name = names.nextToken();
                                
                                if(!root.hasNode(name))
                                {
                                    root.addNode(name);
                                }
                                root = root.getNode(name);
                            }
                            root.addNode(Text.getName(commentPagePath), CommentsConstants.SLING_FOLDER);
                            ((Session)resource.getResourceResolver().adaptTo(javax.jcr.Session.class)).save();
                        }
                        catch(Exception e)
                        {
                            log.error("[createNodePath()] Exception.", e.getMessage()); 
                        }
                    }
                    else
                    {
                        try
                        {
                            String parentPath = Text.getRelativeParent(commentPagePath, 1);
                            
                            Page page;
                            try
                            {
                                if (resource.getResourceResolver().getResource(parentPath) == null)
                                {
                                    Node root = ((Session)resource.getResourceResolver().adaptTo(Session.class)).getRootNode();
                                    log.info("[createNodePath()] commentNodePath: "+parentPath);
                                    for(StringTokenizer names = new StringTokenizer(parentPath, CommentsConstants.SLASH); names.hasMoreTokens();)
                                    {
                                        String name = names.nextToken();
                                        
                                        if(!root.hasNode(name))
                                        {
                                            root.addNode(name);
                                        }
                                        root = root.getNode(name);
                                    }
                                    root.addNode(Text.getName(parentPath), CommentsConstants.GENERAL_NODE_TYPE);
                                    ((Session)resource.getResourceResolver().adaptTo(javax.jcr.Session.class)).save();
                                }

                                page = ((PageManager) resource.getResourceResolver().adaptTo(PageManager.class)).create(parentPath, Text.getName(commentPagePath), null, null);
                                String resourceType = null;
                                ((Node) page.getContentResource().adaptTo(Node.class)).setProperty(CommentsConstants.SLING_RES_TYPE, resourceType);
                            }
                            catch (Exception e)
                            {
                                log.error("[createNodePath()] Page not created.", e.getMessage());
                            }
                        }
                        catch(Exception ce)
                        {
                            log.error("[createNodePath()] page hierarchy is not created.", ce.getMessage());
                        }
                    }
                } 
            } 
            
            try
            {
                Resource parentResource = resource.getResourceResolver().getResource(commentPagePath+ CommentsConstants.SLASH + CommentsConstants.JCR_CONTENT);
                Node parentNode = null;
                if(null!=parentResource){               
                    parentNode = (Node)parentResource.adaptTo(Node.class);
                }else{
                    Node commentPageNode = (Node)resource.getResourceResolver().getResource(commentPagePath).adaptTo(Node.class);
                    parentNode = commentPageNode.addNode(CommentsConstants.JCR_CONTENT, CommentsConstants.GENERAL_NODE_TYPE);
                }
                Node commentingRootNode = parentNode.addNode(Text.getName(nodePath), CommentsConstants.GENERAL_NODE_TYPE);
                commentingRootNode.setProperty(CommentsConstants.COMMENTS_PAGE_PATH, pagePath);
                referredNode = commentingRootNode;
                
                Page page = resource.getResourceResolver().getResource(pagePath).adaptTo(Page.class);
                String subscribersNodePath = page.getName()+CommentsConstants.UNDERSCORE+Text.getName(nodePath);
                
                Node subscribersPageNode = parentNode.getParent().addNode(subscribersNodePath, CommentsConstants.PAGE_NODE_TYPE);
                Node subscribersNode = subscribersPageNode.addNode(CommentsConstants.JCR_CONTENT, CommentsConstants.GENERAL_NODE_TYPE);
                subscribersNode.setProperty(CommentsConstants.COMMENTS_PAGE_PATH, pagePath); 
                subscribersNode.setProperty(CommentsConstants.REFERER, (referer.indexOf(CommentsConstants.QUESTIONMARK)==-1 ? referer : referer.substring(0,referer.indexOf(CommentsConstants.QUESTIONMARK))));
                
                ((Session)resource.getResourceResolver().adaptTo(javax.jcr.Session.class)).save();
            }
            catch(RepositoryException re)
            {
                log.error("[buildCommentContent()] Failed to prepare user generated content", re.getMessage());
            }
        }
    }

    public Node getRootNode() throws Exception
    {
        Node rootNode = referredNode;
        if(referredNode.isNodeType(CommentsConstants.COMMENT_NODE_TYPE)) {
            while(rootNode.isNodeType(CommentsConstants.COMMENT_NODE_TYPE)) {
                rootNode = rootNode.getParent();
            }
        }
        return rootNode;
    }
    
    public Node getReferredNode() {
        return referredNode;
    }
}