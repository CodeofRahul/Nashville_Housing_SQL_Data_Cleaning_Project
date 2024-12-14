CREATE TABLE Nashville_Housing (
    UniqueID INT,
    ParcelID VARCHAR(30),
    LandUse VARCHAR(50),
    PropertyAddress VARCHAR(255),
    SaleDate DATE,
    SalePrice VARCHAR(50),
    LegalReference VARCHAR(50),
    SoldAsVacant VARCHAR(3),
    OwnerName VARCHAR(255),
    OwnerAddress VARCHAR(255),
    Acreage DECIMAL(5, 2),
    TaxDistrict VARCHAR(100),
    LandValue INT,
    BuildingValue INT,
    TotalValue INT,
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT,
	PRIMARY KEY (UniqueID)
);

---------------------------------------------------------------------------------------------------------------

-- Import Data in SQL

COPY Nashville_Housing(UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath)
FROM 'F:\SQL\Sql Data cleaning project\Nashville Housing.csv' 
DELIMITER ',' 
CSV HEADER;

----------------------------------------------------------------------------------------------------------------

-- Cleaning Data in SQL


Select count(*) from nashville_housing;

SELECT * FROM Nashville_housing;

------------------------------------------------------------------------------------------------------------

-- Standardize Data Format

Select saleprice From nashville_housing;

SELECT CAST(CAST(SalePrice AS NUMERIC) AS INTEGER) From Nashville_Housing;
-- or
SELECT SalePrice::NUMERIC::INTEGER From Nashville_Housing;

ALTER TABLE Nashville_Housing
Add SalePriceConverted INTEGER;

UPDATE Nashville_Housing
SET SalePriceConverted = SalePrice::NUMERIC::INTEGER;

------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From Nashville_Housing
-- Where propertyaddress is null
order by parcelid;


Select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, COALESCE(a.propertyaddress, b.propertyaddress)
From Nashville_Housing as a
join Nashville_Housing as b
	on a.parcelid = b.parcelid
	AND a.UniqueID <> b.UniqueID
Where a.propertyaddress is null;


update Nashville_Housing
SET propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
From Nashville_Housing as a
	join Nashville_Housing as b
	on a.parcelid = b.parcelid
AND a.UniqueID <> b.UniqueID
Where a.propertyaddress is null;

------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual columns (Address, City, State)

Select propertyaddress
From Nashville_Housing;


SELECT propertyaddress,
    SUBSTRING(propertyaddress FROM 1 FOR POSITION(',' IN propertyaddress) - 1) AS Address,
    SUBSTRING(propertyaddress FROM POSITION(',' IN propertyaddress) + 1) AS Address_Rest
FROM Nashville_Housing;


ALTER TABLE Nashville_Housing
ADD ProperySplitAddress varchar(255);


UPDATE Nashville_Housing
SET ProperySplitAddress = SUBSTRING(propertyaddress FROM 1 FOR POSITION(',' IN propertyaddress) - 1)


ALTER TABLE Nashville_Housing
ADD PropertySplitCity varchar(255);


UPDATE Nashville_Housing
SET PropertySplitCity = SUBSTRING(propertyaddress FROM POSITION(',' IN propertyaddress) + 1)

Select * from Nashville_Housing

------------------------------------------------------------------------------------------------------------

Select owneraddress from Nashville_Housing;


SELECT 
    SPLIT_PART(OwnerAddress, ',', 1) AS Part1,
    SPLIT_PART(OwnerAddress, ',', 2) AS Part2,
    SPLIT_PART(OwnerAddress, ',', 3) AS Part3
FROM Nashville_Housing;


ALTER TABLE Nashville_Housing
ADD OwnerSplitAddress varchar(255);

UPDATE Nashville_Housing
SET OwnerSplitAddress = SPLIT_PART(OwnerAddress, ',', 3)


ALTER TABLE Nashville_Housing
ADD OwnerSplitCity varchar(255);


UPDATE Nashville_Housing
SET OwnerSplitCity = SPLIT_PART(OwnerAddress, ',', 2)


ALTER TABLE Nashville_Housing
ADD OwnerSplitState varchar(255);


UPDATE Nashville_Housing
SET OwnerSplitState = SPLIT_PART(OwnerAddress, ',', 1)


Select * From Nashville_Housing;


-----------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No "Sold as Vacant" field

Select Distinct(SoldasVacant), Count(SoldAsVacant)
From Nashville_Housing
Group by SoldAsVacant
Order by 2;


Select SoldAsVacant,
	CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END
From Nashville_Housing;


Update Nashville_Housing
	SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END


-----------------------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumCTE AS(
	Select *,
	Row_NUMBER() OVER(
	PARTITION BY Parcelid, PropertyAddress, SalePrice, SaleDate, LegalReference
	Order By Uniqueid
	) as row_num
	From Nashville_Housing
	-- order by Parcelid
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Nashville_Housing


-----------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From Nashville_Housing


ALTER TABLE Nashville_Housing
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;






