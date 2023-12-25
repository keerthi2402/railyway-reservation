-- Add or update railway station data with dummy values
CALL add_railway_station(
    in_name  => 'Chennai_Central',
    in_city  => 'Chennai',
    in_state => 'Tamil Nadu'
);

CALL add_railway_station('Jodhpur_Junction', 'Jodhpur', 'Rajasthan');
CALL add_railway_station('Ahmedabad_Station', 'Ahmedabad', 'Gujarat');
CALL add_railway_station('Hyderabad_Junction', 'Hyderabad', 'Telangana');
CALL add_railway_station('Kochi_Station', 'Kochi', 'Kerala');
CALL add_railway_station('Pune_Junction', 'Pune', 'Maharashtra');
CALL add_railway_station('Bhubaneswar_Station', 'Bhubaneswar', 'Odisha');
CALL add_railway_station('Amritsar_Junction', 'Amritsar', 'Punjab');
CALL add_railway_station('Guwahati_Station', 'Guwahati', 'Assam');
CALL add_railway_station('Udaipur_Junction', 'Udaipur', 'Rajasthan');
