package com.rapidminer.operator.learner.functions.neuralnet.backprop;

import com.rapidminer.example.Attribute;
import com.rapidminer.example.Example;


public class MyInputNode extends MyNode {

	private Attribute attribute;
	
	public MyInputNode(String nodeName) {
		super(nodeName, INPUT, INPUT);
	}
	
	public void setAttribute(Attribute attribute) {
		this.attribute = attribute;
	}

	@Override
	public double calculateValue(boolean shouldCalculate, Example example) {
		if (Double.isNaN(currentValue) && shouldCalculate) {
			double value = example.getValue(attribute);
			if (Double.isNaN(value)) {
				currentValue = 0;
			} else {
				currentValue = value;
			}
		}
		return currentValue;
	}

	@Override
	public double calculateError(boolean shouldCalculate, Example example) {
		if (!Double.isNaN(currentValue) && Double.isNaN(currentError) && shouldCalculate) {
			currentError = 0;
			for (int i = 0; i < outputNodes.length; i++) {
				currentError += outputNodes[i].calculateError(true, example);
			}
		}
		return currentError;
	}

	public Attribute getAttribute() {
		return attribute;
	}

	public double getCurrentValue()
	{
		return currentValue;
	}
}
