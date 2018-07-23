package com.rapidminer.operator.learner.functions.neuralnet.backprop;

import java.io.Serializable;

import com.rapidminer.example.Example;


public abstract class MyNode implements Serializable {

	public static final int INPUT  = -1;
	public static final int HIDDEN = 0;
	public static final int OUTPUT = -2;
	
	private int layerIndex;
	
	private String nodeName;
	
	private int nodeType;
	
	private boolean weightsAreUpdated = false;
	
	protected MyNode[] inputNodes = new MyNode[0];

	protected MyNode[] outputNodes = new MyNode[0];

	protected int[] inputNodeOutputIndices = new int[0];

	protected int[] outputNodeInputIndices = new int[0];

	protected double currentValue = Double.NaN;

	protected double currentError = Double.NaN;


	public MyNode(String nodeName, int layerIndex, int nodeType) {
		this.layerIndex = layerIndex;
		this.nodeName = nodeName;
		this.nodeType = nodeType;
	}

	public abstract double calculateValue(boolean calculate, Example example);

	public abstract double calculateError(boolean calculate, Example example);
	
	/** Returns first subclasses (overwrite this method). */
	public double getWeight(int n) {
		return 1;
	}
	
	public int getLayerIndex() {
		return this.layerIndex;
	}
	
	public String getNodeName() {
		return this.nodeName;
	}

	public int getNodeType() { 
		return this.nodeType;
	}

	public void update(Example example, double learningRate) {
		if (!weightsAreUpdated) {
			for (int i = 0; i < inputNodes.length; i++) {
				inputNodes[i].update(example, learningRate);
			}
			weightsAreUpdated = true;
		}
	}
	
	public boolean areWeightsUpdated() {
		 return this.weightsAreUpdated;
	}

	public void reset() {
		if (!Double.isNaN(currentValue) || !Double.isNaN(currentError)) {
			weightsAreUpdated = false;
			currentValue = Double.NaN;
			currentError = Double.NaN;
			for (int i = 0; i < inputNodes.length; i++) {
				inputNodes[i].reset();
			}
		}
	}

	public MyNode[] getInputNodes() {
		return inputNodes;
	}

	public MyNode[] getOutputNodes() {
		return outputNodes;
	}

	public int[] getInputNodeOutputIndices() {
		return inputNodeOutputIndices;
	}

	public int[] getOutputNodeInputIndices() {
		return outputNodeInputIndices;
	}

	protected boolean connectInput(MyNode inputNode, int inputNodeOutputIndex) {
		MyNode[] newInputNodes = new MyNode[inputNodes.length + 1];
		System.arraycopy(inputNodes, 0, newInputNodes, 0, inputNodes.length);
		newInputNodes[newInputNodes.length - 1] = inputNode;
		inputNodes = newInputNodes;
		
		int[] newInputNodeOutputIndices = new int[inputNodeOutputIndices.length + 1];
		System.arraycopy(inputNodeOutputIndices, 0, newInputNodeOutputIndices, 0, inputNodeOutputIndices.length);
		newInputNodeOutputIndices[newInputNodeOutputIndices.length - 1] = inputNodeOutputIndex;
		inputNodeOutputIndices = newInputNodeOutputIndices;
		
		return true;
	}

	protected boolean connectOutput(MyNode outputNode, int outputNodeInputIndex) {
		MyNode[] newOutputNodes = new MyNode[outputNodes.length + 1];
		System.arraycopy(outputNodes, 0, newOutputNodes, 0, outputNodes.length);
		newOutputNodes[newOutputNodes.length - 1] = outputNode;
		outputNodes = newOutputNodes;
		
		int[] newOutputNodeInputIndices = new int[outputNodeInputIndices.length + 1];
		System.arraycopy(outputNodeInputIndices, 0, newOutputNodeInputIndices, 0, outputNodeInputIndices.length);
		newOutputNodeInputIndices[newOutputNodeInputIndices.length - 1] = outputNodeInputIndex;
		outputNodeInputIndices = newOutputNodeInputIndices;
		
		return true;
	}

