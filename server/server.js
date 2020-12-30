const connection = require('./connection');
const PORT = process.env.PORT || 3000;
const EXPRESS = require('express');
const PARSER = require('body-parser');
const APP = EXPRESS();

/** Parser */
APP.use(PARSER.json());

/** Empty connection */
let conn = null;

/** Callbacks */
const is_input_corrupted = (data) => {
  /** Base */
  if (!data.name || !data.score || isNaN(parseInt(data.score, 10))) {
    return { ok: false, reason: 'Invalid name or score' };
  }
  data.score = parseInt(data.score, 10);
  /** Name length */
  if (data.name.length < 3 || data.name.length > 16) {
    return { ok: false, reason: 'Invalid name length' };
  }
  /** Score */
  if (data.score <= 0) {
    return { ok: false, reason: 'Invalid score' };
  }
  /** Allowed characters */
  const chars = 'qwertzuioplkjhgfdsayxcvbnm0123456789';
  if(data.name.split('').find((c) => chars.indexOf(c.toLowerCase()) === -1)) {
    return { ok: false, reason: 'Invalid character in name' };
  }
  return { ok: true, body: data }
}

/** Static */
APP.use(EXPRESS.static(__dirname + '/public'));
/** Endpoints */
APP.get('/api/list', (req, res) => {
  conn.get(
    'SELECT name, score FROM scores ORDER BY score DESC'
  ).then((result) => {
    res.status(200).json({data: result || []});
  }).catch((e) => {
    res.status(500).json({status: 'Something went wrong'});
  });
});
APP.post('/api/new', (req, res) => {
  console.log(req.query, req.body)
  const input = is_input_corrupted(req.query);
  if(!input.ok) {
    console.log(input.reason);
    res.status(500).json({ status: input.reason });
  } else {
    conn.post(
      `INSERT INTO scores (name, score) VALUES (?, ?)`, [ input.body.name, input.body.score ]
    ).then(() => {
      res.status(201).send();
    }).catch((e) => {
      console.log(e);
      res.status(500).json({status: 'Something went wrong'});
    });
  }
});
/** 404 */
APP.use((req, res) => {
  res.status(404).json({ status: 'Not found' });
});
/** Start server */
APP.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
  /** Create connection */
  conn = new connection.Connection();
});