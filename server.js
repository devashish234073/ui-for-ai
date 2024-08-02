const express = require('express');
const http = require('http');
const path = require('path');

const app = express();
const PORT = 9999;
const MODEL_NAME = process.argv[2];
console.log("running against model ",MODEL_NAME);

app.use(express.json());

app.use(express.static(path.join(__dirname, 'public')));

app.post('/generate', (req, res) => {
  const prompt = req.body.prompt;
  const postData = JSON.stringify({
    model: MODEL_NAME,
    prompt: prompt
  });

  const options = {
    hostname: 'localhost',
    port: 11434,
    path: '/api/generate',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(postData)
    }
  };

  const apiReq = http.request(options, (apiRes) => {
    res.setHeader('Content-Type', 'text/plain');

    apiRes.on('data', (chunk) => {
      res.write(chunk);
    });

    apiRes.on('end', () => {
      res.end();
    });
  });

  apiReq.on('error', (e) => {
    console.error(`Problem with request: ${e.message}`);
    res.status(500).send('Internal Server Error');
  });

  apiReq.write(postData);
  apiReq.end();
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
