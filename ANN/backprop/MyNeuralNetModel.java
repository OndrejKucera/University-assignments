package com.rapidminer.operator.learner.functions.neuralnet.backprop;

import java.util.Iterator;
import java.util.List;

import com.rapidminer.example.Attribute;
import com.rapidminer.example.Example;
import com.rapidminer.example.ExampleSet;
import com.rapidminer.operator.OperatorException;
import com.rapidminer.operator.learner.PredictionModel;
import com.rapidminer.tools.RandomGenerator;
import com.rapidminer.tools.Tools;

public class MyNeuralNetModel extends PredictionModel {

	private static final long serialVersionUID = 8403049374832379809L;
	
	private MyInputNode[] inputNodes = new MyInputNode[0];
    private MyInnerNode[] innerNodes = new MyInnerNode[0];
    private MyOutputNode[] outputNodes = new MyOutputNode[0];
	
    
	protected MyNeuralNetModel(ExampleSet trainingSet) {
		super(trainingSet);
	}
	
	
	public void train(ExampleSet trainSet, List<String[]> layers, int maxCycles, double learningRate, RandomGenerator randomGenerator) throws OperatorException  {
		
		/////////////
		// Number of classes
		Attribute label = trainSet.getAttributes().getLabel();	
		int numberOfClasses = 1;
		if (label.isNominal()) {
			numberOfClasses = label.getMapping().size();
		}

		
		/////////////
		// Initialize INPUT layer
		int numberOfAttributes = trainSet.getAttributes().size();
		inputNodes = new MyInputNode[numberOfAttributes];
		int index = 0;
        for (Attribute attribute : trainSet.getAttributes()) {
            inputNodes[index] = new MyInputNode(attribute.getName());
            inputNodes[index].setAttribute(attribute);
            index++;
        }
        
		
        /////////////
		// Initialize OUTPUT layer
        outputNodes = new MyOutputNode[numberOfClasses];
        for (int o = 0; o < numberOfClasses; o++) {
        	MyInnerNode actualOutput = null;
            if (!label.isNominal()) {
            	throw new OperatorException("Network works only with nominal data.");
            } else {
                outputNodes[o] = new MyOutputNode(label.getMapping().mapIndex(o), label);
                outputNodes[o].setClassIndex(o);
                String classValue = label.getMapping().mapIndex(o);
                actualOutput = new MyInnerNode("Class '" + classValue + "'", MyNode.OUTPUT, randomGenerator);
            }

            // add node to array of inner nodes
            MyInnerNode[] newInnerNodes = new MyInnerNode[innerNodes.length + 1];
            System.arraycopy(innerNodes, 0, newInnerNodes, 0, innerNodes.length);
            newInnerNodes[newInnerNodes.length - 1] = actualOutput;
            innerNodes = newInnerNodes;
            
            MyNode.connect(actualOutput, outputNodes[o]);
        }
        
		
        /////////////
		// Initialize HIDDEN layers
        String[] layerNames = null;
        int[] layerSizes = null;
        if (layers.size() > 0) {
            layerNames = new String[layers.size()];
            layerSizes = new int[layers.size()];

            int indexLayer = 0;
            Iterator<String[]> iter = layers.iterator();
            while (iter.hasNext()) {
                String[] nameSizePair = iter.next();
                layerNames[indexLayer] = nameSizePair[0];
                int layerSize = Integer.valueOf(nameSizePair[1]);
                if (layerSize <= 0)
                    layerSize = numberOfAttributes;
                layerSizes[indexLayer] = layerSize;
                indexLayer++;
            }
        } else {
            // create at least one hidden layer
            layerNames = new String[] { "Hidden" };
            layerSizes = new int[] {numberOfAttributes};
        }
        
        // create node in layer and connect with previous layer
        int lastLayerSize = 0;
        for (int layerIndex = 0; layerIndex < layerNames.length; layerIndex++) {
            int numberOfNodes = layerSizes[layerIndex];
            for (int nodeIndex = 0; nodeIndex < numberOfNodes; nodeIndex++) {
                MyInnerNode innerNode = new MyInnerNode("Node " + (nodeIndex + 1), layerIndex, randomGenerator);
                // add node to array of inner node
                MyInnerNode[] newInnerNodes = new MyInnerNode[innerNodes.length + 1];
                System.arraycopy(innerNodes, 0, newInnerNodes, 0, innerNodes.length);
                newInnerNodes[newInnerNodes.length - 1] = innerNode;
                innerNodes = newInnerNodes;
                if (layerIndex > 0) {
                    // connect to all nodes of previous layer
                    for (int i = innerNodes.length - nodeIndex - 1 - lastLayerSize; i < innerNodes.length - nodeIndex - 1; i++) {
                        MyNode.connect(innerNodes[i], innerNode);
                    }
                }
            }
            lastLayerSize = numberOfNodes;
        }
        
        // connect hidden layer with input and output
        int firstHidLayerSize = layerSizes[0];
        if (firstHidLayerSize == 0) {
        	// direct connection between in- and outputs
            for (int i = 0; i < numberOfAttributes; i++) {
                for (int o = 0; o < numberOfClasses; o++) {
                    MyNode.connect(inputNodes[i], innerNodes[o]);
                }
            }
        } else {
            // connect input to first hidden layer
            for (int i = 0; i < numberOfAttributes; i++) {
                for (int o = numberOfClasses; o < numberOfClasses + firstHidLayerSize; o++) {
                    MyNode.connect(inputNodes[i], innerNodes[o]);
                }
            }
            // connect last hidden layer to output
            for (int i = innerNodes.length - lastLayerSize; i < innerNodes.length; i++) {
                for (int o = 0; o < numberOfClasses; o++) {
                    MyNode.connect(innerNodes[i], innerNodes[o]);
                }
            }
        }
	    
        
        ///////////
        // BACKPROPAGATION
        for (int cycle = 0; cycle < maxCycles; cycle++) {
            for (int exampleIndex = 0; exampleIndex < trainSet.size(); exampleIndex++) {

                Example example = trainSet.getExample(exampleIndex);

                // reset all network
                for (MyOutputNode outputNode : outputNodes) {
                    outputNode.reset();
                }

                // calculate Value
                for (MyOutputNode outputNode : outputNodes) {
                    outputNode.calculateValue(true, example);
                }

                // calculate error
        		for (MyInputNode inputNode : inputNodes) {
                    inputNode.calculateError(true, example);
                }
                
                // update weight
                for (MyOutputNode outputNode : outputNodes) {
                    outputNode.update(example, learningRate);
                }
            }
        } 

	}
	

