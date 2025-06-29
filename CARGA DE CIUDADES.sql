USE PracticaMega
GO

-- Llenar tabla ciudades con 10 ciudades por estado
INSERT INTO ciudades (nombre, estados_id) VALUES 
-- Aguascalientes (estado_id = 1)
('Aguascalientes', 1),
('Calvillo', 1),
('Rincón de Romos', 1),
('Jesús María', 1),
('Pabellón de Arteaga', 1),
('San José de Gracia', 1),
('Tepezalá', 1),
('El Llano', 1),
('Cosío', 1),
('Asientos', 1),

-- Baja California (estado_id = 2)
('Tijuana', 2),
('Mexicali', 2),
('Ensenada', 2),
('Playas de Rosarito', 2),
('Tecate', 2),
('San Felipe', 2),
('La Rumorosa', 2),
('Valle de Guadalupe', 2),
('Puerto Nuevo', 2),
('El Sauzal', 2),

-- Baja California Sur (estado_id = 3)
('La Paz', 3),
('Cabo San Lucas', 3),
('San José del Cabo', 3),
('Loreto', 3),
('Mulegé', 3),
('Comondú', 3),
('Santa Rosalía', 3),
('Guerrero Negro', 3),
('Todos Santos', 3),
('Ciudad Constitución', 3),

-- Campeche (estado_id = 4)
('Campeche', 4),
('Ciudad del Carmen', 4),
('Champotón', 4),
('Escárcega', 4),
('Calkiní', 4),
('Hecelchakán', 4),
('Hopelchén', 4),
('Palizada', 4),
('Tenabo', 4),
('Calakmul', 4),

-- Chiapas (estado_id = 5)
('Tuxtla Gutiérrez', 5),
('San Cristóbal de las Casas', 5),
('Tapachula', 5),
('Comitán de Domínguez', 5),
('Palenque', 5),
('Ocosingo', 5),
('Villaflores', 5),
('Tonalá', 5),
('Pichucalco', 5),
('Arriaga', 5),

-- Chihuahua (estado_id = 6)
('Chihuahua', 6),
('Ciudad Juárez', 6),
('Delicias', 6),
('Parral', 6),
('Cuauhtémoc', 6),
('Nuevo Casas Grandes', 6),
('Camargo', 6),
('Jiménez', 6),
('Bocoyna', 6),
('Meoqui', 6),

-- Coahuila (estado_id = 7)
('Saltillo', 7),
('Torreón', 7),
('Monclova', 7),
('Piedras Negras', 7),
('Acuña', 7),
('Sabinas', 7),
('Nueva Rosita', 7),
('San Pedro', 7),
('Frontera', 7),
('Parras', 7),

-- Colima (estado_id = 8)
('Colima', 8),
('Manzanillo', 8),
('Tecomán', 8),
('Armería', 8),
('Villa de Álvarez', 8),
('Coquimatlán', 8),
('Cuauhtémoc', 8),
('Ixtlahuacán', 8),
('Minatitlán', 8),
('Comala', 8),

-- Durango (estado_id = 9)
('Durango', 9),
('Gómez Palacio', 9),
('Lerdo', 9),
('Santiago Papasquiaro', 9),
('Guadalupe Victoria', 9),
('El Salto', 9),
('Pueblo Nuevo', 9),
('Tlahualilo', 9),
('Canatlán', 9),
('Vicente Guerrero', 9),

-- Guanajuato (estado_id = 10)
('León', 10),
('Irapuato', 10),
('Celaya', 10),
('Salamanca', 10),
('Guanajuato', 10),
('Pénjamo', 10),
('San Francisco del Rincón', 10),
('Dolores Hidalgo', 10),
('San Miguel de Allende', 10),
('Acámbaro', 10),

-- Guerrero (estado_id = 11)
('Acapulco', 11),
('Chilpancingo', 11),
('Iguala', 11),
('Zihuatanejo', 11),
('Taxco', 11),
('Tlapa de Comonfort', 11),
('Ometepec', 11),
('Ayutla de los Libres', 11),
('Arcelia', 11),
('Petatlán', 11),

