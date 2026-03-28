// 24/03/26: Jayden, Flights class
class Flights {
  ArrayList<Flight> flights = new ArrayList<Flight>();
  
  Flights(Table data) {
    // Parse flights
    for (TableRow row : data.rows()) {
      try {
        int fl_date = row.getInt("FL_DATE");
        String carrier = row.getString("MKT_CARRIER");
        int flight_num = row.getInt("MKT_CARRIER_FL_NUM");
        String origin = row.getString("ORIGIN");
        String origin_city = row.getString("ORIGIN_CITY_NAME");
        String origin_state = row.getString("ORIGIN_STATE_ABR");
        int origin_wac = row.getInt("ORIGIN_WAC");
        String dest = row.getString("DEST");
        String dest_city = row.getString("DEST_CITY_NAME");
        String dest_state = row.getString("DEST_STATE_ABR");
        int dest_wac = row.getInt("DEST_WAC");
        int crs_dep = row.getInt("CRS_DEP_TIME");
        int dep_time = row.getInt("DEP_TIME");
        int crs_arr = row.getInt("CRS_ARR_TIME");
        int arr_time = row.getInt("ARR_TIME");
        boolean cancelled = row.getInt("CANCELLED") == 1;
        boolean diverted = row.getInt("DIVERTED") == 1;
        int distance = row.getInt("DISTANCE");
        
        Flight f = new Flight(fl_date, carrier, flight_num, origin, origin_city, 
                             origin_state, origin_wac, dest, dest_city, dest_state, 
                             dest_wac, crs_dep, dep_time, crs_arr, arr_time, 
                             cancelled, diverted, distance);
        this.flights.add(f);
      } catch (Exception e) {
        println("Error parsing row: " + e.getMessage());
      }
    }
    
    println(this.flights.size() + " flights");
  }
  
  
  HashMap<String, Integer> countByOriginCity(ArrayList<Flight> flightsList) {
    HashMap<String, Integer> counts = new HashMap<String, Integer>();
    
    for (Flight flight : flightsList) {
      String key = flight.ORIGIN_CITY_NAME;
      incrementCount(counts, key);
    }
    
    return counts;
  }
  
  HashMap<String, Integer> countByDestinationCity(ArrayList<Flight> flightList) {
    HashMap<String, Integer> counts = new HashMap<String, Integer>();
    
    for (Flight flight : flightList) {
      String key = flight.DEST_CITY_NAME;
      incrementCount(counts, key);
    }
    
    return counts;
  }
  
  HashMap<String, Integer> countByCarrier(ArrayList<Flight> flightList) {
    HashMap<String, Integer> counts = new HashMap<String, Integer>();
    
    for (Flight flight : flightList) {
      String key = flight.MKT_CARRIER;
      incrementCount(counts, key);
    }
    
    return counts;
  }
  
  HashMap<String, Integer> countByCancellation(ArrayList<Flight> flightList) {
    HashMap<String, Integer> counts = new HashMap<String, Integer>();
    counts.put("Cancelled", 0);
    counts.put("Not Cancelled", 0);
    
    for (Flight flight : flightList) {
      if (flight.CANCELLED) {
        counts.put("Cancelled", counts.get("Cancelled") + 1);
      } else {
        counts.put("Not Cancelled", counts.get("Not Cancelled") + 1);
      }
    }
    
    return counts;
  }
  
  HashMap<String, Integer> countByDiversions(ArrayList<Flight> flightList) {
    HashMap<String, Integer> counts = new HashMap<String, Integer>();
    counts.put("Diverted", 0);
    counts.put("Not Diverted", 0);
    
    for (Flight flight : flightList) {
      if (flight.DIVERTED) {
        counts.put("Diverted", counts.get("Diverted") + 1);
      } else {
        counts.put("Not Diverted", counts.get("Not Diverted") + 1);
      }
    }
    
    return counts;
  }
  
  void incrementCount(HashMap<String, Integer> map, String key) {
    if (map.containsKey(key)) {
      map.put(key, map.get(key) + 1);
    } else {
      map.put(key, 1);
    }
  }
  
