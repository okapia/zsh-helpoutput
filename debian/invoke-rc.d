
invoke-rc.d, Debian/SysVinit (/etc/rc?.d) initscript subsystem.
Copyright (c) 2000,2001 Henrique de Moraes Holschuh <hmh@debian.org>

Usage:
  invoke-rc.d [options] <basename> <action> [extra parameters]

  basename - Initscript ID, as per update-rc.d(8)
  action   - Initscript action. Known actions are:
                start, [force-]stop, restart,
                [force-]reload, status
  WARNING: not all initscripts implement all of the above actions.

  extra parameters are passed as is to the initscript, following 
  the action (first initscript parameter).

Options:
  --quiet
     Quiet mode, no error messages are generated.
  --force
     Try to run the initscript regardless of policy and subsystem
     non-fatal errors.
  --try-anyway
     Try to run init script even if a non-fatal error is found.
  --disclose-deny
     Return status code 101 instead of status code 0 if
     initscript action is denied by local policy rules or
     runlevel constrains.
  --query
     Returns one of status codes 100-106, does not run
     the initscript. Implies --disclose-deny and --no-fallback.
  --no-fallback
     Ignores any fallback action requests by the policy layer.
     Warning: this is usually a very *bad* idea for any actions
     other than "start".
  --help
     Outputs help message to stdout

