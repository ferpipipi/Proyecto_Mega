const express = require('express');
const cors = require('cors');
const { sql, pool } = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

// Obtener todas las promociones
app.get('/api/promociones', async (req, res) => {
  try {
    await pool.connect();
    const result = await pool.request().query('SELECT * FROM promociones');
    res.json(result.recordset);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Agregar una nueva promoción
app.post('/api/promociones', async (req, res) => {
  const {
    nombre,
    descripcion,
    tipo_promocion,
    valor_descuento,
    es_porcentaje,
    duracion_meses,
    fecha_inicio,
    fecha_fin,
    activo
  } = req.body;

  try {
    await pool.connect();
    await pool.request()
      .input('nombre', sql.VarChar(100), nombre)
      .input('descripcion', sql.Text, descripcion)
      .input('tipo_promocion', sql.VarChar(50), tipo_promocion)
      .input('valor_descuento', sql.Decimal(10, 2), valor_descuento)
      .input('es_porcentaje', sql.Bit, es_porcentaje)
      .input('duracion_meses', sql.Int, duracion_meses)
      .input('fecha_inicio', sql.DateTime, fecha_inicio)
      .input('fecha_fin', sql.DateTime, fecha_fin)
      .input('activo', sql.Bit, activo)
      .query(`
        INSERT INTO promociones (nombre, descripcion, tipo_promocion, valor_descuento, es_porcentaje, duracion_meses, fecha_inicio, fecha_fin, activo)
        VALUES (@nombre, @descripcion, @tipo_promocion, @valor_descuento, @es_porcentaje, @duracion_meses, @fecha_inicio, @fecha_fin, @activo)
      `);

    res.sendStatus(201);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Editar promoción
app.put('/api/promociones/:id', async (req, res) => {
  const { id } = req.params;
  const {
    nombre,
    descripcion,
    tipo_promocion,
    valor_descuento,
    es_porcentaje,
    duracion_meses,
    fecha_inicio,
    fecha_fin,
    activo
  } = req.body;

  try {
    await pool.connect();
    await pool.request()
      .input('id', sql.Int, id)
      .input('nombre', sql.VarChar(100), nombre)
      .input('descripcion', sql.Text, descripcion)
      .input('tipo_promocion', sql.VarChar(50), tipo_promocion)
      .input('valor_descuento', sql.Decimal(10, 2), valor_descuento)
      .input('es_porcentaje', sql.Bit, es_porcentaje)
      .input('duracion_meses', sql.Int, duracion_meses)
      .input('fecha_inicio', sql.DateTime, fecha_inicio)
      .input('fecha_fin', sql.DateTime, fecha_fin)
      .input('activo', sql.Bit, activo)
      .query(`
        UPDATE promociones SET
          nombre = @nombre,
          descripcion = @descripcion,
          tipo_promocion = @tipo_promocion,
          valor_descuento = @valor_descuento,
          es_porcentaje = @es_porcentaje,
          duracion_meses = @duracion_meses,
          fecha_inicio = @fecha_inicio,
          fecha_fin = @fecha_fin,
          activo = @activo
        WHERE id = @id
      `);

    res.sendStatus(200);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Eliminar promoción
app.delete('/api/promociones/:id', async (req, res) => {
  const { id } = req.params;

  try {
    await pool.connect();
    await pool.request()
      .input('id', sql.Int, id)
      .query('DELETE FROM promociones WHERE id = @id');

    res.sendStatus(200);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.listen(3000, () => {
  console.log('API corriendo en http://localhost:3000');
});
