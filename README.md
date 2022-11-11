# kind
Kind sandbox

Before start please consider to add /etc/sysctl.conf
```
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
```
For more details read: https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files
