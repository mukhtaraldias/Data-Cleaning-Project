# 🏠 Nashville Housing Data Cleaning Project

## 🎯 Project Overview
A SQL-based data cleaning pipeline for standardizing and enriching raw housing data. Key tasks include:
- **Date standardization** (`SaleDate` → ISO format)
- **Address population** (Filling `NULL` values via self-join)
- **Address parsing** (Split `PropertyAddress` into street/city)
- **Data deduplication** (CTE with `ROW_NUMBER()`)
- **Column cleanup** (Removing obsolete fields)

## 🚀 How to Use
1. **Restore the dataset** using `Raw Nashvile Housing Data.csv`.
2. Run the **single SQL script**:
   ```sql
   -- Execute entire script in order
   EXEC CleanData.sql;
3. Query the cleaned table Housing for analysis.

## 💡 Technical Highlights
- Self-Join for NULL Handling:
	UPDATE Old
	SET PropertyAddress = ISNULL(Old.PropertyAddress, New.PropertyAddress)
	FROM Housing Old
	JOIN Housing New ON Old.ParcelID = New.ParcelID
- PARSENAME() for Address Splitting:
Extracts city/state using string replacement and parsing.
- Deduplication Logic:
Uses ROW_NUMBER() with PARTITION BY to flag duplicates.

##  Deduplication Strategy
CTE with ROW_NUMBER() identifies duplicates based on:
	PARTITION BY ParcelID, SalePrice, LegalReference
Deletes rows where row_num > 1, retaining the first occurrence.

##  Edge Cases
NULL ParcelID: Assumed invalid and excluded during joins.
Mixed date formats: Handled via CONVERT(Date, SaleDate).