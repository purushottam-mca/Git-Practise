## ✅How to handle multiple GitHub accounts on the same computer

#### 📌 Check SSH Keys
Before creating new keys, check your system for existing SSH keys by running `ls -al ~/.ssh` in your terminal.
Look for files like id_rsa or id_ed25519 with a config file.

#### 📌 Generate New ED25519 SSH Keys
    ssh-keygen -t ed25519 -C "personal_email@example.com" -f ~/.ssh/id_ed25519_personal
    ssh-keygen -t ed25519 -C "work_email@example.com" -f ~/.ssh/id_ed25519_work
💡 Leave the passphrase blank.

#### 📌 Add keys to SSH Agent
    eval "$(ssh-agent -s)" // Start the SSH agent
    
    ssh-add ~/.ssh/id_ed25519_personal
    ssh-add ~/.ssh/id_ed25519_work

#### 📌 Copy SSH Keys to GitHub accounts
- `cat ~/.ssh/id_ed25519_work.pub`
- Copy the content and go to the GitHub website (Work).
- Go to Settings > SSH and GPG keys > New SSH key.
- Give it a title (e.g., "Work Key"), paste the copied key content, and click "Add SSH key."
- Repeat this process for personal GitHub account using id_ed25519_personal.pub

#### 📌 Configure SSH for Multiple Accounts
    vim ~/.ssh/config

    # Work Github
    Host github-work
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519_work
        IdentitiesOnly yes

    # Personal Github
    Host github-personal
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519_personal
        IdentitiesOnly yes

#### 📌 Test GitHub Connection
    ssh -T git@github.com

#### 📌 Clone Repositories Correctly
    git clone git@github-personal:repo.git   (Replace github.com with github-personal)
    git clone git@github-work:work_repo.git  (Replace github.com with github-work)

#### 📌 Configure Git User Details
    git config user.name "Your Name"
    git config user.email "your.email@example.com"   
