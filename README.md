# wrtbwmon
Modified from https://code.google.com/p/wrtbwmon/.

### What does it do?
`wrtbwmon` was designed to track bandwidth consumption on home routers. 
It accomplishes this with `iptables` rules, which means you don't need to run an extra process just to track bandwidth. 
`wrtbwmon` conveniently tracks bandwidth consumption on a per-IP address basis, 
so you can easily determine which user/device is the culprit.

### How do I use it?
- Setup: `./wrtbwmon setup`
- Update table: `./wrtbwmon update /tmp/usage.db` (you can place the data table anywhere)
- Create html page (currently broken): `./wrtbwmon publish /tmp/usage.db /tmp/usage.htm`