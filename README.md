# Interface hooks with Snap services Example

This repo has an example of using [Interface hooks](https://snapcraft.io/docs/interface-hooks) within a snap to only start services in the snap when all interfaces have been connected.

Since it is common for snaps to have a single plug, such as [`gpio`](https://snapcraft.io/docs/gpio-interface), with multiple connections to different slots, this snap keeps track of how many connections there are for the `gpio` plug, only starting the service after two interfaces are connected. This is accomplished with a simpler counter in snap config, set with `snapctl set`. The counter is incremented when a new gpio connection is made, and decremented when one is disconnected.

See an example usage:

```bash
user@localhost:~$ snap install --dangerous interface-hooks-service-example_0.1_armhf.snap 
interface-hooks-service-example 0.1 installed
user@localhost:~$ snap connections interface-hooks-service-example 
Interface         Plug                                              Slot  Notes
gpio              interface-hooks-service-example:gpio              -     -
hardware-observe  interface-hooks-service-example:hardware-observe  -     -
user@localhost:~$ snap get interface-hooks-service-example 
error: snap "interface-hooks-service-example" has no configuration
user@localhost:~$ snap services interface-hooks-service-example
Service                               Startup   Current   Notes
interface-hooks-service-example.svc1  disabled  inactive  -
user@localhost:~$ snap connect interface-hooks-service-example:hardware-observe 
user@localhost:~$ snap get interface-hooks-service-example 
Key                     Value
hardware-observe-iface  true
user@localhost:~$ snap connect interface-hooks-service-example:gpio pi2:bcm-gpio-10
user@localhost:~$ snap get interface-hooks-service-example 
Key                     Value
gpio-iface-count        1
hardware-observe-iface  true
user@localhost:~$ snap disconnect interface-hooks-service-example:gpio pi2:bcm-gpio-10
user@localhost:~$ snap get interface-hooks-service-example 
Key                     Value
gpio-iface-count        0
hardware-observe-iface  true
user@localhost:~$ snap connect interface-hooks-service-example:gpio pi2:bcm-gpio-0
user@localhost:~$ snap connect interface-hooks-service-example:gpio pi2:bcm-gpio-1
user@localhost:~$ snap services interface-hooks-service-example
Service                               Startup  Current   Notes
interface-hooks-service-example.svc1  enabled  active  -
user@localhost:~$ snap disconnect interface-hooks-service-example:gpio pi2:bcm-gpio-1
user@localhost:~$ snap services interface-hooks-service-example
Service                               Startup   Current   Notes
interface-hooks-service-example.svc1  disabled  inactive  -

```

Also note that this snap is made to run on an armhf device but that's just because armhf devices with a gadget snap with `gpio` slots is easily accessible. There's nothing in the snap that is architecture specific and this could be expanded to other architectures with ease.

# License
This project is licensed under the GPLv3. See LICENSE file for full license. Copyright 2019 Canonical Ltd.

