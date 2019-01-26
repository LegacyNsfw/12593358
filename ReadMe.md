12593358 is the "Operating System ID" of the software on my 2002 Corvette's Powertrain Control Module (PCM).

The PCM itself is part number 12200411. Widely known as the "411" for short, or the "P01" (WTF?) these can be found in a variety of V8 (and perhaps V6) GM vehicles in the late 1990s and early 2000s.

### Files

**12593358.sanitized.idc** - This is the main thing. It can be loaded into IDA Pro to show you everything I've found so far. 

**12593358.bin** - This is the firmware image from my PCM, as extracted by the PCM Hammer app.

**Reference/12202088.annotated.asm** - This was created by someone who went by the alias Dimented24x7 on a couple of car forums. Nobody has heard from him in a long time, which is unfortunate because he contributed an enormous amount while he was around. This was created from a different operating system for the same PCM, but they're similar enough. This was extremely helpful in the beginning. 

**Reference/12593358.xdf** - This was created by cmaje72, who as I write this is still active on pcmhacking.net. He located a bunch of tables and constants in the PCM, and produced this XDF file for use with Tuner Pro. 

**Reference/PidList.txt** - This was posted to the HPTuners forum in 2003 by a user who went by "beerman" over there. 

**Scripts/Convert-XdfToIdc.ps1** - I wrote this little PowerShell script to convert the tables in the above XDF file to an IDC script, which IDA uses to label the memory locations of those tables and constants.

**Scripts/Generate-PidLabels.ps1** - This uses the parameter IDs and names in PidList.txt (plus the address of an array that was found manually) to label a bunch of functions that look up various parameters. 

