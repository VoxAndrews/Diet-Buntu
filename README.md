![DietBuntu_LOGO-WHITE](https://github.com/VoxAndrews/Diet-Buntu/assets/26544407/3c2dda9b-d17c-4a4e-a89c-d80fb0a93aae)
# Diet-Buntu - Ubuntu Without the Calories!

## What is this?
Diet-Buntu is a script designed to customise an install of Ubuntu Server Edition, specifically, a Minimal Installation. The purpose of the OS is to be as cut-down and resource-efficient as I could make it with the Linux knowledge I have. It's being used as a learning resource for setting up and using a Linux distribution, as well as for its intended target: older machines with fewer resources.

## Why make this?
I wanted a project and have always been fascinated with things like Tiny Core Linux, so I wanted to try and make something myself for fun. I've tried other Ubuntu distributions but have always had some form of issues with them one way or another, so I wanted to create something that I knew worked perfectly for me, and hopefully, for others!

## What does this have?
I wanted to make sure this came with a few different things so people could have access to a wide range of packages, either from official Ubuntu repositories, unofficial repositories, or built from source. These packages include:

- IceWM
- git
- nano
- VLC
- Polo File Manager
- LibreOffice
- Nitrogen
- Claws Mail
- qView
- galculator
- GNOME Software
- ...And so much more!

## BEFORE INSTALLING
This doesn't come with video drivers (although audio drivers are included), as well as other things you may need. You'll need to do a bit of manual configuration, but I hope what I've provided will give you a good base to work from. Also, this has currently been tested with a single monitor and single drive setup. I'm hoping to test things more extensively in the future, but for now, I can confirm that it's working as intended on Virtual Machines such as Hyper-V and VirtualBox. My hope is to conduct real hardware tests soon, but if others would like to before me, feel free to leave any bugs in the Issues section of the repository.

## Installation
1. Install the version of Ubuntu Server which corresponds to the script that you wish to install (E.g. `Ubuntu Server 22.04` would require `Diet-Buntu-22.04x64_IceWM.sh`). Make sure to select a `Minimal Install` when installing the OS
2. Download the script you need using the `wget` command (E.g. `wget https://github.com/VoxAndrews/Diet-Buntu/raw/main/Scripts/Diet-Buntu-22.04/x64/IceWM/Diet-Buntu-22.04x64_IceWM.sh`)
3. Run the script with `chmod +x` (E.g. `chmod +x Diet-Buntu-22.04x64_IceWM.sh && ./Diet-Buntu-22.04x64_IceWM.sh`). You may need to agree to some prompts and reset some services during installation, the script will let you know when it needs this to be done
4. Follow the prompts and wait for the script to finish!

## AFTER INSTALLING
The script will create a few default folders for you (Pictures, Documents, Videos, etc.) that will be placed into your Home directory. If you want them on another drive, you'll have to manually place them and configure their new locations for now.

## Current Versions
### Ubuntu 22.04 (x64)
#### IceWM (Ice Window Manager)
`wget https://github.com/VoxAndrews/Diet-Buntu/raw/main/Scripts/Diet-Buntu-22.04/x64/IceWM/Diet-Buntu-22.04x64_IceWM.sh`

## Known Bugs
- Installing the OS in a Virtual Machine (E.g. VirtualBox or Hyper-V) and playing some games may cause weird mouse behaviour in-game (E.g. The camera in some First-Person games will spin uncontrollably). Not sure if this will carry over onto real hardware at this time.
- Changing the resolution of the screen with LXRandR will cause the current wallpaper to disappear/revert to the current theme's default.

<details>
<summary><b>Screenshots</b></summary>
<br>
<img src="https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Screenshots/Screenshot1-Background_1.png" width="720">
<img src="https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Screenshots/Screenshot4-Ly_1.png" width="720">
<img src="https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Screenshots/Screenshot5-Desktop_1.png" width="720">
<img src="https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Screenshots/Screenshot5-Desktop_2.png" width="720">
</details>

**Diet-Buntu is not affiliated with Ubuntu and represents a fan-made modification of a pre-existing distribution.**
