import java.util.List;

public interface Configuration {
	/**
	 * Gets the successors for this configuration.
	 * Used in backtracking.
	 * @return A list of configurations, valid or not.
	 */
	public List<Configuration> getSuccessors();
	
	/**
	 * Gets if this configuration is the goal, that is
	 * a solution to the backtracking.
	 * @return A boolean value that is if this is the goal.
	 */
	public boolean isGoal();
	
	/**
	 * Gets if this configuration is valid, that is
	 * if this configuration does not break any rules.
	 * @return A boolean value that is if this is a valid configuration.
	 */
	public boolean isValid();
}
