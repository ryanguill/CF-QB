<cfcomponent>
	<cfsilent>
	
		<cffunction name="getLibraryContents" access="public" returntype="query" output="false">
			<cfargument name="dsn" type="string" required="True" />
			<cfargument name="library" type="String" required="True" />
			<cfargument name="showIndexes" type="boolean" required="true" />
			
			<cfset VAR qGetLibraryContents = "" />
			
			<cftry>
				<cfquery name="qGetLibraryContents" datasource="#arguments.dsn#">
					SELECT
						  b.schema_text libraryText
						, a.table_name	objectName
						, a.table_name	tableName
						, a.table_text	tableText
						, a.table_type	tableType
					FROM sysibm/sqltables a
					INNER
						JOIN sysibm/sqlschemas b
						ON a.table_schem = b.table_schem
					WHERE
						a.table_schem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.library)#" />
					
					<cfif arguments.showIndexes EQ true>	
						UNION
						
						SELECT 
							  b.schema_text	libraryText
							, a.index_name	objectName
							, a.table_name	tableName
							, ''			tabletext
							, 'INDEX'		tableType
						FROM sysibm/sqlstats a
						INNER
							JOIN sysibm/sqlschemas b
							ON a.table_schem = b.table_schem
						WHERE
							a.table_schem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.library)#" />
						AND
							type <> 0
					</cfif>
					ORDER BY 1 ASC
				</cfquery>
			<cfcatch>
				<cfthrow message="qGetLibraryContents failed" />
			</cfcatch>
			</cftry>
		
		<cfreturn qGetLibraryContents />	
		</cffunction>
	
		<cffunction name="getTableDefinition" access="public" returntype="query" output="false">
			<cfargument name="dsn" type="string" required="True" />
			<cfargument name="library" type="string" requried="True" />
			<cfargument name="table" type="string" requried="True" />
			
			<cfset VAR q = "" />
			
			<cftry>
				<cfquery name="q" datasource="#arguments.dsn#">
					SELECT
						  trim(a.table_schem) 		table_schem
						, trim(a.table_name) 		table_name
						, trim(a.column_name) 		column_name
						, trim(a.column_text) 		column_text
						, a.column_size 			column_size
						, a.data_type 				data_type
						, a.decimal_digits 			decimal_digits
						, a.sql_data_type 			sql_data_type
						, trim(a.type_name) 		type_name
						, trim(b.table_text) 		table_text
						, is_nullable				isNullable
						
						, CASE trim(a.type_name)
							WHEN 'DECIMAL' THEN 
								CASE 
									WHEN a.decimal_digits > 0 
										THEN 'cf_sql_float' 
									ELSE 
										CASE 
											WHEN a.column_size - a.decimal_digits > 6 
												THEN 'cf_sql_bigint' 
											ELSE 
												'cf_sql_integer' 
										END 
								END
							WHEN 'CHAR' THEN 'cf_sql_char'
							WHEN 'INTEGER' THEN 'cf_sql_bigint'
							WHEN 'NUMERIC' THEN 
								CASE 
									WHEN a.column_size - a.decimal_digits > 6 
										THEN 'cf_sql_bigint' 
										ELSE 'cf_sql_integer' 
								END
							ELSE 'cf_sql_varchar'
							END cfsqltype
					FROM sysibm/sqlcolumns a
					INNER
						JOIN sysibm/sqltables b
						ON a.table_name = b.table_name
						AND a.table_schem = b.table_schem
					WHERE
						a.table_schem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.library#" />
					AND
						a.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table#" />
				</cfquery>
			<cfcatch>
				<cfthrow message="q failed" />
			</cfcatch>
			</cftry>
			
		<cfreturn q />
		</cffunction>
		
		<cffunction name="getIndexesOverTable" access="public" returntype="query" output="false">
			<cfargument name="dsn" type="string" required="True" />
			<cfargument name="library" type="string" requried="True" />
			<cfargument name="table" type="string" requried="True" />
			
			<cfset VAR q = "" />
			
			<cftry>
				<cfquery name="q" datasource="#arguments.dsn#">
					SELECT 
						  index_name
						, COUNT(*) columnCount
					FROM sysibm/sqlstats
					WHERE
						table_schem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.library#" />
					AND
						table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table#" />
					AND
						type <> 0
					GROUP BY 
						  index_name
					ORDER BY 1 ASC
				</cfquery>
			<cfcatch>
				<cfthrow message="q failed" />
			</cfcatch>
			</cftry>
			
		<cfreturn q />
		</cffunction>
		
		<cffunction name="getIndexColumns" access="public" returntype="query" output="false">
			<cfargument name="dsn" type="string" required="True" />
			<cfargument name="library" type="String" required="True" />
			<cfargument name="table" type="string" required="True" />
			<cfargument name="index" type="String" required="true" />			
			
			<cfset VAR qIndex = "" />						
							
			<cfquery name="qIndex" datasource="#arguments.dsn#">
				SELECT
					  ind.table_schem			indexTableSchema
					, ind.index_name			indexName
					, ind.ordinal_position		ordinalPosition
					, ind.column_name			indexColumnName
					, ind.asc_or_desc			indexColumnSortOrder
					, ind.non_unique			indexColumnNonUnique
					
				FROM sysibm/sqlstats	ind
				WHERE
					ind.table_schem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.library#" />
				AND
					ind.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table#" />
				AND
					ind.index_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.index#" />
				ORDER BY
					3 ASC		
			</cfquery>
			
		<cfreturn qIndex />
		</cffunction>
		
		
	</cfsilent>
</cfcomponent>