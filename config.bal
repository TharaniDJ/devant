// Slack configuration
configurable string slackToken = ?;
configurable string slackChannelId = ?;

// GitHub webhook configuration
configurable int webhookPort = 8090;

// Optional filters
configurable string[] filterBaseBranches = ["main"];
configurable string[] filterLabels = [];
configurable string filterAuthor = "";

// Message customization
configurable boolean includePrDescription = true;
configurable boolean includeReviewers = true;
configurable boolean includeDiffStats = true;
