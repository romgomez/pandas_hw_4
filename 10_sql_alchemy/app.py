#Step 2: Climate App 

# Import dependencies
import os
import datetime as dt
import numpy as np
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from flask import Flask,jsonify


# Create engine
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()

# reflect the tables
Base.prepare(engine, reflect=True)

# We can view all of the classes that automap found
Base.classes.keys()

# Save references to each table
Measurement = Base.classes.measurement
Stations = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

# Initiate flask app
app = Flask(__name__)


# Create home page and list all available routes
@app.route("/")
def home():
    return """

        Available Routes: </a><br/>
        <a href="/api/v1.0/precipitation">Precipitation</a><br/>
        <a href="/api/v1.0/stations">Stations</a></br>
        <a href="/api/v1.0/tobs">Tobs</a></br>
        <a href="/api/v1.0/<start_date>">Start Date</a></br>
        <a href="/api/v1.0/<start_date>/<end_date>">Start Date/End Date</a></br>

        """

# Query for the precipiation oata in the last year and order results by date
@app.route("/api/v1.0/precipitation")
def precipitation():
    last_year = dt.date(2017,8,23) - dt.timedelta(days=365)
    results = session.query(Measurement.date, Measurement.prcp).\
    filter(Measurement.date > last_year).\
    order_by(Measurement.date).all()
    
    precipitation = []
    for day in results:
        prcp_data = {}
        prcp_data["date"] = results[0]
        prcp_data ["prcp"] = results[1]
        precipitation.append(prcp_data)
        
    return jsonify(precipitation)
    

# Query all of the stations (station code) and stations names in the dataset
@app.route("/api/v1.0/stations")
def station():
    results = session.query(Stations.station,Stations.name).all()
    all_stations = []
    
    for station in results:
        all_stations.append(station)

    return jsonify(all_stations)


# Query for the temperature observations in the last year and order results by date
@app.route("/api/v1.0/tobs")
def tobs():
    last_year = dt.date(2017, 8, 23) - dt.timedelta(days=365)
    temp_year = session.query(Measurement.date, Measurement.tobs).\
        filter(Measurement.date > last_year).\
        order_by(Measurement.date).all()
    
    
    temperature = []
    for t in temp_year:
        temp_data = {}
        temp_data["date"] = t.date
        temp_data["tobs"] = t.tobs
        temperature.append(temp_data)

    return jsonify(temperature)

# # Calculate min temp, max temp, and avg temp for all dates from a given start date 
@app.route("/api/v1.0/<start_date>")
def start_date(start_date):
        start_date = dt.date(2017,8,23) - dt.timedelta(days=365)
        temp_stats = [func.min(Measurement.tobs),func.max(Measurement.tobs),func.avg(Measurement.tobs)]
        temp_start_date = session.query(*temp_stats).\
        filter(Measurement.date > start_date).all()
        
        return jsonify(temp_start_date)

# # Calculate min temp, max temp, and avg temp for all dates within a provided start and end date
@app.route("/api/v1.0/<start_date>/<end_date>")
def calc_temps(start_date,end_date):

        end_date = dt.date(2017, 8, 23)
        start_date = end_date - dt.timedelta(days=365)

        temp_stats = [func.min(Measurement.tobs),func.max(Measurement.tobs),func.avg(Measurement.tobs)]
        temp_start_end = session.query(*temp_stats).\
        filter(Measurement.date > start_date).\
        filter(Measurement.date < end_date).all()
        
        return jsonify(temp_start_end)


if __name__ == '__main__':
    app.run(debug=True)