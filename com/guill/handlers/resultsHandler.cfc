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
			<cfargument name="maxResultsStored" type="numeric" required="True" />
			
			<cfset createProperties() />
			<cfset setMaxResultsStored(arguments.maxResultsStored) />			
			<cfset createResultsArray() />
			
		<cfreturn This />
		</cffunction>
		
		<!--- Public Methods --->
		<cffunction name="addRecordset" access="public" returntype="boolean" output="False">
			<cfargument name="recordsetID" type="string" required="True" />
			<cfargument name="recordset" type="query" required="True" />
			
			<cfset VAR maxstored = getMaxResultsStored() />
			<cfset VAR nexti = 0 />
			
			<cflock scope="session" timeout="3">
				
				<!--- if the array length is equal to or greater than the max, take the first index out. --->
				<cfif arrayLen(variables.properties.results) GTE maxStored>
					<cfset arrayDeleteAt(variables.properties.results,1) />
				</cfif>
				
				<cfset nexti = arrayLen(variables.properties.results) + 1 />
				
				<!--- add the new recordset to the array --->
				<cfset variables.properties.results[nexti][1] = arguments.recordsetID />
				<cfset variables.properties.results[nexti][2] = arguments.recordset />
				<cfset variables.properties.results[nexti][3] = now() />
			</cflock>
			
		<cfreturn True />	
		</cffunction>
		
		<cffunction name="getRecordsetForID" access="public" returntype="array" output="False">
			<cfargument name="recordsetID" type="string" required="True" />
			
			<cfset VAR output = arrayNew(1) />
			<cfset VAR i = 0 />
			
			<cfloop from="1" to="#arrayLen(variables.properties.results)#" index="i">
				<cfif variables.properties.results[i][1] EQ arguments.recordsetID>
					<cfset output[1] = variables.properties.results[i][1] />
					<cfset output[2] = variables.properties.results[i][2] />
					<cfset output[3] = variables.properties.results[i][3] />					
				</cfif>
			</cfloop>
			
		<cfreturn output />
		</cffunction>
		
		<cffunction name="getMaxResultsStored" access="public" returntype="numeric" output="False">
		
		<cfreturn variables.properties.maxResultsStored />
		</cffunction>
		
		
		
		<!--- Package Methods --->
		
		
		
		<!--- Private Methods --->
		
		<cffunction name="setMaxResultsStored" access="private" returntype="boolean" output="False">
			<cfargument name="maxResultsStored" type="numeric" required="True" />
			
			<cfset variables.properties.maxResultsStored = arguments.maxResultsStored />
		<cfreturn True />
		</cffunction>
		
		<cffunction name="getResultsArray" access="public" returntype="array" output="False">
		
		<cfreturn variables.properties.results />
		</cffunction>
		
		<cffunction name="createResultsArray" access="private" returntype="boolean" output="False">
			
			<cfset variables.properties.results = arrayNew(2) />
		<cfreturn True />
		</cffunction>
		
		<cffunction name="createProperties" access="private" returntype="boolean" output="False">
			<cfset variables.properties = structNew() />
		<cfreturn True />
		</cffunction>
		
	</cfsilent>
</cfcomponent>