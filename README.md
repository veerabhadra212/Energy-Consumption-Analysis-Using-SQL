
This project focuses on a comprehensive World Wide Energy Consumption Analysis using MySQL. It bridges the gap between raw global energy data and strategic policy insights by analyzing the interdependencies between energy production, consumption, carbon emissions, population, and economic growth (GDP).  

-- Project Structure

The repository contains the following core components:
- Energy Consumption Analysis.sql: Comprehensive SQL script containing database initialization and all analytical queries. 
- Energy Consumption.pptx: Presentation summarizing key findings, visualizations, and recommendations.  

-- Database Architecture

The analysis is built on a relational database schema designed for efficient cross-dimensional querying.  
- Entity-Relationship Diagram
- Table Descriptions
- 
The database consists of 6 primary tables:  
- country: Central dimension table containing unique country names and IDs (CID).  
- emission: Tracks carbon emissions and per-capita metrics by energy type and year.  
- population: Historical population data across various years.  
- production: Energy production volumes categorized by fuel type.  
- gdp: Economic output data (GDP) per country and year.  
- consumption: Energy usage metrics by type and country.

-- The Entity-Relationship Diagram as follows

<img width="434" height="331" alt="Energy Consumption ER" src="https://github.com/user-attachments/assets/a2e419cd-e9a7-4b60-b222-a2f05ddd0444" />


-- Project Objectives

Identify Performance Extremes: Pinpoint the highest and lowest performers in emissions, GDP, and energy usage for recent years.  
- Year-over-Year (YoY) Growth: Quantify global and national trends to identify acceleration or deceleration patterns.  
- Efficiency Ratios: Compute emission-to-GDP and consumption-to-GDP ratios to measure how efficiently economies convert energy into economic output.  
- Per Capita Benchmarking: Adjust raw totals by population for fair international comparisons.  
- Decoupling Analysis: Test the statistical relationship between economic growth and energy production growth.  

-- Key Insights & Queries

The project addresses several critical business and environmental questions through SQL: 
- Emissions Analysis: Calculating total emissions per country for the most recent year and identifying top contributors by energy type.  
- Economic Trends: Tracking GDP shifts and identifying the top 5 global economies.  
- Global Change Tracking: Utilizing window functions (e.g., LAG) to calculate global emission percentage changes year-over-year.  
- Sustainability Benchmarks: Identifying nations that have most successfully reduced their per-capita emissions over time. 
- Global Market Share: Determining each country's percentage share of total global emissions.  

-- Recommendations

-Enrich Data: Integrate new sources such as renewable energy percentages and trade flows to enhance the existing schema.  
- Predictive Modeling: Move beyond descriptive SQL into forecasting and machine learning to predict future energy needs.  
- Strategic Communication: Develop live dashboards to align technical findings with United Nations Sustainable Development Goals (SDGs).  

