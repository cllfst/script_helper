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
│   ├── flutter_installer
|   └── docker
|         ├── docker_installer
|         └── docker_remover
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

![2024-12-06_20-55](https://github.com/user-attachments/assets/b477c59b-3abb-48a6-b271-4f773477d6fe)

![2024-12-06_20-56](https://github.com/user-attachments/assets/70783455-2701-4052-8593-1c6c1d3f4f82)

![2024-12-06_20-58](https://github.com/user-attachments/assets/bbf11d7c-9129-470c-ad91-43d47513c450)

![2024-12-06_20-59](https://github.com/user-attachments/assets/71beedf6-49f6-4d1f-9f76-59f97c37337a)

![2024-12-06_20-59_1](https://github.com/user-attachments/assets/98aab35c-36b2-4175-89cd-0f7896e58a86)
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