	protected boolean disconnectInput(MyNode inputNode, int inputNodeOutputIndex) {
		int deleteIndex = -1;
		boolean removed = false;
		int numberOfInputs = inputNodes.length;
		do {
			deleteIndex = -1;
			for (int i = 0; i < inputNodes.length; i++) {
				if (inputNode == inputNodes[i] && (inputNodeOutputIndex == -1 || inputNodeOutputIndex == inputNodeOutputIndices[i])) {
					deleteIndex = i;
					break;
				}
			}

			if (deleteIndex >= 0) {
				for (int i = deleteIndex + 1; i < numberOfInputs; i++) {
					inputNodes[i - 1] = inputNodes[i];
					inputNodeOutputIndices[i - 1] = inputNodeOutputIndices[i];
					inputNodes[i - 1].outputNodeInputIndices[inputNodeOutputIndices[i - 1]] = i - 1;
				}
				numberOfInputs--;
				removed = true;
			}
		} while (inputNodeOutputIndex == -1 && deleteIndex != -1);

		MyNode[] newInputNodes = new MyNode[numberOfInputs];
		System.arraycopy(inputNodes, 0, newInputNodes, 0, numberOfInputs);
		inputNodes = newInputNodes;
		
		int[] newInputNodeOutputIndices = new int[numberOfInputs];
		System.arraycopy(inputNodeOutputIndices, 0, newInputNodeOutputIndices, 0, numberOfInputs);
		inputNodeOutputIndices = newInputNodeOutputIndices;
		
		return removed;
	}

	protected boolean disconnectOutput(MyNode outputNode, int outputNodeInputIndex) {
		int deleteIndex = -1;
		boolean removed = false;
		int numberOfOutputs = outputNodes.length;
		do {
			deleteIndex = -1;
			for (int i = 0; i < outputNodes.length; i++) {
				if (outputNode == outputNodes[i] && (outputNodeInputIndex == -1 || outputNodeInputIndex == outputNodeInputIndices[i])) {
					deleteIndex = i;
					break;
				}
			}

			if (deleteIndex >= 0) {
				for (int i = deleteIndex + 1; i < numberOfOutputs; i++) {
					outputNodes[i - 1] = outputNodes[i];
					outputNodeInputIndices[i - 1] = outputNodeInputIndices[i];
					outputNodes[i - 1].inputNodeOutputIndices[outputNodeInputIndices[i - 1]] = i - 1;
				}
				numberOfOutputs--;
				removed = true;
			}
		} while (outputNodeInputIndex == -1 && deleteIndex != -1);

		MyNode[] newOutputNodes = new MyNode[numberOfOutputs];
		System.arraycopy(outputNodes, 0, newOutputNodes, 0, numberOfOutputs);
		outputNodes = newOutputNodes;
		
		int[] newOutputNodeInputIndices = new int[numberOfOutputs];
		System.arraycopy(outputNodeInputIndices, 0, newOutputNodeInputIndices, 0, numberOfOutputs);
		outputNodeInputIndices = newOutputNodeInputIndices;
		
		return removed;
	}

	public static boolean connect(MyNode firstNode, MyNode secondNode) {
		disconnect(firstNode, secondNode);

		if (!firstNode.connectOutput(secondNode, secondNode.inputNodes.length)) {
			return false;
		}
		
		if (!secondNode.connectInput(firstNode, firstNode.outputNodes.length - 1)) {
			firstNode.disconnectOutput(secondNode, secondNode.inputNodes.length);
			return false;
		}
		
		return true;
	}

	public static boolean disconnect(MyNode firstNode, MyNode secondNode) {
		return firstNode.disconnectOutput(secondNode, -1) && secondNode.disconnectInput(firstNode, -1);
	}
}
