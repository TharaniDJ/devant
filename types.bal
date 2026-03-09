// GitHub webhook payload types
type GitHubWebhookPayload record {
    string action;
    PullRequest pull_request;
    Repository repository;
};

type PullRequest record {
    int number;
    string title;
    string state;
    boolean merged;
    string? merged_at;
    User user;
    string? body;
    Base base;
    Base head;
    string html_url;
    User[] requested_reviewers?;
    int additions?;
    int deletions?;
    int changed_files?;
    Label[] labels?;
};

type User record {
    string login;
    string avatar_url?;
};

type Base record {
    string ref;
    Repository repo;
};

type Repository record {
    string name;
    string full_name;
    Owner owner;
};

type Owner record {
    string login;
};

type Label record {
    string name;
    string color?;
};