	@Override
	public ExampleSet performPrediction(ExampleSet exampleSet, Attribute predictedLabel) throws OperatorException {
		for (Example example : exampleSet) {
			for (MyOutputNode outputNode : outputNodes) {
	            outputNode.reset();
	        }
		
			if (predictedLabel.isNominal()) {
				// number of classes
				Attribute label = exampleSet.getAttributes().getLabel();	
				int numberOfClasses = 1;
				if (label.isNominal()) {
					numberOfClasses = label.getMapping().size();
				}
				
				// calculate values
                double[] classProbabilities = new double[numberOfClasses];
                for (int c = 0; c < numberOfClasses; c++) {
                    classProbabilities[c] = outputNodes[c].calculateValue(true, example);
                }
                
                double total = 0.0;
                for (int c = 0; c < numberOfClasses; c++) {
                    total += classProbabilities[c];
                }

                // search best fit for classes
                double maxConfidence = Double.NEGATIVE_INFINITY;
                int maxIndex = 0;
                for (int c = 0; c < numberOfClasses; c++) {
                    classProbabilities[c] /= total;
                    if (classProbabilities[c] > maxConfidence) {
                        maxIndex = c;
                        maxConfidence = classProbabilities[c];
                    }
                }

                example.setValue(predictedLabel, predictedLabel.getMapping().mapString(getLabel().getMapping().mapIndex(maxIndex)));
                for (int c = 0; c < numberOfClasses; c++) {
                    example.setConfidence(getLabel().getMapping().mapIndex(c), classProbabilities[c]);
                }
                
			} else {
				throw new OperatorException("Network works only with nominal data.");
			}
			
		}
		
		return exampleSet;
	}

	
	@Override
    public String toString() {
        StringBuffer result = new StringBuffer();
        int lastLayerIndex = -99;
        boolean first = true;
        for (MyInnerNode innerNode : innerNodes) {
            // skip outputs here and add them later

            // layer name
            int layerIndex = innerNode.getLayerIndex();
            if (layerIndex != MyNode.OUTPUT) {
                if (lastLayerIndex == -99 || lastLayerIndex != layerIndex) {
                    if (!first)
                        result.append(Tools.getLineSeparators(2));
                    first = false;

                    String layerName = "Hidden " + (layerIndex + 1);

                    result.append(layerName + Tools.getLineSeparator());
                    for (int t = 0; t < layerName.length(); t++)
                        result.append("=");
                    lastLayerIndex = layerIndex;
                    result.append(Tools.getLineSeparator());
                }

                // node name and type
                String nodeName = innerNode.getNodeName();
                result.append(Tools.getLineSeparator() + nodeName + Tools.getLineSeparator());
                for (int t = 0; t < nodeName.length(); t++)
                    result.append("-");
                result.append(Tools.getLineSeparator());

                // input weights
                double[] weights = innerNode.getWeights();
                MyNode[] inputNodes = innerNode.getInputNodes();
                for (int i = 0; i < inputNodes.length; i++) {
                    result.append(inputNodes[i].getNodeName() + ": " + Tools.formatNumber(weights[i + 1]) + Tools.getLineSeparator());
                }

                // threshold weight
                result.append("Bias: " + Tools.formatNumber(weights[0]) + Tools.getLineSeparator());
            }
        }

        // add output nodes
        first = true;
        for (MyInnerNode innerNode : innerNodes) {
            // layer name
            int layerIndex = innerNode.getLayerIndex();
            if (layerIndex == MyNode.OUTPUT) {
                if (first) {
                    result.append(Tools.getLineSeparators(2));
                    String layerName = "Output";
                    result.append(layerName + Tools.getLineSeparator());
                    for (int t = 0; t < layerName.length(); t++)
                        result.append("=");
                    lastLayerIndex = layerIndex;
                    result.append(Tools.getLineSeparator());
                    first = false;
                }

                // node name and type
                String nodeName = innerNode.getNodeName();
                result.append(Tools.getLineSeparator() + nodeName + Tools.getLineSeparator());
                for (int t = 0; t < nodeName.length(); t++)
                    result.append("-");
                result.append(Tools.getLineSeparator());

                // input weights
                double[] weights = innerNode.getWeights();
                MyNode[] inputNodes = innerNode.getInputNodes();
                for (int i = 0; i < inputNodes.length; i++) {
                    result.append(inputNodes[i].getNodeName() + ": " + Tools.formatNumber(weights[i + 1]) + Tools.getLineSeparator());
                }

                // threshold weight
                result.append("Threshold: " + Tools.formatNumber(weights[0]) + Tools.getLineSeparator());
            }
        }
        
        return result.toString();
    }
	
	
}
