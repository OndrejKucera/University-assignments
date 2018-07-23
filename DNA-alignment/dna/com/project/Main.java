package com.project;

import java.util.HashMap;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		HashMap<Integer, Result> mapOfResult = new HashMap<Integer, Result>();

		/*Alignment alignment = new GlobalAlignment(
				"TCCCAGTTATGTCAGGGGACACGAGCATGCAGAGAC",
				"AATTGCCGCCGTCGTTTTCAGCAGTTATGTCAGATC");
				*/

		Alignment alignment = new LocalAlignment(
				"TCCCAGTTATGTCAGGGGACACGAGCATGCAGAGAC",
				"AATTGCCGCCGTCGTTTTCAGCAGTTATGTCAGATC");
		
		Result r = alignment.getAlignment();
		
		mapOfResult.put(r.getScore(), r);
		
		for(Result res : mapOfResult.values()) {
			System.out.println(res.getResultA());
			System.out.println(res.getResult());
			System.out.println(res.getResultB());
		}

		return;
	}
}
