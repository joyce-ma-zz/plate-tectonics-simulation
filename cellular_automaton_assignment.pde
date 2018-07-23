int[][] cellsNow;
int[][] cellsNext;
int[][] cellsH;
int[][] cellsVolcano;
int density1 = 1;
int density2 = 2;
int n = 20;
float cellSize;
float padding = 50;
float blinksPerSecond = 5;
int aliveNeighbours;
String mode = "cco";

void setup() {
  size(600, 600);
  cellSize = (width-2*padding)/n;
  cellsNow = new int[n][n];
  cellsNext = new int[n][n];
  cellsH = new int[n][n];
  cellsVolcano = new int[n][n];
  frameRate( blinksPerSecond );
  setCellValuesRandomly();
}

void draw() {
  getCellValues();
  background(0, 0, 255);
  float y = padding;
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      float x = padding + j*cellSize;
      if (cellsH[i][j] >= 0) {
        if (cellsVolcano[i][j] == 1 && cellsH[i][j] > 150)
          fill(100, 0, 0);
        else if (cellsH[i][j] < 100){
          fill(100 + cellsH[i][j], 100 + cellsH[i][j], 100 + cellsH[i][j]);
        }
        else
          fill(200, 200, 200);
      } else if (cellsH[i][j] < 0) {
        if (cellsH[i][j] > -80){
          fill(100 + cellsH[i][j], 200 + cellsH[i][j], 200);
        } 
        else
          fill(20, 120, 200);
      }
      rect(x, y, cellSize, cellSize);
    }
    y += cellSize;
  }
  update();
}


void getCellValues() {
  for (int i = 0; i <= n-1; i++) {   //For each row...
    for (int j = 0; j <= n-1; j++) {   //For each column in the current row...
      aliveNeighbours = countLivingNeighbours(i, j);  //We’ll code this function later
      if (mode == "cco") {
        if (density1 < density2) {
          if (cellsNow[ i + cellsNow[i][j] ][j] < cellsNow[i][j]) {
            cellsH[ i - cellsNow[i][j] ][j] += round(random(5));
            cellsNext[i][j] = cellsNow[ i - cellsNow[i][j] ][j];
          } else if (cellsNow[ i + cellsNow[i][j] ][j] > cellsNow[i][j]) {
            cellsH[ i - cellsNow[i][j] ][j] -= 4;
            cellsNext[i][j] = cellsNow[ i - cellsNow[i][j] ][j];
          } else {
            cellsNext[i][j] = cellsNow[i][j];
          }
        }
      }
      else if (mode == "cdc") {
        if (i <= n/2)  
          cellsH[i][j] -= abs(0 - i)/2;  
        else if (i > n/2)
          cellsH[i][j] -= abs(n - i)/2;  
        cellsNext[i][j] = cellsNow[i][j];
      }
      else if (mode == "oco"){
        if (i <= n/2)  
          cellsH[i][j] += abs(0 - i);  
        else if (i > n/2)
          cellsH[i][j] += abs(n - i);  
        cellsNext[i][j] = cellsNow[i][j];
      }
      
    }
  }
}

int countLivingNeighbours(int i, int j) {
  int livingNeighbours = 0;
  int[] range = new int[2];
  if (cellsNow[i][j] == 1) {
    range[0] = 0;
    range[1] = 1;
  } else if (cellsNow[i][j] == -1) {
    range[0] = -1;
    range[1] = 0;
  } else {
    range[0] = -1;
    range[1] = 1;
  }
  for (int x = range[0]; x <= range[1]; x++) {
    for (int y = -1; y <= 1; y++) {
      try { 
        if (cellsNow[x + i][y + j] > 0 && (x != 0 || y != 0))
          livingNeighbours ++;
      }
      catch (Exception e) {
      }
    }
  }
  return livingNeighbours;
}

void setCellValuesRandomly() {
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {  
      if (i < n/2) {
        cellsNow[i][j] = 1;
      } else {
        cellsNow[i][j] = -1;
      }
      if (mode == "cco") {
        if (i < n/2) {
          cellsH[i][j] = 100;
        } else {
          cellsH[i][j] = -100;
        }
      }
      if (mode == "cdc") {
        cellsH[i][j] = 100;
      }
      if (mode == "oco") {
        cellsH[i][j] = -100;
      }
    }
  }
  for (int i=0; i<n; i++){
    for (int j=0; j<n; j++) {
      cellsVolcano[i][j] = round(random(0, 10));
    }
  }
}

void update() {
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      cellsNow[i][j] = cellsNext[i][j];
    }
  }
}