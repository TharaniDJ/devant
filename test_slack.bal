import ballerinax/slack;
import ballerina/io;

























}    io:println("Check your Slack channel: " + slackChannelId);    io:println("✅ Test message sent successfully to Slack!");    });        text: testMessage        channel: slackChannelId,    _ = check slackClient->/chat\.postMessage.post({                        "Ready to receive GitHub PR notifications.";                        "✅ Configuration is correct!\n" +                        "✅ Slack connection is working!\n" +    string testMessage = "🎉 *Test Message from Ballerina Integration*\n\n" +    });        }            token: slackToken        auth: {    slack:Client slackClient = check new ({public function main() returns error? {configurable string slackChannelId = ?;configurable string slackToken = ?;
