

Select*
From PortfolioProject.dbo.NashvilleHousing




--lets change the date format. Adding another column SaleDateConverted

Select SaleDateConverted, CONVERT(date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date,SaleDate);



-- lets  populate property address data


Select A.ParcelID,A.PropertyAddress, B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing A
JOIN PortfolioProject.dbo.NashvilleHousing B
	on A.ParcelID=B.ParcelID
	AND A.[UniqueID ]<> B.[UniqueID ]
Where A.PropertyAddress is null


Update A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing A
JOIN PortfolioProject.dbo.NashvilleHousing B
	on A.ParcelID=B.ParcelID
	AND A.[UniqueID ]<> B.[UniqueID ]
Where A.PropertyAddress is null


-- lets breakout the address into induvidual colums.

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing


Select 
SUBSTRING(Propertyaddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(Propertyaddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(Propertyaddress, 1,CHARINDEX(',',PropertyAddress)-1) 



ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress))




select PropertySplitCity,PropertySplitAddress,PropertyAddress
from PortfolioProject.dbo.NashvilleHousing


-- Lets do the same to owner address

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
 PARSENAME(REPLACE(OwnerAddress,',','.'),2),
 PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)




select OwnerSplitState,OwnerSplitCity,OwnerSplitAddress
from PortfolioProject.dbo.NashvilleHousing





-- Let's change Y and N to Yes and No in SoldAsVacant



Select Distinct(SoldAsVacant),COUNT(SoldAsVacant) AS TotalNumbers
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by TotalNumbers




Select SoldAsVacant, 
Case 
	When SoldAsVacant = 'Y' Then 'YES'
	When SoldAsVacant= 'N' Then 'No'
	Else SoldAsVacant 
	END AS UpdatedSoldAsVacant
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant=
Case 
	When SoldAsVacant = 'Y' Then 'YES'
	When SoldAsVacant= 'N' Then 'No'
	Else SoldAsVacant 
	END 




-- Let's now remove duplicates in the data

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate,LegalReference
	ORDER by UniqueID ) row_num

From PortfolioProject.dbo.NashvilleHousing
)


Delete
From RowNumCTE
WHERE row_num>1



--checking the duplicates

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate,LegalReference
	ORDER by UniqueID ) row_num

From PortfolioProject.dbo.NashvilleHousing
)

Select *
From RowNumCTE
WHERE row_num>1

-- no more duplicates 



--Let's delete unused colums PropertyAddress,TaxDistric etc.


Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate
