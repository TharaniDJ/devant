import ballerina/http;
import ballerina/log;

// GitHub webhook service
service /github on githubWebhookListener {

    // Webhook endpoint for pull request events
    resource function post webhook(@http:Payload GitHubWebhookPayload payload) returns http:Ok|http:BadRequest|error {
        
        log:printInfo(string `Received GitHub webhook: action=${payload.action}`);

        // Check if this is a closed PR event
        if payload.action != "closed" {
            log:printInfo("Ignoring non-closed PR event");
            return http:OK;
        }

        PullRequest pullRequest = payload.pull_request;

        // Check if PR was actually merged
        if !pullRequest.merged {
            log:printInfo(string `PR #${pullRequest.number} was closed but not merged`);
            return http:OK;
        }

        // Apply filters
        if !shouldProcessPullRequest(pullRequest = pullRequest) {
            return http:OK;
        }

        // Build Slack message
        string slackMessage = buildSlackMessage(pullRequest = pullRequest, repository = payload.repository);

        // Send to Slack
        _ = check slackClient->/chat\.postMessage.post(payload = {
            channel: slackChannelId,
            text: slackMessage,
            mrkdwn: true
        });

        log:printInfo(string `Slack notification sent for PR #${pullRequest.number}`);
        
        return http:OK;
    }

    // Health check endpoint
    resource function get health() returns string {
        return "GitHub webhook listener is running";
    }
}
