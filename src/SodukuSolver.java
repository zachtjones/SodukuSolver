import javafx.application.Application;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.control.Button;
import javafx.scene.layout.AnchorPane;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.stage.Stage;

public class SodukuSolver extends Application implements InvalidationListener {

	private Puzzle p;
	private Canvas c;
	private int selectedRow = 0;
	private int selectedCol = 0;
	
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
		scene.setOnKeyPressed(event -> {
			switch(event.getCode()){
			//top ones
			case A:selectedCol = 0;break;
			case B:selectedCol = 1;break;
			case C:selectedCol = 2;break;
			case D:selectedCol = 3;break;
			case E:selectedCol = 4;break;
			case F:selectedCol = 5;break;
			case G:selectedCol = 6;break;
			case H:selectedCol = 7;break;
			case I:selectedCol = 8;break;
			//left ones
			case J:selectedRow = 0;break;
			case K:selectedRow = 1;break;
			case L:selectedRow = 2;break;
			case M:selectedRow = 3;break;
			case N:selectedRow = 4;break;
			case O:selectedRow = 5;break;
			case P:selectedRow = 6;break;
			case Q:selectedRow = 7;break;
			case R:selectedRow = 8;break;
			//numbers
			case DIGIT0:p.setValue(selectedRow, selectedCol, 0);break;
			case DIGIT1:p.setValue(selectedRow, selectedCol, 1);break;
			case DIGIT2:p.setValue(selectedRow, selectedCol, 2);break;
			case DIGIT3:p.setValue(selectedRow, selectedCol, 3);break;
			case DIGIT4:p.setValue(selectedRow, selectedCol, 4);break;
			case DIGIT5:p.setValue(selectedRow, selectedCol, 5);break;
			case DIGIT6:p.setValue(selectedRow, selectedCol, 6);break;
			case DIGIT7:p.setValue(selectedRow, selectedCol, 7);break;
			case DIGIT8:p.setValue(selectedRow, selectedCol, 8);break;
			case DIGIT9:p.setValue(selectedRow, selectedCol, 9);break;
			case NUMPAD0:p.setValue(selectedRow, selectedCol, 0);break;
			case NUMPAD1:p.setValue(selectedRow, selectedCol, 1);break;
			case NUMPAD2:p.setValue(selectedRow, selectedCol, 2);break;
			case NUMPAD3:p.setValue(selectedRow, selectedCol, 3);break;
			case NUMPAD4:p.setValue(selectedRow, selectedCol, 4);break;
			case NUMPAD5:p.setValue(selectedRow, selectedCol, 5);break;
			case NUMPAD6:p.setValue(selectedRow, selectedCol, 6);break;
			case NUMPAD7:p.setValue(selectedRow, selectedCol, 7);break;
			case NUMPAD8:p.setValue(selectedRow, selectedCol, 8);break;
			case NUMPAD9:p.setValue(selectedRow, selectedCol, 9);break;
			default:break;//don't need to do anything
			}
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
		gc.clearRect(0, 0, c.getWidth(), c.getHeight());

		gc.setFont(new Font("Courier New", 30));
		
		double colWidth = c.getWidth() / 10.0;
		double rowHeight = c.getHeight() / 10.0;
		
		//shade the selected row/col
		gc.setFill(Color.color(0.8, 0, 0, 0.4));
		gc.fillRect(0, (selectedRow + 1) * rowHeight, c.getWidth(), rowHeight);
		gc.fillRect((selectedCol + 1) * colWidth, 0, colWidth, c.getHeight());
		
		//draw the gridlines
		for(int i = 1; i < 10; i++){
			if(i % 3 == 1){
				//thicker lines - 3x3 boxes
				gc.setLineWidth(3.0); 
			} else {
				gc.setLineWidth(1.0);
			}
			gc.strokeLine(0, i*rowHeight, c.getWidth(), i*rowHeight);
			gc.strokeLine(i*colWidth, 0, i*colWidth, c.getHeight());
		}
		
		//draw the top letters
		for(int i = 0; i < 9; i++){
			char c = (char) (65 + i);
			gc.strokeText("" + c, (i+1)*colWidth + 5, 35);
		}
		//draw the left letters
		for(int i = 0; i < 9; i++){
			char c = (char)(74 + i);
			gc.strokeText("" + c, 25, (i+1)*rowHeight + 25);
		}
	}

}