-- Hidalgo (estado_id = 12)
('Pachuca', 12),
('Tulancingo', 12),
('Tizayuca', 12),
('Huejutla', 12),
('Ixmiquilpan', 12),
('Actopan', 12),
('Tepeji del Río', 12),
('Tula de Allende', 12),
('Mixquiahuala', 12),
('Zimapán', 12),

-- Jalisco (estado_id = 13)
('Guadalajara', 13),
('Zapopan', 13),
('Tlaquepaque', 13),
('Tonalá', 13),
('Puerto Vallarta', 13),
('Tlajomulco de Zúñiga', 13),
('El Salto', 13),
('Chapala', 13),
('Ocotlán', 13),
('Tepatitlán', 13),

-- México (estado_id = 14)
('Toluca', 14),
('Ecatepec', 14),
('Naucalpan', 14),
('Nezahualcóyotl', 14),
('Tlalnepantla', 14),
('Chimalhuacán', 14),
('Atizapán de Zaragoza', 14),
('Cuautitlán Izcalli', 14),
('Valle de Chalco', 14),
('Texcoco', 14),

-- Michoacán (estado_id = 15)
('Morelia', 15),
('Uruapan', 15),
('Zamora', 15),
('Lázaro Cárdenas', 15),
('Apatzingán', 15),
('Pátzcuaro', 15),
('Sahuayo', 15),
('Zitácuaro', 15),
('Hidalgo', 15),
('La Piedad', 15),

-- Morelos (estado_id = 16)
('Cuernavaca', 16),
('Jiutepec', 16),
('Temixco', 16),
('Cuautla', 16),
('Yautepec', 16),
('Emiliano Zapata', 16),
('Xochitepec', 16),
('Zacatepec', 16),
('Jojutla', 16),
('Tepoztlán', 16),

-- Nayarit (estado_id = 17)
('Tepic', 17),
('Bahía de Banderas', 17),
('Santiago Ixcuintla', 17),
('Compostela', 17),
('Acaponeta', 17),
('Tuxpan', 17),
('Ixtlán del Río', 17),
('Tecuala', 17),
('Rosamorada', 17),
('Ruiz', 17),

-- Nuevo León (estado_id = 18)
('Monterrey', 18),
('Guadalupe', 18),
('San Nicolás de los Garza', 18),
('Apodaca', 18),
('Santa Catarina', 18),
('San Pedro Garza García', 18),
('Escobedo', 18),
('Cadereyta Jiménez', 18),
('Linares', 18),
('Sabinas Hidalgo', 18),

-- Oaxaca (estado_id = 19)
('Oaxaca de Juárez', 19),
('Salina Cruz', 19),
('Tuxtepec', 19),
('Juchitán', 19),
('Huajuapan de León', 19),
('Puerto Escondido', 19),
('Matías Romero', 19),
('Miahuatlán', 19),
('Tlaxiaco', 19),
('Pinotepa Nacional', 19),

-- Puebla (estado_id = 20)
('Puebla', 20),
('Tehuacán', 20),
('San Martín Texmelucan', 20),
('Atlixco', 20),
('Cholula', 20),
('Huauchinango', 20),
('Izúcar de Matamoros', 20),
('Teziutlán', 20),
('Amozoc', 20),
('Cuautlancingo', 20),

-- Querétaro (estado_id = 21)
('Querétaro', 21),
('San Juan del Río', 21),
('Corregidora', 21),
('El Marqués', 21),
('Tequisquiapan', 21),
('Cadereyta de Montes', 21),
('Amealco', 21),
('Jalpan de Serra', 21),
('Landa de Matamoros', 21),
('Pedro Escobedo', 21),

-- Quintana Roo (estado_id = 22)
('Cancún', 22),
('Playa del Carmen', 22),
('Chetumal', 22),
('Cozumel', 22),
('Tulum', 22),
('Akumal', 22),
('Bacalar', 22),
('Isla Mujeres', 22),
('Puerto Morelos', 22),
('Xcaret', 22),

-- San Luis Potosí (estado_id = 23)
('San Luis Potosí', 23),
('Soledad de Graciano Sánchez', 23),
('Ciudad Valles', 23),
('Rioverde', 23),
('Matehuala', 23),
('Tamazunchale', 23),
('Cárdenas', 23),
('Ebano', 23),
('Cedral', 23),
('Mexquitic', 23),

