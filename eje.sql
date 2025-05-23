 


-- 1. PROCEDIMIENTO PARA CONSULTAR EMPLEADOS POR DEPARTAMENTO

CREATE PROCEDURE sp_EmpleadosPorDepartamento
     @NDpto NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.FirstName,
        p.LastName,
        p.MiddleName,
        e.BusinessEntityID,
        d.Name AS Departamento,
        e.JobTitle,
        e.HireDate
    FROM HumanResources.Employee e
    INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
    INNER JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
    WHERE d.Name =  @NDpto
      AND edh.EndDate IS NULL -- Solo empleados activos en el departamento
    ORDER BY p.LastName, p.FirstName;
END;

-- Prueba del procedimiento 1
EXEC sp_EmpleadosPorDepartamento  @NDpto = 'Engineering';

 
-- 2. PROCEDIMIENTO PARA INSERTAR NUEVA PERSONA
 
CREATE PROCEDURE sp_InsertarPersona
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @MiddleName NVARCHAR(50) = NULL,
    @PersonType NCHAR(2) = 'IN'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si ya existe una persona con el mismo nombre completo
    IF EXISTS (
        SELECT 1 
        FROM Person.Person 
        WHERE FirstName = @FirstName 
          AND LastName = @LastName 
          AND ISNULL(MiddleName, '') = ISNULL(@MiddleName, '')
    )
    BEGIN
        PRINT 'Ya existe una persona con ese nombre completo';
        RETURN;
    END
    
    -- Insertar la nueva persona
    INSERT INTO Person.Person (
        BusinessEntityID,
        PersonType,
        FirstName,
        MiddleName,
        LastName,
        rowguid,
        ModifiedDate
    )
    VALUES (
        NEXT VALUE FOR Person.BusinessEntityID_seq,
        @PersonType,
        @FirstName,
        @MiddleName,
        @LastName,
        NEWID(),
        GETDATE()
    );
    
    PRINT 'Persona insertada correctamente';
END;


-- Pruebas del procedimiento 2
EXEC sp_InsertarPersona @FirstName = 'Juan', @LastName = 'Pérez', @MiddleName = 'Carlos';
EXEC sp_InsertarPersona @FirstName = 'Juan', @LastName = 'Pérez', @MiddleName = 'Carlos'; -- Debe mostrar que ya existe

 
-- 3. PROCEDIMIENTO PARA ACTUALIZAR SALARIO
 
CREATE PROCEDURE sp_ActualizarSalario
    @BusinessEntityID INT,
    @NuevoSalario MONEY
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SalarioActual MONEY;
    
    -- Verificar si existe un registro activo para el empleado
    SELECT @SalarioActual = Rate
    FROM HumanResources.EmployeePayHistory
    WHERE BusinessEntityID = @BusinessEntityID
      AND EndDate IS NULL;
    
    -- Si no se encontró registro activo
    IF @SalarioActual IS NULL
    BEGIN
        PRINT 'No se encontró un registro activo para este empleado';
        RETURN;
    END
    
    -- Verificar si el nuevo salario es mayor al actual
    IF @NuevoSalario <= @SalarioActual
    BEGIN
        PRINT 'El nuevo salario debe ser mayor al salario actual';
        RETURN;
    END
    
    -- Actualizar el salario
    UPDATE HumanResources.EmployeePayHistory
    SET Rate = @NuevoSalario,
        ModifiedDate = GETDATE()
    WHERE BusinessEntityID = @BusinessEntityID
      AND EndDate IS NULL;
    
    PRINT 'Salario actualizado correctamente';
END;

-- Pruebas del procedimiento 3
-- Primero verificar un empleado existente y su salario actual
SELECT BusinessEntityID, Rate 
FROM HumanResources.EmployeePayHistory 
WHERE EndDate IS NULL 
ORDER BY BusinessEntityID;

-- Ejecutar con un BusinessEntityID válido (ejemplo: 1)
EXEC sp_ActualizarSalario @BusinessEntityID = 1, @NuevoSalario = 50.00;
EXEC sp_ActualizarSalario @BusinessEntityID = 1, @NuevoSalario = 30.00; -- Debe mostrar error
EXEC sp_ActualizarSalario @BusinessEntityID = 99999, @NuevoSalario = 50.00; -- Empleado inexistente

 
-- 4. PROCEDIMIENTO PARA ELIMINAR PRODUCTO
 
CREATE PROCEDURE sp_EliminarProducto
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si el producto existe
    IF NOT EXISTS (SELECT 1 FROM Production.Product WHERE ProductID = @ProductID)
    BEGIN
        PRINT 'El producto no existe';
        RETURN;
    END
    
    -- Verificar si el producto está asociado a alguna orden de venta
    IF EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE ProductID = @ProductID)
    BEGIN
        PRINT 'No se puede eliminar el producto porque está asociado a una orden de venta';
        RETURN;
    END
    
    -- Eliminar el producto
    DELETE FROM Production.Product
    WHERE ProductID = @ProductID;
    
    PRINT 'Producto eliminado correctamente';
END;

-- Pruebas del procedimiento 4
-- Verificar productos que no están en órdenes de venta
SELECT p.ProductID, p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

-- Ejecutar con un producto que no tenga órdenes de venta
EXEC sp_EliminarProducto @ProductID = 999; -- Producto inexistente
-- EXEC sp_EliminarProducto @ProductID = [ID_SIN_ORDENES]; -- Usar un ID válido sin órdenes
-- EXEC sp_EliminarProducto @ProductID = 707; -- Producto con órdenes (debe mostrar error)

 
-- CONSULTAS AUXILIARES PARA VERIFICAR DATOS
 

-- Ver departamentos disponibles
SELECT DISTINCT Name FROM HumanResources.Department ORDER BY Name;

-- Ver algunos empleados y sus salarios actuales
SELECT TOP 10 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS NombreCompleto,
    eph.Rate AS SalarioActual
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
WHERE eph.EndDate IS NULL
ORDER BY e.BusinessEntityID;

-- Ver productos sin órdenes de venta
SELECT TOP 10 p.ProductID, p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL
ORDER BY p.ProductID;
