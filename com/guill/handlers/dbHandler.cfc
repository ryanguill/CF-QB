<!--- 
===========================================================
Title: 			
FileName: 		
Version:		
Author:			
CreatedOn:		
LastModified:	

Purpose:

Dependancies:

Assumptions:

Outline:


ChangeLog:

===========================================================
 --->

<cfcomponent output="false">
	<cfsilent>
		
		<!--- Constructor Methods --->
		<cffunction name="init" access="public" returntype="any" output="false">
			<cfset createProperties() />
			<cfset setServiceFactory(loadServiceFactory()) />
		<cfreturn This />
		</cffunction>
		
		<!--- Public Methods --->
		
		<!--- Package Methods --->
		
		<!--- Private Methods --->
		
		<cffunction name="getDatasources" access="public" returntype="query" output="no">
			<!--- Get the factory --->
			<cfset VAR factory = getServiceFactory() />
			<!--- Get the datasource service --->
			<cfset VAR dsservice = factory.getdatasourceservice() />
			<!--- define returned query --->
			<cfset VAR results = querynew("name,driver,verified") />
			<cfset VAR valid = true />
			<!--- get datasource service --->
			<cfset VAR dsfull = dsservice.getdatasources()>
			
			<!--- loop through data sources --->
			<cfloop collection="#dsfull#" item="i">
				<cfset valid = true />
				<cftry>
					<cfset result = dsservice.verifydatasource("#i#") />
					<cfcatch type="any">
						<cfset valid = false />
					</cfcatch>
				</cftry>
				
				<cfif valid eq true>
					<!--- add to query --->
					<cfset queryaddrow(results) />
					<cfset querysetcell(results, "name", i) />
					<cfset querysetcell(results, "driver", dsfull[i].driver) />
					<cfset querysetcell(results, "verified", valid) />
				</cfif>
			</cfloop>
			
			<cfquery name="results" dbtype="query">
				SELECT *
				FROM results
				ORDER BY name
			</cfquery>
			<!--- return query --->
			<cfreturn results />
		</cffunction>

		
		<cffunction name="loadServiceFactory" access="private" returntype="any" output="false">
		<cfreturn createObject("java", "coldfusion.server.ServiceFactory") />
		</cffunction>
		
		<cffunction name="setServiceFactory" access="private" returntype="boolean" output="false">
			<cfargument name="serviceFactoryObject" type="any" required="True" />
			
			<cfset variables.properties["ServiceFactory"] = arguments["ServiceFactoryObject"] />
		<cfreturn True />
		</cffunction>
		
		<cffunction name="getServiceFactory" access="private" returntype="any" output="false">
			<cfreturn variables.properties["ServiceFactory"] />
		</cffunction>
		
		<cffunction name="createProperties" access="private" returntype="boolean" output="False">
			<cfset variables.properties = structNew() />
		<cfreturn True />
		</cffunction>
		
	</cfsilent>
</cfcomponent>