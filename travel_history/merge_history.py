import pandas as pd

geo_locations = pd.read_csv("geo_coordinates.csv")
travel_log = pd.read_csv("travel_log.csv")

#Use right joins so any unmatched cities show up as "nan" in the output
joined_to_cities = pd.merge(geo_locations, travel_log,how="right",left_on="City", right_on="To")
joined_to_and_from_cities = pd.merge(geo_locations, joined_to_cities,how="right",left_on="City", right_on="From")

joined_to_and_from_cities['desired_travel_record_string'] = "{type: \"LineString\", coordinates: [[" + \
    + joined_to_and_from_cities['Long_x'].map(str)  \
    + "," + joined_to_and_from_cities["Lat_x"].map(str) + "], [" + \
    joined_to_and_from_cities["Long_y"].map(str) + "," + \
    joined_to_and_from_cities["Lat_y"].map(str) + "]]}," + \
    "// From: " + joined_to_and_from_cities["From"].map(str) + \
    " To: " + joined_to_and_from_cities["To"].map(str) 
        

#Just delete the last comma and any annoying quotes, this is a one-off

joined_to_and_from_cities.sort_values(by="Approx_Date_x")

joined_to_and_from_cities["desired_travel_record_string"].to_csv("pandas_output_travel_record.csv", index=False)