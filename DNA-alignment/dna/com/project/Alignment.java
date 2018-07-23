package com.project;

abstract class Alignment {

	protected String dnaA;
	protected String dnaB;
	
	protected int row;
	protected int column;
	
	protected int[][] mainMatrix;
	
	/**
	 * Constructor
	 * @param a
	 * @param b
	 */
	public Alignment(String a, String b) {
		
		// Load DNA
		dnaA = a;
		dnaB = b;
		
		// Set row and column
		row = dnaA.length();
		column = dnaB.length();
	
		// Defined matrix
		mainMatrix = new int[row+1][column+1];
	}
	
	/**
	 * Algorithm for local or global alignment
	 */
	public abstract Result getAlignment();
}
