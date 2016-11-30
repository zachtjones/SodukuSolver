import java.util.List;

public class PuzzleConfig implements Configuration {
	
	private byte[][] grid;
	private byte cursorX, cursorY;
	
	/**
	 * Constructor from a Puzzle object
	 * @param p
	 */
	public PuzzleConfig(Puzzle p){
		this.grid = p.grid;
		this.cursorX = 0;
		this.cursorY = 0;
		//create a separate grid, don't want a reference
		this.grid = new PuzzleConfig(this).grid;
	}
	
	/**
	 * Copy constructor. This creates a 'deep' copy.
	 * @param other The other PuzzleConfig to create a copy of.
	 */
	public PuzzleConfig(PuzzleConfig other){
		this.cursorX = other.cursorX;
		this.cursorY = other.cursorY;
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
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isGoal() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isValid() {
		// TODO Auto-generated method stub
		return false;
	}
	
	/**Returns the grid of this puzzle configuration.*/
	public byte[][] getGrid(){
		return this.grid;
	}

}
