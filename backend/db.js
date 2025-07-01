const sql = require('mssql');

const config = {
  server: 'localhost',
  database: 'practicaMega',
  options: {
    trustedConnection: true, 
    trustServerCertificate: true
  },
  authentication: {
    type: 'ntlm',
    options: {
      userName: process.env.USERNAME,
      password: '',
      domain: ''
    }
  }
};

const pool = new sql.ConnectionPool(config);

module.exports = { sql, pool };
