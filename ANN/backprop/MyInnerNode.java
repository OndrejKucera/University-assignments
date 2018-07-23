package com.rapidminer.operator.learner.functions.neuralnet.backprop;

import com.rapidminer.example.Example;
import com.rapidminer.tools.RandomGenerator;


public class MyInnerNode extends MyNode {

	private double[] weights;

	private RandomGenerator randomGen;
	

	public MyInnerNode(String nodeName, int layerIndex, RandomGenerator randomGenerator) {
		super(nodeName, layerIndex, HIDDEN);
		randomGen = randomGenerator;
		weights = new double[] { randomGen.nextDouble()};// * 0.1d - 0.05d };
		System.out.println(randomGen.nextDouble() + "*" + 0.1d + "-" + 0.05d + "=" + weights);
	}

	@Override
	public double calculateValue(boolean shouldCalculate, Example example) {
		if (Double.isNaN(currentValue) && shouldCalculate) {
			MyNode[] inputs = this.getInputNodes();
	        double[] weights = this.getWeights();
	        double weightedSum = weights[0]; // bias
	        for (int i = 0; i < inputs.length; i++) {
	            weightedSum += inputs[i].calculateValue(true, example) * weights[i + 1];
	        }

	        double result = 0.0d;
	        if (weightedSum < -45.0d) {
	            result = 0;
	        } else if (weightedSum > 45.0d) {
	            result = 1;
	        } else {
	            result = 1 / (1 + Math.exp(-1 * weightedSum));
	        }
	        currentValue = result;
		}
		return currentValue;
	}

	@Override
	public double calculateError(boolean shouldCalculate, Example example) {
		if (!Double.isNaN(currentValue) && Double.isNaN(currentError) && shouldCalculate) {
			MyNode[] outputs = this.getOutputNodes();
	        int[] numberOfOutputs = this.getOutputNodeInputIndices();
	        double errorSum = 0;
	        for (int i = 0; i < outputs.length; i++) {
	            errorSum += outputs[i].calculateError(true, example) * outputs[i].getWeight(numberOfOutputs[i]);
	        }
	        double value = this.calculateValue(false, example);
			currentError = errorSum * value * (1 - value);
		}
		return currentError;
	}

	@Override
	public void update(Example example, double learningRate) {
		if (!areWeightsUpdated() && !Double.isNaN(currentError)) {
			MyNode[] inputs = this.getInputNodes();
			double[] weights = this.getWeights();
			double delta = learningRate * this.calculateError(false, example);

			// threshold update
			double thresholdChange = delta;
			weights[0] += thresholdChange;

			// update node weights
			for (int i = 1; i < inputs.length + 1; i++) {
				double currentChange = delta * inputs[i - 1].calculateValue(false, example);
				weights[i] += currentChange;
			}
			
			this.setWeights(weights);
			
			super.update(example, learningRate);
		}
	}
	
	@Override
	public double getWeight(int n) {
		return weights[n + 1];
	}

	public double[] getWeights() {
		return weights;
	}

	public void setWeights(double[] weights) {
		this.weights = weights;
	}
	
	@Override
	protected boolean connectInput(MyNode i, int n) {
		if (!super.connectInput(i, n)) {
			return false;
		}
		
		double[] newWeights = new double[weights.length + 1];
		System.arraycopy(weights, 0, newWeights, 0, weights.length);
		newWeights[newWeights.length - 1] = this.randomGen.nextDouble() * 0.1d - 0.05d;
		weights = newWeights;

		return true;
	}

	@Override
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
				for (int i = deleteIndex + 1; i < inputNodes.length; i++) {
					inputNodes[i - 1] = inputNodes[i];
					inputNodeOutputIndices[i - 1] = inputNodeOutputIndices[i];
					weights[i] = weights[i + 1];
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
		
		double[] newWeights = new double[numberOfInputs + 1];
		System.arraycopy(weights, 0, newWeights, 0, numberOfInputs + 1);
		weights = newWeights;
		
		return removed;
	}
}
