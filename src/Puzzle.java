import javafx.beans.InvalidationListener;
import javafx.beans.Observable;

public class Puzzle implements Observable {
	
	/*
	Use backtracking to solve the puzzle.
		*/
	
	public Puzzle(){
		
	}
	
	/**
	 * Clears this puzzle.
	 */
	public void clear(){
		//TODO
	}
	
	/**
	 * Solves this puzzle.
	 * @return True if the puzzle was solved, false if there is no solution.
	 */
	public boolean solve(){
		//TODO
		return false;
	}
	
	/**
	 * Sets the value of the puzzle at the location. 
	 * A return value indicates whether this was a valid move.
	 * @param row An int that is the row of the puzzle to set.
	 * @param col An int that is the column of the puzzle to set.
	 * @param value The value to set at row, column.
	 * A value of 0 means blank, 1-9 are the allowed values.
	 * @return True iff the value is allowed.
	 * A false of false means that the puzzle was not changed.
	 */
	public boolean setValue(int row, int col, int value){
		//TODO
		return false;
	}

	@Override
	public void addListener(InvalidationListener listener) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void removeListener(InvalidationListener listener) {
		// TODO Auto-generated method stub
		
	}

}
