import javafx.application.Application;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.control.Button;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;

public class SodukuSolver extends Application implements InvalidationListener {

	private Puzzle p;
	private Canvas c;
	
	public static void main(String[] args) {
		// launch the application
		Application.launch(args);
	}

	

	@Override
	public void start(Stage primaryStage) throws Exception {
		//initialize the model
		p = new Puzzle();
		p.addListener(this);
		
		AnchorPane ap = new AnchorPane();
		ap.setPrefSize(500, 550);
		c = new Canvas(500, 500);
		c.setLayoutY(50);
		ap.getChildren().add(c);
		
		//clear button
		Button clear = new Button("Clear");
		clear.setLayoutX(5);
		clear.setLayoutY(5);
		clear.setPrefSize(100, 30);
		clear.setOnAction(event -> {
			p.clear();
		});
		ap.getChildren().add(clear);
		
		//solve button
		Button solve = new Button("Solve");
		solve.setLayoutX(110);
		solve.setLayoutY(5);
		solve.setPrefSize(100, 30);
		ap.getChildren().add(solve);
		
		Scene scene = new Scene(ap);
		//set the resize
		scene.widthProperty().addListener((observable, oldValue, newValue) -> {
			ap.getChildren().remove(c);
			c = new Canvas(ap.getWidth(), c.getHeight());
			c.setLayoutY(50);
			ap.getChildren().add(c);
			invalidated(p);
		});
		scene.heightProperty().addListener((observale, oldValue, newValue) -> {
			ap.getChildren().remove(c);
			c = new Canvas(c.getWidth(), ap.getHeight() - 50);
			c.setLayoutY(50);
			ap.getChildren().add(c);
			invalidated(p);
		});
		primaryStage.setScene(scene);
		primaryStage.setTitle("Soduku Solver");
		primaryStage.setMinWidth(500);
		primaryStage.setMinHeight(500);
		primaryStage.show();
	}



	@Override
	public void invalidated(Observable observable) {
		// draw the board.
		GraphicsContext gc = c.getGraphicsContext2D();
		//temp-draws a diagonal
		gc.clearRect(0, 0, c.getWidth(), c.getHeight());
		gc.strokeLine(0, 0, c.getWidth(), c.getHeight());
		gc.strokeLine(0, c.getHeight(), c.getWidth(), 0);
	}

}
