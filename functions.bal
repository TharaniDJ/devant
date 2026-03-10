import ballerinax/trigger.github;

// Check if PR matches the configured filters
function shouldProcessPullRequest(github:PullRequest pr) returns boolean {
    // Filter by base branch (e.g., only main/release branches)
    if filterBaseBranches.length() > 0 {
        boolean matchesBaseBranch = false;
        foreach string branch in filterBaseBranches {
            if pr.base.'ref == branch {
                matchesBaseBranch = true;
                break;
            }
        }
        if !matchesBaseBranch {
            return false;
        }
    }

    // Filter by label
    if filterLabels.length() > 0 {
        boolean hasMatchingLabel = false;
        github:Label[]? prLabels = pr.labels;
        if prLabels is github:Label[] {
            foreach github:Label prLabel in prLabels {
                foreach string filterLabel in filterLabels {
                    if prLabel.name == filterLabel {
                        hasMatchingLabel = true;
                        break;
                    }
                }
                if hasMatchingLabel {
                    break;
                }
            }
        }
        if !hasMatchingLabel {
            return false;
        }
    }

    // Filter by author
    if filterAuthor != "" {
        if pr.user.login != filterAuthor {
            return false;
        }
    }

    return true;
}

// Build Slack message from PR data
function buildSlackMessage(github:PullRequest pr, github:Repository repo) returns string {
    string message = string `🎉 *Pull Request Merged*\n\n`;
    message += string `*Repository:* <${repo.html_url}|${repo.full_name}>\n`;
    message += string `*PR:* <${pr.html_url}|#${pr.number} - ${pr.title}>\n`;
    message += string `*Author:* <${pr.user.html_url}|@${pr.user.login}>\n`;
    message += string `*Base Branch:* ${pr.base.'ref}\n`;

    // Include PR description if configured
    if includePrDescription {
        string? prBody = pr.body;
        if prBody is string {
            string description = prBody;
            if description.length() > 200 {
                description = description.substring(0, 200) + "...";
            }
            message += string `*Description:* ${description}\n`;
        }
    }

    // Include reviewers if configured
    if includeReviewers {
        github:User[]? reviewers = pr.requested_reviewers;
        if reviewers is github:User[] && reviewers.length() > 0 {
            message += "*Reviewers:* ";
            foreach int i in 0 ..< reviewers.length() {
                message += string `<${reviewers[i].html_url}|@${reviewers[i].login}>`;
                if i < reviewers.length() - 1 {
                    message += ", ";
                }
            }
            message += "\n";
        }
    }

    // Include diff stats if configured
    if includeDiffStats {
        int additions = pr.additions ?: 0;
        int deletions = pr.deletions ?: 0;
        int changedFiles = pr.changed_files ?: 0;
        message += string `*Changes:* +${additions} -${deletions} across ${changedFiles} file(s)\n`;
    }

    return message;
}

