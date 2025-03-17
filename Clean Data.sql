SELECT *
FROM NashvileHousingCleningData..Housing

-- Date Format
ALTER TABLE Housing
Add SaleDates Date;

Update Housing
SET SaleDates = CONVERT(Date,SaleDate)

Select saleDates, CONVERT(Date,SaleDate)
From NashvileHousingCleningData..Housing


-- Populate the PropertyAddress
Select *
From NashvileHousingCleningData..Housing
Where PropertyAddress is null
order by ParcelID

Select Old.ParcelID, Old.PropertyAddress, New.ParcelID, New.PropertyAddress, ISNULL(Old.PropertyAddress,New.PropertyAddress)
From NashvileHousingCleningData..Housing Old
JOIN NashvileHousingCleningData..Housing New
	on Old.ParcelID = New.ParcelID
	AND Old.[UniqueID ] <> New.[UniqueID ]
Where Old.PropertyAddress is null

Update Old
SET PropertyAddress = ISNULL(Old.PropertyAddress,New.PropertyAddress)
From NashvileHousingCleningData..Housing Old
JOIN NashvileHousingCleningData..Housing New
	on Old.ParcelID = New.ParcelID
	AND Old.[UniqueID ] <> New.[UniqueID ]
Where Old.PropertyAddress is null


-- Splitt the Address (Address, City, State)
ALTER TABLE Housing
Add PropertySplitAddress Nvarchar(255);

ALTER TABLE Housing
Add PropertySplitCity Nvarchar(255);


Select
PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2)
,PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)
From NashvileHousingCleningData..Housing

Update Housing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2)

Update Housing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 1)


ALTER TABLE Housing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE Housing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE Housing
Add OwnerSplitState Nvarchar(255);


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvileHousingCleningData..Housing


Update Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Update Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



-- Match the answers on SoldAsVacant
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvileHousingCleningData..Housing
Group by SoldAsVacant
order by 2

Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From NashvileHousingCleningData..Housing
)

DELETE
From RowNumCTE
Where row_num > 1



-- Remove Unused Colomn
ALTER TABLE NashvileHousingCleningData..Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


