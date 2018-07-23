package com.project;

/**
 *
 */
public class PenaltyMatrix {

	// Penalty for insert gap to the dna
	private static byte gapPenalty = -2;
	
	// Score matrix	
	private static byte[][] penaltyMatrix = {{4, -2,  1, -2},
											{-2,  4, -2,  1},
											{ 1, -2,  4, -2},
											{-2,  1, -2,  4}};
	
	
	/**
	 * Method for return penalty of gap
	 * @return
	 */
	public static byte getGapPenalty() {
		return gapPenalty;
	}
	
	
	/**
	 * Method for return score for two char form matrix 
	 * @param a
	 * @param b
	 * @return
	 */
	public static byte getPenalty(char a, char b) {
		byte i=0, j=0;
		
		switch(a) {
			case 'A': i=0; break;
			case 'G': i=1; break;
			case 'C': i=2; break;
			case 'T': i=3; break;
		}
		
		switch(b) {
			case 'A': j=0; break;
			case 'G': j=1; break;
			case 'C': j=2; break;
			case 'T': j=3; break;
		}
		
		return penaltyMatrix[i][j];
	}
	
	/**
	 * Method return maximum from three number
	 * @param a
	 * @param b
	 * @param c
	 * @return
	 */
	public static int maxOfThree(int a, int b, int c) {
		if(a>b) {
			if(a>c) {
				return a;
			} else {
				return c;
			}
		} else {
			if(b>c) {
				return b;
			} else {
				return c;
			}
		}
	}
	
}
