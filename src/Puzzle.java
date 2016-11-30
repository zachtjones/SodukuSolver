import javafx.beans.InvalidationListener;
import javafx.beans.Observable;

public class Puzzle implements Observable {
	
	/** Represents the number in row, column */
	byte[][] grid;
	/** Holds the listener for changes to this observable */
	private InvalidationListener view;
	
	public Puzzle(){
		this.grid = new byte[9][9];
	}
	
	/**
	 * Clears this puzzle.
	 */
	public void clear(){
		//set all values to 0
		for(int i = 0; i < 9; i++){
			for(int j = 0; j < 9; j++){
				this.grid[i][j] = 0;
			}
		}
		changedState();
	}
	
	/**
	 * Solves this puzzle.
	 * @return True if the puzzle was solved, false if there is no solution.
	 */
	public boolean solve(){
		Configuration solution = Backtracker.solve(new PuzzleConfig(this));
		if(solution == null){
			return false;
		}
		PuzzleConfig s = (PuzzleConfig)solution;
		this.grid = s.getGrid(); //set this to the reference, don't need to copy
		changedState();
		return true;
	}
	
	/**
	 * Sets the value of the puzzle at the location. 
	 * @param row An int that is the row of the puzzle to set.
	 * @param col An int that is the column of the puzzle to set.
	 * @param value The value to set at row, column.
	 * A value of 0 means blank, 1-9 are the allowed values.
	 */
	public void setValue(int row, int col, byte value){
		//set the value at row, column
		this.grid[row][col] = value;
		changedState();
	}
	
	/**
	 * Gets the value of the puzzle at the location. 
	 * @param row An int that is the row of the puzzle to set.
	 * @param col An int that is the column of the puzzle to set.
	 * @return A value of 0 means blank, 1-9 are digits.
	 */
	public byte getValue(int row, int col){
		return this.grid[row][col];
	}

	@Override
	public void addListener(InvalidationListener listener) {
		this.view = listener;
	}

	@Override
	public void removeListener(InvalidationListener listener) {
		this.view = null;
	}
	
	/**
	 * Call when the view should be updated to reflect the changes to this.
	 */
	private void changedState(){
		this.view.invalidated(this);
	}
	

}
