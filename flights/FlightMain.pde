Table table;

int x = 0;
int y = 0;

void setup() {
  table = loadTable("flights2k.csv", "header");
  
  for (TableRow row : table.rows()) {
    String name = row.getString("ORIGIN_CITY_NAME");
    println(name);
    
    fill(0);
    text(name, x, y);

    y += 15;
  }
  
  size(800, 600);
}

void draw() {

}
