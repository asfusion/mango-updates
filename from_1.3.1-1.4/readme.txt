These files are intended for automatic updates. I have provided, however, a file in the case you cannot run the automatic upgrades.
Instructions for manual upgrades:
1. Copy only manualUpgrade.cfm, upgrade.cfm and the helpers folder to your blog root (ie: http://yourdomain.com/blog)
2. Run the file manualUpgrade.cfm from your browser.
3. Once that is finished, copy the files: 
From the folder "blog" from the zip to your blog root. 
From the folder "plugins" to your components/plugins directory (or were you have your plugins)
From the components folder to your components folder.
Important: Note that you should not replace entire directories, since the zip only contains files that were changed.
4. Delete the helpers folder, manualUpgrade.cfm and upgrade.cfm files.
5. Restart ColdFusion or try going to your admin>Cache and clicking on Reload Config (this may or may not work, so the best is to 
restart ColdFusion).
6. If you are using the CFFormProtect plugin, go to your admin>Plugins section
and enter this URL into the install/upgrade field http://mangoblog-extensions.googlecode.com/files/cfformprotect_1.1.zip

