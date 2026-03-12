Table table;

void setup() {
  table = loadTable("flights2k.csv", "header");
  
  for (TableRow row : table.rows()) {
    String name = row.getString("ORIGIN_CITY_NAME");
    println(name);
  }
  
  size(800, 600);
}

void draw() {

}
