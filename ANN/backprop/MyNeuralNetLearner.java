package com.rapidminer.operator.learner.functions.neuralnet.backprop;

import java.util.List;

import com.rapidminer.example.ExampleSet;
import com.rapidminer.operator.Model;
import com.rapidminer.operator.OperatorCapability;
import com.rapidminer.operator.OperatorException;
import com.rapidminer.operator.learner.AbstractLearner;
import com.rapidminer.operator.OperatorDescription;
import com.rapidminer.parameter.ParameterType;
import com.rapidminer.parameter.ParameterTypeInt;
import com.rapidminer.parameter.ParameterTypeDouble;
import com.rapidminer.parameter.ParameterTypeList;
import com.rapidminer.parameter.ParameterTypeString;
import com.rapidminer.tools.RandomGenerator;


public class MyNeuralNetLearner extends AbstractLearner {
	
	
	public static final String PARAMETER_HIDDEN_LAYERS = "hidden_layers";
	public static final String PARAMETER_TRAINING_CYCLES = "training_cycles";
	public static final String PARAMETER_LEARNING_RATE = "learning_rate";
	
	public MyNeuralNetLearner(OperatorDescription description) {
		super(description);
	}
	
	
	@Override
	public Model learn(ExampleSet trainSet) throws OperatorException {
		MyNeuralNetModel model = new MyNeuralNetModel(trainSet);
		
		List<String[]> layers = getParameterList(PARAMETER_HIDDEN_LAYERS);
		int cycles = getParameterAsInt(PARAMETER_TRAINING_CYCLES);
		double rate = getParameterAsDouble(PARAMETER_LEARNING_RATE);
		RandomGenerator randomGenerator = RandomGenerator.getRandomGenerator(this);
		
		model.train(trainSet, layers, cycles, rate, randomGenerator);
		return model;
	}
	
	
	@Override
	public boolean supportsCapability(OperatorCapability capability) {
		switch (capability) {
		case NUMERICAL_ATTRIBUTES:
		case POLYNOMINAL_LABEL:
		case BINOMINAL_LABEL:
		case NUMERICAL_LABEL:
		case WEIGHTED_EXAMPLES:
			return true;			
		default:
			return false;
		}
	}
	
	
	@Override
	public List<ParameterType> getParameterTypes() {
		List<ParameterType> types = super.getParameterTypes();

		ParameterType type = new ParameterTypeList(PARAMETER_HIDDEN_LAYERS, "", 
				new ParameterTypeString("hidden_layer_name", ""),
				new ParameterTypeInt("hidden_layer_sizes", "", -1, Integer.MAX_VALUE, -1));
		type.setExpert(false);
		types.add(type);

		type = new ParameterTypeInt(PARAMETER_TRAINING_CYCLES, "", 1, Integer.MAX_VALUE, 400);
		type.setExpert(false);
		types.add(type);

		type = new ParameterTypeDouble(PARAMETER_LEARNING_RATE, "", Double.MIN_VALUE, 1.0d, 0.3d);
		type.setExpert(false);
		types.add(type);

		return types;
	}

}

