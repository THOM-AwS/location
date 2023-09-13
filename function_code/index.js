const AWS = require("aws-sdk");
const dynamo = new AWS.DynamoDB.DocumentClient();

const respond = (statusCode, body) => {
  return {
    statusCode: statusCode,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*', // This is a wildcard. For production, specify domains explicitly.
      'Access-Control-Allow-Methods': 'POST, GET, OPTIONS'
    },
    body: JSON.stringify(body)
  };
};

exports.handler = async (event) => {
    // Input validation can be done here. For example:
    // if (!event.someProperty) {
    //     return respond(400, { error: "someProperty is required!" });
    // }

    const params = {
        TableName: process.env.DYNAMODB_TABLE,
        // Add query parameters as needed
        // KeyConditionExpression: "#keyName = :value",
        // ExpressionAttributeValues: {
        //     ":value": event.someProperty
        // }
    };

    try {
        const result = await dynamo.query(params).promise();
        return respond(200, result.Items);
    } catch (error) {
        console.error("Error querying DynamoDB:", error); // This logs the error in CloudWatch
        return respond(500, { error: "Failed to retrieve data." });
    }
};
