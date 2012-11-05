These files are intended for automatic updates. If you cannot run the automatic upgrades, follow these instructions:

1. Copy the folder "helpers" to your blog root.
2. Copy the files "upgrade.cfm" and "manualUpgrade.cfm" to your blog root.
3. Navigate with your browser to http://YOUR_BLOG/manualUpgrade.cfm/
4. Follow instructions there. If everything is fine, you can now copy the files: 
From the folder "blog" from the zip to your blog root. 
From the folder "plugins" to your components/plugins directory (or were you have your plugins)
From the components folder to your components folder.
Important: Note that you should not replace entire directories, since the zip only contains files that were changed.
2. Delete the helpers folder, manualUpgrade.cfm and upgrade.cfm files.
3. Restart ColdFusion or try going to your admin>Cache and clicking on Reload Config.
