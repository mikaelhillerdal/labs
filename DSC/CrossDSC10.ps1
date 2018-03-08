Configuration CrossDSC10
{
    Import-DscResource -Module PSDesiredStateConfiguration
    #Import-DscResource -Module xSqlPs
    Import-DscResource -Module xWebAdministration
    Import-DscResource -Module xdscfirewall

#     Node $AllNodes.Where{$_.Role -contains "MSSQL"}.Nodename
#    {
#         # Install prerequisites
#         WindowsFeature installdotNet35
#         {            
#             Ensure      = "Present"
#             Name        = "Net-Framework-Core"
#             Source      = "c:\software\sxs"
#         }

#         # Install SQL Server
#         xSqlServerInstall InstallSqlServer
#         {
#             InstanceName = $Node.SQLServerName
#             SourcePath   = $Node.SqlSource
#             Features     = "SQLEngine,SSMS"
#             DependsOn    = "[WindowsFeature]installdotNet35"

#         }
#    }

   Node $AllNodes.Where{$_.Role -contains "Web"}.NodeName
   {

        #Disable firewall
        Service WindowsFirewall
        {
            Name = "MPSSvc"
            StartupType = "Automatic"
            State = "Running"
        }

        xDSCFirewall DisablePublic
        {
            Ensure = "Absent"
            Zone = "Public"
            Dependson = "[Service]WindowsFirewall"
        }

        xDSCFirewall DisablePrivate
        {
            Ensure = "Absent"
            Zone = "Private"
            Dependson = "[Service]WindowsFirewall"
        }

        xDSCFirewall DisableDomain
        {
            Ensure = "Absent"
            Zone = "Domain"
            Dependson = "[Service]WindowsFirewall"
        }

        # Install the IIS role
        WindowsFeature IIS
        {
            Ensure       = 'Present'
            Name         = 'Web-Server'
        }

         # Install the ASP .NET 3.5 role
         WindowsFeature AspNet35
         {
             Ensure       = 'Present'
             Name         = 'Web-Asp-Net'
 
         }

         # Install the ASP .NET 3.5 Ext role
         WindowsFeature AspNet35Ext
         {
             Ensure       = 'Present'
             Name         = 'Web-Net-Ext'
   
         }
   
        # Install the ASP .NET 4.5 role
        WindowsFeature AspNet45
        {
            Ensure       = 'Present'
            Name         = 'Web-Asp-Net45'

        }

        # Install the ASP .NET 4.5 Ext role
        WindowsFeature AspNet45Ext
        {
            Ensure       = 'Present'
            Name         = 'Web-Net-Ext45'

        }

         # Install the .NET 3.5 role
         WindowsFeature Framework35
         {
             Ensure       = 'Present'
             Name         = 'NET-Framework-Core'
 
         }

         # Install the .NET 3.5 http role
         WindowsFeature Framework35http
         {
             Ensure       = 'Present'
             Name         = 'NET-HTTP-Activation'
 
         }

         # Install the .NET 4.5 http role
         WindowsFeature Framework45http
         {
             Ensure       = 'Present'
             Name         = 'NET-WCF-HTTP-Activation45'
 
         }

         # Install the wif 3.5 role
         WindowsFeature Wif35
         {
             Ensure       = 'Present'
             Name         = 'Windows-Identity-Foundation'
 
         }


     
        # Stop the default website
        xWebsite DefaultSite 
        {
            Ensure       = 'Present'
            Name         = 'Default Web Site'
            State        = 'Stopped'
            PhysicalPath = 'C:\inetpub\wwwroot'
            DependsOn    = '[WindowsFeature]IIS'

        }

        xWebAppPool NCSCross
        {
            Ensure = 'Present'
            Name = 'NCSCross'
            State = 'Started'
            loadUserProfile = 'True'
            managedPipelineMode = 'Integrated'
            DependsOn = '[WindowsFeature]IIS'
        }

        # Copy the website content
        # File WebContent

        # {
        #     Ensure          = 'Present'
        #     SourcePath      = $Node.SiteContents
        #     DestinationPath = $Node.SitePath
        #     Recurse         = $true
        #     Type            = 'Directory'
        #     DependsOn       = '[WindowsFeature]AspNet45'

        # }       


        # Create the new Website

        xWebsite NewWebsite

        {

            Ensure          = 'Present'
            Name            = $Node.SiteName
            State           = 'Started'
            PhysicalPath    = $Node.SiteContents
            ApplicationPool = 'NCSCross'
            DependsOn       = '[WindowsFeature]IIS'
        }

    }

}

MyWebApp -ConfigurationData CrossDSC10.psd1