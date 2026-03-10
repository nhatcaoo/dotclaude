# SSH Conventions

## Priority Rule
Always check `~/.ssh/config` before constructing any SSH-related command.

## Host Resolution Order
1. Check `~/.ssh/config` for a matching `Host` alias
2. If found → use the alias: `ssh <Host>`, `scp <Host>:/path`, `rsync user@<Host>:/path`
3. If not found → suggest adding an entry, then proceed with explicit flags

## Using Aliases
```bash
# Good — alias resolves all connection details from ~/.ssh/config
ssh loyalty-aws
scp loyalty-aws:/var/log/app.log .
rsync -avz loyalty-aws:/data/ ./backup/

# Bad — hardcoded details Claude should not invent
ssh ec2-user@13.212.235.201 -i ~/.ssh/id_ed25519
```

## Adding a New Host Entry
If a host is not in `~/.ssh/config`, suggest appending:
```
Host <alias>
    HostName <ip-or-domain>
    User <username>
    IdentityFile ~/.ssh/<keyfile>
    PubkeyAuthentication yes
    PasswordAuthentication no
```

## Known Hosts on This Machine (from ~/.ssh/config)
| Alias | Host | User | Key |
|---|---|---|---|
| scw-sandbox | 10.1.0.54 | scw | id_ed25519 |
| loyalty-aws | 13.212.235.201 | ec2-user | id_ed25519 |
| loyalty-fe-aws | 18.143.145.204 | ec2-user | id_ed25519 |
| safe-dev | 34.101.132.66 | ubuntu | id_ed25519 |
| pruv-stellar | 34.101.130.155 | ubuntu | pruv-stellar |
| demo-wallet-aws | 18.142.225.126 | ubuntu | id_ed25519 |
| git02.smartosc.com | git02.smartosc.com | git | id_ed25519_smartosc |

## General Rules
- Never log SSH commands containing private key contents
- Never suggest `ssh -o StrictHostKeyChecking=no` in production contexts
- Prefer `PubkeyAuthentication yes` + `PasswordAuthentication no` for all servers
- Use `ServerAliveInterval 60` (already set as global default in ~/.ssh/config)
