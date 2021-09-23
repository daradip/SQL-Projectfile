/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project].[dbo].[NashvilleHOUSING]
  --Cleaning Data in SQL
  
  Select *
  From [Portfolio Project]..NashvilleHOUSING
  --Standardize Date Format
  Select SaleDateConverted, Convert(Date,SaleDate)
  From [Portfolio Project]..NashvilleHOUSING

 

  Alter Table NashvilleHousing
  Add SaleDateConverted Date;
  Update NashvilleHOUSING
  Set SaleDateConverted = Convert(Date,SaleDate)





  -- Populate Property Address data
  Select *
  From [Portfolio Project]..NashvilleHOUSING 
  --Where PropertyAddress is null
  order by ParcelID
  
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
  From [Portfolio Project]..NashvilleHOUSING a
  Join [Portfolio Project]..NashvilleHOUSING b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

Update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHOUSING a
Join [Portfolio Project]..NashvilleHOUSING b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

  --Breaking down Address into Individual Columns (Address,City, State)
    Select *
  From [Portfolio Project]..NashvilleHOUSING

  Select
  SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Address
,  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address
  From [Portfolio Project]..NashvilleHOUSING


  Alter Table NashvilleHousing
  Add PropertySplitAddress Nvarchar(255);
  Update NashvilleHOUSING
  Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

   Alter Table NashvilleHousing
  Add PropertySplitCity Nvarchar(255);
  Update NashvilleHOUSING
  Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

  Select *
  From [Portfolio Project]..NashvilleHOUSING

  Select OwnerAddress
  From [Portfolio Project]..NashvilleHOUSING

  Select
  PARSENAME(Replace(OwnerAddress , ',','.'),3)
  ,PARSENAME(Replace(OwnerAddress , ',','.'),2)
  ,PARSENAME(Replace(OwnerAddress , ',','.'),1)
  From [Portfolio Project]..NashvilleHOUSING


  
  Alter Table NashvilleHousing
  Add OwnerSplitAddress Nvarchar(255);
  Update NashvilleHOUSING
  Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress , ',','.'),3)
   
   
   Alter Table NashvilleHousing
  Add OwnerSplitCity Nvarchar(255);
  Update NashvilleHOUSING
  Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress , ',','.'),2)
  
  
  Alter Table NashvilleHousing
  Add OwnerSplitState Nvarchar(255);
  Update NashvilleHOUSING
  Set OwnerSplitState = PARSENAME(Replace(OwnerAddress , ',','.'),1)
  
  -- Change Y And N to Yes and No in "Sold as Vacant" field
  Select DISTINCT(SoldAsVacant), Count (SoldAsVacant)
  From [Portfolio Project]..NashvilleHOUSING
  Group by SoldAsVacant
  order by 2


  select SoldASVacant,
  Case When SoldAsVacant='Y' Then'Yes'
		When SoldAsVacant='N'Then'No'
		Else SoldAsVacant
		End
From [Portfolio Project]..NashvilleHOUSING
Update NashvilleHOUSING
Set SoldAsVacant=Case When SoldAsVacant='Y' Then'Yes'
		When SoldAsVacant='N'Then'No'
		Else SoldAsVacant
		End



-- Remove Duplicates 
 With RowNumCTE AS(
 Select *,
	ROW_NUMBER() OVER(Partition BY ParcelID,
								   PropertyAddress,
								   SalePrice,
								   SaleDate,
								   LegalReference
								   Order BY
										UniqueID) row_num
  From [Portfolio Project]..NashvilleHOUSING
  )
	Select *
  From RowNumCTE
  Where row_num>1
  order by PropertyAddress
  
  --Delete
  --From RowNumCTE
  --Where row_num>1
  --order by PropertyAddress






-- Delete Unused Columns
  Select *
  From [Portfolio Project]..NashvilleHOUSING 

  ALter Table [Portfolio Project]..NashvilleHOUSING 
  Drop Column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate