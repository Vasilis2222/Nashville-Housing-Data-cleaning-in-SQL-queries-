/*

Cleaning Data in SQL Quaries

*/


SELECT *
FROM Nashville.dbo.NashvilleHousing


-----------------------------------------------------------------------

-- Standarize Date Format


SELECT SaleDateConverted, CONVERT(date,SaleDate)
FROM Nashville.dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(Date, Saledate)







-----------------------------------------------------------------------

-- Populate Property Address data

select *
From Nashville.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
order by ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null








------------------------------------------------------------------------

-- Breaking out Address into Individual Columns ( Address, City, State)


Select PropertyAddress
From Nashville.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From Nashville.DBO.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



SELECT *
FROM Nashville.dbo.NashvilleHousing





SELECT OwnerAddress
FROM Nashville.dbo.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Nashville.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



SELECT *
FROM Nashville.dbo.NashvilleHousing











-------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Nashville.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2





Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM Nashville.dbo.NashvilleHousing



Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
                        WHEN SoldAsVacant = 'N' THEN 'NO'
						ELSE SoldAsVacant
						END





--------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				     UniqueID
					 ) row_num
FROM Nashville.dbo.NashvilleHousing
--ORDER BY ParcelID
)
select *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


SELECT *
FROM Nashville.dbo.NashvilleHousing




---------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
FROM Nashville.dbo.NashvilleHousing


ALTER TABLE Nashville.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Nashville.dbo.NashvilleHousing
DROP COLUMN SaleDate
