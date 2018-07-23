package com.project;

public class Result {

	private int score;
	private String resultA;
	private String resultB;
	private String result;
	private int lenghtA;
	private int lenghtB;
	
	public Result(int s, String rA, int lA, String rB, int lB, String r) {
		score = s;
		resultA = rA;
		resultB = rB;
		result = r;
		lenghtA = lA;
		lenghtB = lB;
	}
	
	public int getScore() {
		return score;
	}
	
	public String getResultA() {
		return resultA;
	}
	
	public String getResultB() {
		return resultB;
	}
	
	public String getResult() {
		return result;
	}
	
	public int getLenghtA() {
		return lenghtA;
	}
	
	public int getLenghtB() {
		return lenghtB;
	}
	
	
}
