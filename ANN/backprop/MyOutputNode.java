package com.rapidminer.operator.learner.functions.neuralnet.backprop;

import com.rapidminer.example.Attribute;
import com.rapidminer.example.Example;


public class MyOutputNode extends MyNode {
	
	private Attribute label;
	
	private int classIndex = 0;

	public MyOutputNode(String nodeName, Attribute label) {
		super(nodeName, OUTPUT, OUTPUT);
		this.label = label;
	}

	public void setClassIndex(int classIndex) {
		this.classIndex = classIndex;
	}
	
	public int getClassIndex() {
		return this.classIndex;
	}
	
	@Override
	public double calculateValue(boolean shouldCalculate, Example example) {
		if (Double.isNaN(currentValue) && shouldCalculate) {
			currentValue = 0;
			for (int i = 0; i < inputNodes.length; i++) {
				currentValue += inputNodes[i].calculateValue(true, example);
			}
		}
		return currentValue;
	}

	@Override
	public double calculateError(boolean shouldCalculate, Example example) {
		if (!Double.isNaN(currentValue) && Double.isNaN(currentError) && shouldCalculate) {
			if ((int)example.getValue(label) == classIndex) {
				currentError = 1.0d - currentValue;
			} else {
				currentError = 0.0d - currentValue;
			}
		}
		return currentError;
	}

	public Attribute getLabel() {
		return label;
	}
	
	public double getCurrentValue()
	{
		return currentValue;
	}
}
