import java.util.LinkedList;
import java.util.List;

public class PuzzleConfig implements Configuration {
	
	private byte[][] grid;
	private byte cursorCol, cursorRow;
	
	/**
	 * Constructor from a Puzzle object
	 * @param p
	 */
	public PuzzleConfig(Puzzle p){
		this.grid = p.grid;
		this.cursorRow = 0;
		this.cursorCol = -1;
		//create a separate grid, don't want a reference
		this.grid = new PuzzleConfig(this).grid;
	}
	
	/**
	 * Copy constructor. This creates a 'deep' copy.
	 * @param other The other PuzzleConfig to create a copy of.
	 */
	public PuzzleConfig(PuzzleConfig other){
		this.cursorRow = other.cursorRow;
		this.cursorCol = other.cursorCol;
		this.grid = new byte[9][9];
		//copy grid
		for(int i = 0; i < 9; i++){
			for(int j = 0; j < 9; j++){
				this.grid[i][j] = other.grid[i][j];
			}
		}
	}

	@Override
	public List<Configuration> getSuccessors() {
		List<Configuration> c = new LinkedList<>();
		this.cursorCol++;
		if(this.cursorCol == 9){
			this.cursorCol = 0;
			this.cursorRow++;
		}
		if(this.grid[cursorRow][cursorCol] != 0){
			//already set, so move on to next one
			c.add(new PuzzleConfig(this));
		} else {
			//add all 9
			for(byte i = 1; i <= 9; i++){
				PuzzleConfig temp = new PuzzleConfig(this);
				temp.grid[cursorRow][cursorCol] = i;
				c.add(temp);
			}
		}
		return c;
	}

	@Override
	public boolean isGoal() {
		if(cursorCol == 8 && cursorRow == 8){
			return isValid();
		}
		//not at the end yet
		return false;
	}

	@Override
	public boolean isValid() {
		//only need to check the last thing placed at the cursor
		//the item at the cursor will never be 0
		for(int i = 0; i < 9; i++){
			//go across
			if(i == this.cursorCol){ continue; }
			if(this.grid[cursorRow][i] == this.grid[cursorRow][cursorCol]){
				return false; //duplicate in row
			}
		}
		for(int i = 0; i < 9; i++){
			//go down
			if(i == this.cursorRow){ continue; }
			if(this.grid[i][cursorCol] == this.grid[cursorRow][cursorCol]){
				return false; //duplicate in column
			}
			
		}
		//check block
		int blockRow = this.cursorRow / 3 * 3; //rounds down to 0, 3, or 6
		int blockCol = this.cursorCol / 3 * 3; //rounds down to 0, 3, or 6
		
		for(int row = blockRow; row < blockRow + 3; row++){
			for(int col = blockCol; col < blockCol + 3; col++){
				if(row == cursorRow && col == cursorCol){ continue; }
				if(this.grid[cursorRow][cursorCol] == grid[row][col]){
					return false; //dupblicate in block
				}
			}
		}
		// TODO Auto-generated method stub
		return true;
	}
	
	/**Returns the grid of this puzzle configuration.*/
	public byte[][] getGrid(){
		return this.grid;
	}

}
