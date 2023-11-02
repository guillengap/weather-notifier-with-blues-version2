% Aurhor: Guillermo Perez Guillen

channelID = 2326612
%alert_body = 'Successful email with ThingSpeak';
alert_subject = 'What is the weather like today?';
alert_api_key = 'TAKpzSli9EwIRptu9CQ'; 
alert_url = "https://api.thingspeak.com/alerts/send";

% Read the recent data.
temperatureData = thingSpeakRead(channelID,'NumDays',1,'Fields',1);
humidityData = thingSpeakRead(channelID,'NumDays',1,'Fields',2);
co2Data = thingSpeakRead(channelID,'NumDays',1,'Fields',3);
tvocData = thingSpeakRead(channelID,'NumDays',1,'Fields',4);

% Check to make sure the data was read correctly from the channel.

if (temperatureData > 27) & (humidityData < 70) & (co2Data < 550) & (tvocData < 600);
    alertBody = "It's gonna be a sunny day and good air quality!";    

elseif (temperatureData > 27) & (humidityData < 70) & ((co2Data > 550) | (tvocData > 600));
    alertBody = "It's gonna be a sunny day and bad air quality!";        
    
elseif (temperatureData < 27) & (humidityData > 70) & (co2Data < 550) & (tvocData < 600);
    alertBody = "It's gonna be a rainy day and good air quality!";  

elseif (temperatureData < 27) & (humidityData > 70) & ((co2Data > 550) | (tvocData > 600));
    alertBody = "It's gonna be a rainy day and bad air quality!";      
    
elseif (co2Data < 550) & (tvocData < 600); 
    alertBody = "It's gonna be a cloudy day and good air quality!";
   
else
    alertBody = "It's gonna be a cloudy day and bad air quality!";
    
end

jsonmessage = sprintf(['{"subject": "%s", "body": "%s"}'], alert_subject, alertBody);
options = weboptions("HeaderFields", {'Thingspeak-Alerts-API-Key', alert_api_key; 'Content-Type','application/json'});
result = webwrite(alert_url, jsonmessage, options); 