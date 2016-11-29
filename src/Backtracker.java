
public class Backtracker {
	
	/**
	 * Uses backtracking to solve the configuration passed.
	 * @param c The configuration to solve.
	 * @return The configuration that is the solution, or null
	 * if there is no solution
	 */
	public static Configuration solve(Configuration c){
		
		if(c.isGoal()){
			return c; //done, found the solution
		} else {
			// go through the successors
			for(Configuration child : c.getSuccessors()){
				//only continue through valid successors
				if(child.isValid()){
					Configuration result = solve(child);
					//if the result is not null, then return that configuration
					if(result != null){ return result; }
				}
			}
		}
		//no solution found as any child of the Configuration c, 
		//so return null
		return null;
	}
}
