import ballerinax/slack;
import ballerina/http;

// Initialize Slack client
final slack:Client slackClient = check new (
    config = {
        auth: {
            token: slackToken
        }
    }
);

// Initialize HTTP listener for GitHub webhook
listener http:Listener githubWebhookListener = check new (webhookPort);
