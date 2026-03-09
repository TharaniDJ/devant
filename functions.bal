import ballerina/log;

// Check if PR matches the configured filters
function shouldProcessPullRequest(PullRequest pullRequest) returns boolean {
    // Check base branch filter
    if filterBaseBranches.length() > 0 {
        boolean branchMatches = false;
        foreach string branch in filterBaseBranches {
            if pullRequest.base.ref == branch {
                branchMatches = true;
                break;
            }
        }
        if !branchMatches {
            log:printInfo(string `PR #${pullRequest.number} skipped: base branch ${pullRequest.base.ref} not in filter`);
            return false;
        }
    }

    // Check author filter
    if filterAuthor != "" && pullRequest.user.login != filterAuthor {
        log:printInfo(string `PR #${pullRequest.number} skipped: author ${pullRequest.user.login} does not match filter`);
        return false;
    }

    // Check label filter
    if filterLabels.length() > 0 {
        Label[]? prLabels = pullRequest.labels;
        if prLabels is () {
            log:printInfo(string `PR #${pullRequest.number} skipped: no labels found`);
            return false;
        }
        
        boolean labelMatches = false;
        foreach Label prLabel in prLabels {
            foreach string filterLabel in filterLabels {
                if prLabel.name == filterLabel {
                    labelMatches = true;
                    break;
                }
            }
            if labelMatches {
                break;
            }
        }
        
        if !labelMatches {
            log:printInfo(string `PR #${pullRequest.number} skipped: no matching labels`);
            return false;
        }
    }

    return true;
}

// Build Slack message from PR data
function buildSlackMessage(PullRequest pullRequest, Repository repository) returns string {
    string message = string `🎉 *Pull Request Merged*\n\n`;
    message += string `*Repository:* ${repository.full_name}\n`;
    message += string `*PR:* <${pullRequest.html_url}|#${pullRequest.number} - ${pullRequest.title}>\n`;
    message += string `*Author:* ${pullRequest.user.login}\n`;
    message += string `*Base Branch:* ${pullRequest.base.ref}\n`;
    message += string `*Head Branch:* ${pullRequest.head.ref}\n`;

    // Add PR description if enabled
    if includePrDescription {
        string? prBody = pullRequest.body;
        if prBody is string && prBody.trim() != "" {
            string truncatedBody = prBody.length() > 200 ? prBody.substring(0, 200) + "..." : prBody;
            message += string `*Description:* ${truncatedBody}\n`;
        }
    }

    // Add reviewers if enabled
    if includeReviewers {
        User[]? reviewers = pullRequest.requested_reviewers;
        if reviewers is User[] && reviewers.length() > 0 {
            string reviewerNames = "";
            foreach int i in 0 ..< reviewers.length() {
                User reviewer = reviewers[i];
                reviewerNames += reviewer.login;
                if i < reviewers.length() - 1 {
                    reviewerNames += ", ";
                }
            }
            message += string `*Reviewers:* ${reviewerNames}\n`;
        }
    }

    // Add diff stats if enabled
    if includeDiffStats {
        int? additions = pullRequest.additions;
        int? deletions = pullRequest.deletions;
        int? changedFiles = pullRequest.changed_files;
        
        if additions is int && deletions is int && changedFiles is int {
            message += string `*Changes:* +${additions} -${deletions} across ${changedFiles} file(s)\n`;
        }
    }

    return message;
}
