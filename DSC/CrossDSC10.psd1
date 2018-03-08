@{
    AllNodes = @(
        @{
            NodeName = "DSCAPP" #"CrossS510App"
            Role = "WebServer"
            SiteContents = "C:\NCSCross"
            SiteName     = "NCSCross"
            },
        # @{
        #     NodeName = "CrossS510DB"
        #     Role = "SQLServer"
        #     },
        # @{
        #     NodeName = "CrossXenapp"
        #     Role = "Xenapp"
        #     }
    )
}
# Save ConfigurationData in a file with .psd1 file extension