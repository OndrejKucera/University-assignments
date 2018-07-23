package com.project;

public class GlobalAlignment extends Alignment{

	/**
	 * Constructor
	 * @param a
	 * @param b
	 */
	public GlobalAlignment(String a, String b) {
		super(a, b);
		
		// Inicialization first row
		for(short i=0; i<row+1; i++) {
			mainMatrix[i][0] = (PenaltyMatrix.getGapPenalty()*i); 
		}
		
		// Inicialization first column
		for(short i=0; i<column+1; i++) {
			mainMatrix[0][i] = (PenaltyMatrix.getGapPenalty()*i); 
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
	 * Needleman–Wunsch algorithm
	 */
	public Result getAlignment() {
		int i = row;
		int j = column;
		
		String resultA = "";
	    String resultB = "";
		
	    // Algorithm
		while (i > 0 && j > 0) {
			int itemActual = mainMatrix[i][j];
		    int itemDiag = mainMatrix[i-1][j-1];
		    int itemUp = mainMatrix[i-1][j];
		    int itemLeft = mainMatrix[i][j-1];
		    
		    if (itemActual == itemDiag + PenaltyMatrix.getPenalty(dnaA.charAt(i-1),dnaB.charAt(j-1))) {
		    	resultA =  dnaA.charAt(i-1) + resultA;
		    	resultB =  dnaB.charAt(j-1) + resultB;
		    	i -= 1;
		    	j -= 1;
		    }
		    else if (itemActual == itemLeft + PenaltyMatrix.getGapPenalty()) {
		    	resultA = "-" + resultA;
		    	resultB = dnaB.charAt(j-1) + resultB;
		    	j -= 1;
		    }
		    else if (itemActual == itemUp + PenaltyMatrix.getGapPenalty()) {
		    	resultA = dnaA.charAt(i-1) + resultA;
		    	resultB = "-" + resultB;
		      	i -= 1;
		    }
		}
		
		while (j > 0) {
			resultA = "-" + resultA;
			resultB = dnaB.charAt(j-1) + resultB;
	    	j -= 1;
		}
		
		while (i > 0) {
			resultA = dnaA.charAt(i-1) + resultA;
			resultB = "-" + resultB;
	      	i -= 1;
		}
		
		// Printout
		String result = "";
		
		for(int k=0; k<resultA.length() ; k++) {
			if (resultA.charAt(k) == '-' || resultB.charAt(k) == '-') {
				result = result + " ";
			} else if(resultA.charAt(k) == resultB.charAt(k)) {
				result = result + "|";
			} else {
				result = result + ".";
			}
		}
		
		Result r = new Result(mainMatrix[row][column], resultA, row, resultB, column, result);
		
		return r;
	}
}