  int getMaxDistance(ArrayList<Flight> flightsList) {
    ArrayList<Flight> sorted = new ArrayList<Flight>(flightsList);
    
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return b.DISTANCE - a.DISTANCE;
      }
    });
    
    return sorted.get(0).DISTANCE;
  }
  
  int getMinDistance(ArrayList<Flight> flightList) {
    ArrayList<Flight> sorted = new ArrayList<Flight>(flightList);
    
    Collections.sort(sorted, new Comparator<Flight>() {
      public int compare(Flight a, Flight b) {
        return a.DISTANCE - b.DISTANCE;
      }
    });
    
    return sorted.get(0).DISTANCE;
  }
  
  
  // Sorting methods
  ArrayList<String> sortKeysDescending(HashMap<String, Integer> map) {
    ArrayList<String> keys = new ArrayList<String>(map.keySet());
    
    Collections.sort(keys, new Comparator<String>() {
      public int compare(String a, String b) {
        return map.get(b) - map.get(a);
      }
    });
    
    return keys;
  }
  
  ArrayList<String> sortKeysAscending(HashMap<String, Integer> map) {
    ArrayList<String> keys = new ArrayList<String>(map.keySet());
    
    Collections.sort(keys, new Comparator<String>() {
      public int compare(String a, String b) {
        return map.get(a) - map.get(b);
      }
    });
    
    return keys;
  }
  
  
  ChartData topNOrigins(ArrayList<Flight> flightList, int n) {
    HashMap<String, Integer> counts = countByOriginCity(flightList);
    ArrayList<String> sorted = sortKeysDescending(counts);
    return buildChartData(counts, sorted, n);
  }
  
  ChartData bottomNOrigins(ArrayList<Flight> flightList, int n) {
    HashMap<String, Integer> counts = countByOriginCity(flightList);
    ArrayList<String> sorted = sortKeysAscending(counts);
    return buildChartData(counts, sorted, n);
  }
  
  ChartData topNDestinations(ArrayList<Flight> flightList, int n) {
    HashMap<String, Integer> counts = countByDestinationCity(flightList);
    ArrayList<String> sorted = sortKeysDescending(counts);
    return buildChartData(counts, sorted, n);
  }
  
  ChartData bottomNDestinations(ArrayList<Flight> flightList, int n) {
    HashMap<String, Integer> counts = countByDestinationCity(flightList);
    ArrayList<String> sorted = sortKeysAscending(counts);
    return buildChartData(counts, sorted, n);
  }
  
  ChartData topNCarriers(ArrayList<Flight> flightList, int n) {
    HashMap<String, Integer> counts = countByCarrier(flightList);
    ArrayList<String> sorted = sortKeysDescending(counts);
    return buildChartData(counts, sorted, n);
  }
  
  ChartData cancellationData(ArrayList<Flight> flightList) {
    HashMap<String, Integer> counts = countByCancellation(flightList);
    ArrayList<String> sorted = sortKeysDescending(counts);
    return buildChartData(counts, sorted, 2);
  }
  
  ChartData diversionData(ArrayList<Flight> flightList) {
    HashMap<String, Integer> counts = countByDiversions(flightList);
    ArrayList<String> sorted = sortKeysDescending(counts);
    return buildChartData(counts, sorted, 2);
  }
  
  
  // Helper functions
  ArrayList<Flight> filterByDistance(ArrayList<Flight> flightsList, float minDistance, float maxDistance) {
    ArrayList<Flight> filtered = new ArrayList<Flight>();
    
    for (Flight flight : flightsList) {
      if (flight.DISTANCE >= minDistance && flight.DISTANCE <= maxDistance) {
        filtered.add(flight);
      }
    }
    
    return filtered;
  }
  
  ChartData buildChartData(HashMap<String, Integer> map, ArrayList<String> keys, int n) {
    int size = min(n, keys.size());
    
    String[] labels = new String[size];
    float[] values = new float[size];
    
    for (int i = 0; i < size; i++) {
      labels[i] = keys.get(i);
      values[i] = map.get(keys.get(i));
    }
    
    return new ChartData(labels, values);
  }
}
