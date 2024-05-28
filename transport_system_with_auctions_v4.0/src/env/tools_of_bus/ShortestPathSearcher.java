// CArtAgO artifact code for project transport_system_with_auctions

package tools_of_bus;

import cartago.*;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import models.Graph;
import models.Node;

public class ShortestPathSearcher extends Artifact {
	
	public static int getShortestPathLength(String startPoint, String endPoint) {
		
		if (startPoint.equals(endPoint)) {
			return 0;
		}
		
		//directed graph creation
        List<Node> graphNodes = PathBuilder.prepareNodeListForGraph(startPoint,endPoint);
        Graph graph = new Graph();
        for (Node node: graphNodes){
            graph.addNode(node);
        }
        
      //searching for the shortest path
        Node firstNode = graphNodes.get(0);
        graph = calculateShortestPathFromSource(graph, firstNode);
        
        int result = 0;
        for(Node node: graph.getNodes()){
            if(node.getName().equals(endPoint)){
                result = node.getDistance();
                break;
            }
        }
        
        return result;
	}
	
	public static Graph calculateShortestPathFromSource(Graph graph, Node source) {

        source.setDistance(0);

        Set<Node> settledNodes = new HashSet<>();
        Set<Node> unsettledNodes = new HashSet<>();
        unsettledNodes.add(source);

        while (unsettledNodes.size() != 0) {
            Node currentNode = getLowestDistanceNode(unsettledNodes);
            unsettledNodes.remove(currentNode);
            for (Map.Entry<Node, Integer> adjacencyPair : currentNode.getAdjacentNodes().entrySet()) {
                Node adjacentNode = adjacencyPair.getKey();
                Integer edgeWeigh = adjacencyPair.getValue();

                if (!settledNodes.contains(adjacentNode)) {
                    CalculateMinimumDistance(adjacentNode, edgeWeigh, currentNode);
                    unsettledNodes.add(adjacentNode);
                }
            }
            settledNodes.add(currentNode);
        }
        return graph;
    }

    private static void CalculateMinimumDistance(Node evaluationNode, Integer edgeWeigh, Node sourceNode) {
        Integer sourceDistance = sourceNode.getDistance();
        if (sourceDistance + edgeWeigh < evaluationNode.getDistance()) {
            evaluationNode.setDistance(sourceDistance + edgeWeigh);
            LinkedList<Node> shortestPath = new LinkedList<>(sourceNode.getShortestPath());
            shortestPath.add(sourceNode);
            evaluationNode.setShortestPath(shortestPath);
        }
    }

    private static Node getLowestDistanceNode(Set<Node> unsettledNodes) {
        Node lowestDistanceNode = null;
        int lowestDistance = Integer.MAX_VALUE;
        for (Node node : unsettledNodes) {
            int nodeDistance = node.getDistance();
            if (nodeDistance < lowestDistance) {
                lowestDistance = nodeDistance;
                lowestDistanceNode = node;
            }
        }
        return lowestDistanceNode;
    }
    
}

