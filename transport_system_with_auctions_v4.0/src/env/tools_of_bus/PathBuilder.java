// CArtAgO artifact code for project transport_system_with_auctions

package tools_of_bus;

import cartago.*;
import models.Node;
import models.Path;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class PathBuilder extends Artifact {

    private static List<Path> buildAllPaths() {

        List<Path> paths = new ArrayList<>();

        Node nodeA = new Node("A");
        Node nodeB = new Node("B");
        Node nodeC = new Node("C");
        Node nodeD = new Node("D");
        Node nodeE = new Node("E");
        Node nodeF = new Node("F");        
        Node nodeG = new Node("G");
        Node nodeH = new Node("H");
        Node nodeI = new Node("I");
        Node nodeJ = new Node("J");

        paths.add(new Path(nodeA, nodeB,100));
        paths.add(new Path(nodeA, nodeC,150));
        paths.add(new Path(nodeB, nodeD,120));
        paths.add(new Path(nodeB, nodeF,150));
        paths.add(new Path(nodeD, nodeF,10));
        paths.add(new Path(nodeD, nodeE,20));
        paths.add(new Path(nodeF, nodeE,50));
        paths.add(new Path(nodeC, nodeE,100));        
        paths.add(new Path(nodeF, nodeG,60));
        paths.add(new Path(nodeG, nodeI,100));
        paths.add(new Path(nodeG, nodeJ,80));
        paths.add(new Path(nodeH, nodeE,10));
        paths.add(new Path(nodeH, nodeI,30));
        paths.add(new Path(nodeH, nodeJ,40));

        return paths;
    }

    //creating list of nodes with their parameters (distance, adjacentNodes)
    public static List<Node> prepareNodeListForGraph(String startNode, String endNode){

        List<Node> result = new ArrayList<>();

        //nodes and paths creation
        List<Path> paths = buildAllPaths();

        //first node determination
        Node currentNode = new Node(startNode);
        for (Path path: paths) {
            if(path.getStartNode().getName().equals(startNode)){
                currentNode = path.getStartNode();
                break;
            }
            else if(path.getEndNode().getName().equals(startNode)){
                currentNode = path.getEndNode();
                break;
            }
        }

        List<Node> notAddedNodes = new ArrayList<>();
        Set<String> addedNodes = new HashSet<>();
        notAddedNodes.add(currentNode);

        int listIndex = 0;
        int pathsCounter = 0;

        //setting directions to the paths
        while(pathsCounter <= paths.size()){

            if(currentNode.getName().equals(endNode)){
                result.add(currentNode);
                if(paths.size() == pathsCounter || notAddedNodes.size() == listIndex+1){
                    break;
                }
                else {
                    listIndex++;
                    currentNode = notAddedNodes.get(listIndex);
                    continue;
                }
            }

            for(Path path: paths){
                if(path.getStartNode().getName().equals(currentNode.getName()) &&
                        !addedNodes.contains(path.getEndNode().getName())){
                    currentNode.addDestination(path.getEndNode(),path.getLength());
                    if (!notAddedNodes.contains(path.getEndNode())){
                        notAddedNodes.add(path.getEndNode());
                    }
                    pathsCounter++;
                }
                else if(path.getEndNode().getName().equals(currentNode.getName()) &&
                        !addedNodes.contains(path.getStartNode().getName())){
                    currentNode.addDestination(path.getStartNode(),path.getLength());
                    if (!notAddedNodes.contains(path.getStartNode())){
                        notAddedNodes.add(path.getStartNode());
                    }
                    pathsCounter++;
                }
            }

            result.add(currentNode);
            addedNodes.add(currentNode.getName());
            listIndex++;
            if(listIndex < notAddedNodes.size()){
                currentNode = notAddedNodes.get(listIndex);
            }
            else{
                break;
            }

        }

        return result;
    }

	
}

