const SQLITE3 = require('sqlite3');
const SOURCE_NAME = 'pong.sqlite';
const PATH = require('path');
const FS = require('fs');

class Connection {
  constructor() {
    this.establish_connection();
  }
  establish_connection() {
    console.log(`Establishing connection to database`);
    /** Open database */
    this.connection = new SQLITE3.Database(SOURCE_NAME, (err) => {
      if(err) {
        throw err;
      }
      /** Create table */
      this.connection.run(
        `CREATE TABLE IF NOT EXISTS scores (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(16) NOT NULL,
          score INTEGER NOT NULL
        )`, (err) => {
          if(err) {
            throw err;
          }
          console.log('Database connection established.');
        }
      );
    });
  }
  post(query, params = []) {
    return new Promise((resolve, reject) => {
      this.connection.run(query, ...params, (err, result) => {
        if(err) {
          return reject(err);
        }
        resolve(result);
      });
    })
  }
  get(query) {
    return new Promise((resolve, reject) => {
      this.connection.all(query, (err, result) => {
        if(err) {
          return reject(err);
        }
        resolve(result);
      });
    })
  }
}

exports.Connection = Connection;