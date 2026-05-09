# Energy-Consumption-Analysis-Using-SQL
# World Wide Energy Consumption - SQL Data Analysis Project

## Project Overview
This project explores global energy trends using data sourced from the U.S. Energy Information Administration (EIA), which tracks energy consumption, emissions, production, and population metrics across various countries. The primary objective is to build a structured relational database and execute complex SQL queries to uncover correlations between a country's economic power, energy usage, and environmental impact.

## Database Architecture
The project utilizes a MySQL database named `ENERGYDB2`, structured with a central dimension table and several related tables.

### Schema Summary:
* **`country`**: The central table containing unique country identifiers.
* **`emission_3`**: Tracks carbon emissions and per capita emissions by year and energy type.
* **`population`**: Records historical population data by country and year.
* **`production`**: Logs energy production volumes by type and year.
* **`gdp_3`**: Contains GDP values over time.
* **`consumption`**: Details energy consumption metrics by type and year.

<img width="434" height="331" alt="Energy Consumption ER" src="https://github.com/user-attachments/assets/9d7742bc-fca0-4832-8694-614f9fe52259" />


All secondary tables maintain a `1-to-Many` relationship with the central `country` table via Foreign Keys referencing the `Country` column.

## Setup Instructions
To replicate this project locally, follow these steps in your MySQL environment:

1. **Initialize Database**:
   ```sql
   CREATE DATABASE ENERGYDB;
   USE ENERGYDB;
