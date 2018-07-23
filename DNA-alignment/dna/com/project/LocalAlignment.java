package com.project;

public class LocalAlignment extends Alignment {

	/**
	 * Constructor
	 * @param a
	 * @param b
	 */
	public LocalAlignment(String a, String b) {
		super(a, b);
		
		// Inicialization first row
		for(short i=0; i<row+1; i++) {
			mainMatrix[i][0] = 0; 
		}
		
		// Inicialization first column
		for(short i=0; i<column+1; i++) {
			mainMatrix[0][i] = 0; 
		}
		
		for(int i=1; i<row+1; i++) {
			for(int j=1; j<column+1; j++) {
				int match = mainMatrix[i-1][j-1] + PenaltyMatrix.getPenalty(dnaA.charAt(i-1),dnaB.charAt(j-1));
				int delete = mainMatrix[i-1][j] + PenaltyMatrix.getGapPenalty();
				int insert = mainMatrix[i][j-1] + PenaltyMatrix.getGapPenalty();
				mainMatrix[i][j] = PenaltyMatrix.maxOfThree(match, insert, delete);
			}
		}
	}

	/**
	 * Smith–Waterman algorithm
	 */
	public Result getAlignment() {
		
		// TODO Auto-generated method stub
	
		
		return null;
	}

}