-- Sinaloa (estado_id = 24)
('Culiacán', 24),
('Mazatlán', 24),
('Los Mochis', 24),
('Guasave', 24),
('Navolato', 24),
('El Fuerte', 24),
('Guamúchil', 24),
('Escuinapa', 24),
('Rosario', 24),
('Concordia', 24),

-- Sonora (estado_id = 25)
('Hermosillo', 25),
('Ciudad Obregón', 25),
('Nogales', 25),
('Navojoa', 25),
('Guaymas', 25),
('San Luis Río Colorado', 25),
('Agua Prieta', 25),
('Caborca', 25),
('Puerto Peñasco', 25),
('Cananea', 25),

-- Tabasco (estado_id = 26)
('Villahermosa', 26),
('Cárdenas', 26),
('Comalcalco', 26),
('Huimanguillo', 26),
('Macuspana', 26),
('Cunduacán', 26),
('Teapa', 26),
('Jalpa de Méndez', 26),
('Nacajuca', 26),
('Paraíso', 26),

-- Tamaulipas (estado_id = 27)
('Reynosa', 27),
('Matamoros', 27),
('Nuevo Laredo', 27),
('Tampico', 27),
('Victoria', 27),
('Altamira', 27),
('Madero', 27),
('Río Bravo', 27),
('Valle Hermoso', 27),
('Miguel Alemán', 27),

-- Tlaxcala (estado_id = 28)
('Tlaxcala', 28),
('Apizaco', 28),
('Huamantla', 28),
('Zacatelco', 28),
('Chiautempan', 28),
('Contla de Juan Cuamatzi', 28),
('Panotla', 28),
('Santa Cruz Tlaxcala', 28),
('Tetla de la Solidaridad', 28),
('Teolocholco', 28),

-- Veracruz (estado_id = 29)
('Veracruz', 29),
('Xalapa', 29),
('Coatzacoalcos', 29),
('Córdoba', 29),
('Poza Rica', 29),
('Orizaba', 29),
('Minatitlán', 29),
('Boca del Río', 29),
('Tuxpan', 29),
('Papantla', 29),

-- Yucatán (estado_id = 30)
('Mérida', 30),
('Valladolid', 30),
('Tizimín', 30),
('Progreso', 30),
('Motul', 30),
('Tekax', 30),
('Izamal', 30),
('Ticul', 30),
('Umán', 30),
('Kanasín', 30),

-- Zacatecas (estado_id = 31)
('Zacatecas', 31),
('Fresnillo', 31),
('Guadalupe', 31),
('Jerez', 31),
('Río Grande', 31),
('Sombrerete', 31),
('Ojocaliente', 31),
('Tlaltenango', 31),
('Pinos', 31),
('Loreto', 31),

-- Ciudad de México (estado_id = 32)
('Álvaro Obregón', 32),
('Azcapotzalco', 32),
('Benito Juárez', 32),
('Coyoacán', 32),
('Cuajimalpa', 32),
('Gustavo A. Madero', 32),
('Iztacalco', 32),
('Iztapalapa', 32),
('Magdalena Contreras', 32),
('Miguel Hidalgo', 32);

-- Verificar inserción
SELECT COUNT(*) AS total_ciudades FROM ciudades;
SELECT e.nombre AS estado, COUNT(c.id) AS total_ciudades
FROM estados e
LEFT JOIN ciudades c ON e.id = c.estados_id
GROUP BY e.nombre
ORDER BY e.nombre;



USE PracticaMega
GO

-- Borrar registros de la tabla ciudades del ID 321 al 640
DELETE FROM ciudades 
WHERE id BETWEEN 321 AND 640;

-- Verificar cuántos registros se eliminaron
SELECT @@ROWCOUNT AS registros_eliminados;

-- Verificar el estado actual de la tabla
SELECT COUNT(*) AS total_ciudades_restantes FROM ciudades;

-- Ver el rango de IDs que quedaron
SELECT 
    MIN(id) AS id_minimo,
    MAX(id) AS id_maximo
FROM ciudades;