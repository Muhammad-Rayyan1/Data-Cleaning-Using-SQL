# Data Cleaning and Transformation(Laptops_Dataset)

This project demonstrates the process of cleaning and transforming a laptop dataset using MySQL. The original uncleaned dataset is cleaned through a series of SQL queries, and the cleaned data is prepared for analysis.

## Project Overview

The primary focus of this project is to clean and standardize a raw dataset containing laptop specifications. After the cleaning process, the dataset is well-structured and optimized for further analysis.

### Key Operations:
- **Data Backup:** Initial backup of the raw dataset.
- **Null Value Handling:** Rows with missing values in key fields are removed.
- **Data Standardization:** Consistent formatting for CPU, GPU, screen resolution, and memory details.
- **Data Transformation:** Splitting combined columns and extracting useful information (e.g., CPU/GPU brand, resolution dimensions).
- **Unit Conversion:** Convert values like RAM, weight, and storage from textual to numerical formats.

## Files in this Repository

- **`laptopdata(uncleaned).csv`**: The original uncleaned laptop dataset.
- **`laptopdata(cleaned).csv`**: The cleaned and transformed version of the dataset after applying all the SQL queries.
- **`data_cleaning.sql`**: The SQL script containing all the queries used for data cleaning and transformation.

## Dataset Features

The dataset contains various features for each laptop, including:

- **Company**: Manufacturer of the laptop.
- **Type**: Category of the laptop (e.g., Ultrabook, Gaming).
- **Inches**: Screen size in inches.
- **Screen Resolution**: Display resolution (width x height).
- **Touchscreen**: Whether the laptop has a touchscreen or not.
- **CPU**: Processor details (brand, name, and speed).
- **GPU**: Graphics card details (brand and name).
- **RAM**: Memory capacity in GB.
- **Storage**: Primary and secondary storage capacity (in GB or TB).
- **Operating System**: Installed operating system (OS).
- **Weight**: Weight of the laptop in kilograms.
- **Price**: Price of the laptop in USD.

## Project Workflow

1. **Initial Data Inspection**: Review the uncleaned dataset (`laptopdata(uncleaned).csv`).
2. **Data Backup**: Backup the original dataset.
3. **Data Cleaning**:
    - Remove rows with missing data in critical fields.
    - Standardize column names and data formats.
4. **Data Transformation**:
    - Extract and clean CPU and GPU details.
    - Split screen resolution into width and height.
    - Detect laptops with touchscreens.
    - Separate storage types (HDD, SSD) and convert values.
5. **Final Data Output**: Export the cleaned data to `laptopdata(cleaned).csv`.

## How to Use This Repository

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/laptop-data-cleaning-and-transformation.git

2. **View the Dataset**:
   - Inspect the raw dataset in `laptopdata(uncleaned).csv`.

3. **Run the SQL Queries**:
   - The `data_cleaning.sql` file contains all the SQL queries used for cleaning and transforming the dataset.
   - Execute these queries step by step in MySQL Workbench or any other SQL tool.

4. **Review the Cleaned Dataset**:
   - After running the queries, review the cleaned dataset in `laptopdata(cleaned).csv`.

## Folder Structure

├── README.md                    # Project documentation
├── laptopdata(uncleaned).csv     # Raw uncleaned laptop data
├── laptopdata(cleaned).csv       # Cleaned and transformed laptop data
├── data_cleaning.sql             # SQL queries for data cleaning and transformation

## Technologies Used

- **MySQL**: All data cleaning and transformation steps are performed using MySQL queries.
- **CSV**: The dataset is stored in CSV format for easy data manipulation and inspection.
