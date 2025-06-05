// app.js
const express = require('express');
const bodyParser = require('body-parser');
const AWS = require('aws-sdk');

const app = express();
const port = process.env.PORT || 3000;

//AWS.config.update({ region: 'us-east-1' }); // Adjust if needed
const dynamodb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = 'boot4-us-east-1-dev-table'; // Replace with your actual table name

app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', async (req, res) => {
  let html = `
    <form method="post" action="/submit">
      First name: <input name="first_name" required><br>
      Last name: <input name="last_name" required><br>
      <button type="submit">Submit</button>
    </form>
    <hr><h3>Submitted Data:</h3><ul>`;

  try {
    const data = await dynamodb.scan({ TableName: TABLE_NAME }).promise();
    for (const item of data.Items) {
      html += `<li>${item.first_name} ${item.last_name}</li>`;
    }
    html += '</ul>';
  } catch (err) {
    console.error(err);
    html += '<p>Error retrieving data</p>';
  }

  res.send(html);
});

app.post('/submit', async (req, res) => {
  const { first_name, last_name } = req.body;
  const id = Date.now().toString();

  const params = {
    TableName: TABLE_NAME,
    Item: {
      id,
      first_name,
      last_name
    }
  };

  try {
    await dynamodb.put(params).promise();
    res.redirect('/');
  } catch (err) {
    console.error(err);
    res.send('Error saving data');
  }
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});