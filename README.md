# My Utility Script :
*  A TUI script that helps you install development tools depending on your use case.
*  This script is meant for ubuntu or ubuntu-based users (Maybe port for other distros)
<br><br>
*  Current Script Directory Structure :
```
.
└── src
    ├── menus
    └── scripts
        ├── ai
        ├── dev
        ├── drivers
        └── tweaks

```
*  src : Directory for storing ressources <br>
*  src/menus : Directory for menus definition <br>
*  src/scripts : Directory for Installers Scripts related to each menu <br>
<br><br>
*  Available Scripts :
```
scripts
├── ai
|   ├── pytorch_installer
|   ├── tensorflow_installer
|   └── conda
|          ├── conda_installer
|          └── conda_remover
├── dev
│   ├── android_studio_installer
│   ├── angular_installer
|   ├── oracle_vm_installer
│   └── flutter_installer
├── drivers
│    ├── cuda_installer
|    ├── cuda_switcher 
│    └── nvidia
|           ├── nvidia_driver_installer
|           └── nvidia_driver_remover
└── tweaks
     ├── keyboard_rgb_fix
     |     ├── keyboard_rgb_fix_installer
     |     └── keyboard_rgb_fix_remover
     ├── spotify
     |     ├── spotify_installer
     |     └── spotify_remover
     └── pipewire_installer
```
<br>
*  Screenshots of the script :
<br><br>

![Screenshot from 2024-10-13 16-50-11](https://github.com/user-attachments/assets/c4cd2712-afaa-4366-a068-c3b40e73c52b)


![Screenshot from 2024-10-13 16-50-44](https://github.com/user-attachments/assets/af35e621-9c1e-4b51-828e-6555db485295)


![Screenshot from 2024-10-13 16-50-56](https://github.com/user-attachments/assets/62a0657e-f7a8-444b-b470-c3951080818a)

<br>
* DEMO :<br>
Live Script Installation of Conda on Ubuntu 24.04 :
  

https://github.com/user-attachments/assets/cb23403f-8ee3-49e7-bf38-89c38ffed16d




To run the script :
<pre>
    $ git clone https://github.com/MHJedli/utility_script.git
    $ cd utility_script/
    $ bash utility_script.sh
</pre>

> [!NOTE]
> The script is improving by time. Expect new features in the future.
